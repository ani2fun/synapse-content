---
title: "Ports and adapters in code"
summary: "C4 level 4: one small context — notes — read from the router to the SQL, to show what a port, an adapter and the wiring between them actually look like in this codebase."
essential: true
---

# Ports and adapters in code

> **You'll be able to:** read any context in the origin by following the same four steps; say where
> each kind of rule lives — input checks, persistence rules, status codes; and explain what "the
> adapter is concrete, the port is generic" means in Rust.

Level 3 drew boxes. Level 4 opens one of them. The example is `notes` — the Notes tab on the problem
page — because it is the smallest context with every part present: about 360 lines in
`server/src/notes/`, of which 34 are tests.

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

tab: "Notes tab\n[browser]" { class: client }
http: "http.rs\n[routes, DTOs, status codes]" { class: edge }
port: "mod.rs\n[NoteStore trait, NotesError, check_length]" { class: svc }
adapter: "postgres.rs\n[PostgresNoteStore]" { class: data }
main: "main.rs\n[wiring]" { class: svc }
db: "problem_notes" { class: data; shape: cylinder }

tab -> http: "PUT /api/notes"
http -> port: "check_length, then NoteStore::put"
adapter -> port: "implements" { style.stroke-dash: 3 }
adapter -> db: "upsert"
main -> adapter: "constructs with the pool"
main -> http: "hands it to the router state"
```

## 1 · The port and the rules (`mod.rs`)

The port is a trait the context declares and never implements:

```rust
/// Where notes land (native AFIT + a concrete adapter, per RS001 — nothing varies at runtime).
pub trait NoteStore: Send + Sync {
    fn get(&self, user_id: &str, lesson_path: &str)
        -> impl Future<Output = Result<Option<NoteDto>, NotesError>> + Send;

    /// Replace the note (insert or update) and hand back the stored row — `updated_at` is the
    /// store's clock, not the caller's. Empty `text` deletes the note and returns `None`.
    fn put(&self, user_id: &str, lesson_path: &str, text: &str)
        -> impl Future<Output = Result<Option<NoteDto>, NotesError>> + Send;

    fn erase_all_for(&self, user_id: &str)
        -> impl Future<Output = Result<usize, NotesError>> + Send;
}
```

Three things to read off it:

- **The signatures are the use cases**, not the SQL: get one note, replace one note, erase all of a
  user's notes. Nothing says "upsert".
- **The contract carries the subtle rule**: an empty save is a delete, and the stored `updated_at` is
  the store's clock. A second adapter would have to honour both.
- **Native `async fn` in traits** (`impl Future` in the return position), not `#[async_trait]`. Nothing
  varies at runtime, so the port is generic and dispatch is static —
  [the server hexagon](/synapse/synapse-features/components/the-server-hexagon) argues that choice.

Beside the trait sit the context's error and its one input rule:

```rust
pub enum NotesError {
    TooLong { len: usize, max: usize },   // → 400
    StoreFailed(String),                  // → 500
}

/// Counted in UTF-16 code units because that is what the textarea's `maxLength` counts.
pub fn check_length(text: &str) -> Result<(), NotesError> { … }
```

The length rule counts **UTF-16 code units**, not `char`s, because the browser's `maxLength` does.
Counting characters would accept notes the client can never produce, and disagree with it for text
outside the Basic Multilingual Plane. A rule written once, at the boundary, in the units the other
side uses.

## 2 · The adapter (`postgres.rs`)

`PostgresNoteStore` owns a connection pool and implements the trait with three queries. The save is
the interesting one:

```rust
async fn put(&self, user_id: &str, lesson_path: &str, text: &str) -> Result<Option<NoteDto>, NotesError> {
    if text.is_empty() {
        // delete from problem_notes where user_id = $1 and lesson_path = $2
        return Ok(None);
    }
    // `returning *` so `updated_at` in the reply is the one actually stored — the client
    // records it as the version its local copy is based on.
    let row = sqlx::query(
        "insert into problem_notes (user_id, lesson_path, body) values ($1, $2, $3) \
         on conflict (user_id, lesson_path) \
         do update set body = excluded.body, updated_at = now() \
         returning *",
    ) …
}
```

One statement does the upsert, and `returning *` hands back the row as stored. That timestamp matters
outside the server: the browser keeps it as the **base** its local copy started from, so it can tell
later whether anyone else has written since. The adapter is where the database's clock becomes part of
the sync protocol.

Everything database-shaped stays here: `sqlx`, the row mapping, the path stored `/`-joined and split
back into segments on read. A `sqlx::Error` never leaves the file — it becomes `NotesError::StoreFailed`.

## 3 · The inbound adapter (`http.rs`)

```rust
.route("/api/notes", get(get_note).put(save_note).delete(erase_all))

async fn save_note(State(state): State<NotesRoutesState>, headers: HeaderMap,
                   Json(request): Json<SaveNoteRequestDto>) -> ApiResult<NoteDto> {
    let Some(user) = caller_user(&state, &headers).await? else {
        return Err(needs_token("Saving a note"));
    };
    check_length(&request.text).map_err(|error| to_error(&error))?;
    let path: Vec<String> = request.path.into_iter().filter(|s| !s.is_empty()).collect();
    let joined = path.join("/");
    match state.notes.put(&user.id.0, &joined, &request.text).await {
        Ok(note) => Ok((StatusCode::OK, Json(note.unwrap_or_else(|| empty_note(path))))),
        Err(error) => Err(to_error(&error)),
    }
}
```

The handler does the four things an inbound adapter does, in order: **who is calling** (through the
identity context's application service — never its HTTP adapter), **is the input acceptable** (the
domain rule from step 1), **call the port**, and **map the result** to a status and a DTO. The mapping
is an exhaustive match: `TooLong` → 400, `StoreFailed` → 500. A new variant fails the build until
someone decides its status.

The DTOs — `SaveNoteRequestDto`, `NoteDto` — live in the `shared` crate, so they also appear in the
OpenAPI document and in the generated TypeScript types:
[The shared contract](/synapse/synapse-features/code/the-shared-contract).

## 4 · The wiring (`main.rs` and `lib.rs`)

Nothing in `notes/` names the concrete adapter except the adapter itself. `main.rs` builds one
`PostgresNoteStore` with the pool and puts it in `AppDeps`; `lib.rs::app()` hands it to
`NotesRoutesState` and merges `notes::http::routes(...)` into the API router, next to every other
context. Wiring happens once, at the composition root.

## Reading any other context

The same four steps work for every context in the origin:

| Step | Look for | In `notes` | In `submission` |
| --- | --- | --- | --- |
| port and rules | `pub trait`, the error enum | `mod.rs` | `application/mod.rs` (four ports), `domain/` (the state machine) |
| adapter | `impl <Port> for` | `postgres.rs` | `infrastructure/` |
| inbound adapter | `.route(`, the status match | `http.rs` | `http/` |
| wiring | `AppDeps`, `app()` | `main.rs`, `lib.rs` | the same |

Bigger contexts add layers — a `domain/` directory, an `application/` service — but never change the
direction: the HTTP adapter calls inward, the infrastructure adapter implements inward, and the
middle names neither.
