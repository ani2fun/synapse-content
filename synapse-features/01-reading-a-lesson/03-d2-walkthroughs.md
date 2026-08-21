---
title: "D2 walkthroughs"
summary: "One D2 source, many boards, and a reader who clicks their way down through them."
---

# D2 walkthroughs

The [snippets lesson](./d2-diagrams-snippets) draws one picture per fence. Some diagrams are not
one picture, though — a C4 stack, a zoom-in, a system explained one level at a time. D2 calls
those **layers**, and a source that uses them compiles to a *tree* of boards rather than a single
figure.

D2's own way to show all of them is `--animate-interval`, which cycles through the boards on a
timer nobody can stop. A **walkthrough** hands the reader the wheel instead: click a node to drill
into it, step back out, jump straight to any level.

Try it. Click **URL Shortener** below.

```d2 boards name="c4-url-shortener" root="System Context"
direction: right

classes: {
  external: {
    style: { fill: "#F5F5F5"; stroke: "#777777"; stroke-dash: 3 }
  }
  service: {
    style: { fill: "#E8F1FF"; stroke: "#3B82F6" }
  }
  datastore: {
    style: { fill: "#FFF4D6"; stroke: "#D97706" }
  }
}

user: "Link creator\n[Person]" {
  shape: person
}

visitor: "Link visitor\n[Person]" {
  shape: person
}

shortener: "URL Shortener\n[Software System]" {
  class: service
  link: layers.container
}

dns: "DNS provider" {
  class: external
}

user -> shortener: "Creates short links"
visitor -> dns: "Resolves sho.rt"
visitor -> shortener: "GET /abc123"

layers: {
  container: {
    direction: right

    visitor: "Link visitor" { shape: person }

    cdn: "CDN / WAF\n[Cloudflare]" {
      class: external
    }

    api: "Public API\n[Go service]" {
      class: service
      link: _.layers.component
    }

    redirect: "Redirect service\n[Go service]" {
      class: service
      link: _.layers.component
    }

    redis: "Redis cluster\n[Cache]" {
      class: datastore
      shape: cylinder
    }

    url_store: "URL mappings\n[DynamoDB]" {
      class: datastore
      shape: cylinder
    }

    visitor -> cdn: "GET /{shortCode}"
    cdn -> api: "POST /v1/links"
    cdn -> redirect: "GET /{shortCode}"
    api -> url_store: "Creates mappings"
    redirect -> redis: "Lookup shortCode"
    redirect -> url_store: "Cache miss"
  }

  component: {
    direction: right

    edge: "CDN / API Gateway" {
      class: external
    }

    redirect_api: "Redirect API\n[HTTP handler]" {
      class: service
    }

    handler: "Redirect Handler\n[Application service]" {
      class: service
      link: _.layers.code
    }

    cache: "Mapping Cache\n[Redis repository]" {
      class: datastore
    }

    repo: "URL Mapping Repository\n[DB repository]" {
      class: datastore
    }

    validator: "Short-code Validator" {
      class: service
    }

    edge -> redirect_api: "GET /{shortCode}"
    redirect_api -> handler: "Resolve(shortCode)"
    handler -> validator: "Validate"
    handler -> cache: "GET mapping:{code}"
    handler -> repo: "Read on cache miss"
    handler -> edge: "301 Location"
  }

  code: {
    direction: right

    request: "HTTP Request\nGET /abc123"

    handler: "RedirectHandler" {
      class: service
      validate: "validateShortCode(code)"
      resolve: "resolveMapping(code)"
      respond: "redirect(mapping.longURL)"
    }

    cache_repo: "RedisMappingRepository" {
      class: datastore
      get: "Get(code) -> URLMapping?"
      set: "Set(mapping, ttl)"
    }

    mapping: "URLMapping" {
      shape: sql_table
      short_code: "string [PK]"
      long_url: "string"
      expires_at: "timestamp?"
      status: "active | expired"
    }

    request -> handler.validate: "1. Parse code"
    handler.validate -> handler.resolve: "2. Valid"
    handler.resolve -> cache_repo.get: "3. Lookup"
    cache_repo.get -> mapping: "4. Load"
    cache_repo.get -> cache_repo.set: "5. Populate"
    handler.resolve -> handler.respond: "6. Redirect"
  }
}
```

Four boards, one source. **Enlarge** works too, and the walkthrough stays navigable inside it —
clicking a node in the enlarged view drills down exactly the same way.

## Writing one

Add the `boards` marker to a `d2` fence — so the opening line of the fence above reads
`d2 boards name="c4-url-shortener" root="System Context"`. Without the marker, a `layers:`
diagram renders its root board only and the drill-down links do nothing.

| Marker | What it does |
| --- | --- |
| `boards` | Required. Opts the fence into the walkthrough viewer. |
| `name="…"` | Names the folder the drawn boards are committed to. Optional, but it makes the diff readable. |
| `root="…"` | The first board's title. Layer titles come from their keys; the root has no key. |

Each nested board is a key under `layers:`, and a node becomes clickable by carrying a `link:` to
another board.

## The one thing that trips everyone

**`link:` is resolved against the board it is written in.**

At the top level, `link: layers.container` means "the `container` layer" and works. One level
down — inside `layers.container` — that exact text means `container`'s *own* `component` layer,
which doesn't exist. D2 then **drops the link silently**: no error, no warning, and `d2 validate`
still reports success. The node just quietly stops being clickable.

Use `_` to step up to the parent board:

```bash
layers: {
  container: {
    api: "Public API" {
      link: layers.component      # ✗ silently dropped
      link: _.layers.component    # ✓ `_` is the parent board
    }
  }
}
```

Because the compiler keeps no record of a link it dropped, Synapse checks the *source* when it
draws your diagrams, and tells you exactly where:

```bash
03-d2-walkthroughs.md:71: `link: layers.component` in board root.layers.container
  names no board — did you mean `link: _.layers.component`?
```

Links to real URLs (`https://…`) are left alone and open in a new tab.

## Navigating

| | |
| --- | --- |
| **Click a node** | Drills into the board it links to |
| **‹ ›** | Back and forward through the boards you have visited |
| **⌂** | Straight back to the first board |
| **☰** | Jump to any board by name |
| **← →** | Same as ‹ ›, from the keyboard |
| **Breadcrumb** | Shows where you are; every step in it is clickable |

The board you are looking at is written into the page address, so sending someone the link sends
them to the board you meant. Your browser's own Back button still leaves the lesson in one press —
the diagram never takes it over.

## Drawing your own

The `/d2` editor is the fastest way in: write on the left, drive the result on the right, then
copy the finished fence straight into a lesson.

Boards are drawn once, when the content is published, and the reader's page simply looks them up —
so a walkthrough costs a reader no more than an ordinary diagram, however many boards it holds.
