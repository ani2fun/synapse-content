---
title: "Accounts and contributing"
summary: "What signing in adds, what your account keeps and how to erase it, private books, proposing an edit from inside the app, and the admin screen that runs it all."
---

# Accounts and contributing

Synapse is built to be read without an account. Reading, running code, the visualiser and the labs all
work signed out. This page is about the parts that need you to sign in.

## Signing in

**Sign in** in the header takes you to the identity provider, where you sign in with GitHub. Synapse
never sees a password. Once you are back, the header shows your name, and these come alive:

| Feature | Signed out | Signed in |
| --- | --- | --- |
| ✓ progress | kept in this browser | kept with your account, on every device |
| Notes | kept in this browser | synced to your account |
| Think canvases | the draft only, in this browser | saved entries kept with your account |
| Code editor on problem pages | read-only | editable |
| Submitting to the judge | — | yes, if your account is on the submit list |
| Private books | hidden | visible, if you are on the book's reader list |
| Suggest an edit | visible, disabled | live, if you are on the content-editor list |
| Run budget | smaller time limits, a per-address rate limit | full time limits, a per-account rate limit |

## Your account

`/account` shows who you are signed in as, and a list of the edits you have proposed with links to their
pull requests (if you have proposed any). Below that is a **danger zone** of permanent actions, each
behind a confirmation:

- **Reset progress** — clears your ✓ ticks and nothing else.
- **Erase submissions** — deletes your judged attempts.
- **Erase all data** — submissions, saved canvases, notes and progress.
- **Delete account** — erases all of that, then deletes your sign-in, then signs you out.

Which lessons people read is counted without recording who read them, so there is nothing about your
reading history to erase.

## Private books

Some books are private: served only to the people on their reader list. If you are on one, it appears
at the top of the library once you sign in, in its own group. Its pages, images and widgets are all
behind the same check — signed out you get a sign-in prompt, signed in without access you get a "no
access" page, and nothing about it is cached for anyone else.

## Proposing an edit

Every lesson has **Suggest an edit**; every diagram has an **Edit** pill. If you are on the
content-editor list, they open an editor for that lesson — `/edit/<lesson path>` — with the whole file,
frontmatter included.

Submitting is three steps, and you cannot skip the first:

1. **Preview** — the lesson rendered exactly as a reader will see it.
2. **Changes** — a diff of what you changed.
3. **Details** — a short description, then **Submit**.

Mistakes that would break the page — a deleted frontmatter fence, a lesson with no title — disable
Submit and link to the line. Warnings are shown but do not block.

Submitting opens a **pull request** against the repository that owns the lesson, from a branch named
after you and the page. A second edit to the same page while that pull request is open adds a commit to
it rather than opening another. Nothing goes live until a maintainer reviews and merges it; then it
reaches readers by the ordinary content pipeline, within about a minute.

You can only edit existing lessons this way — not create files, upload media, or change `book.json`.
For those, or for larger changes, contribute to the content repository directly; the
[authoring reference](/synapse/synapse-features/appendices/authoring-reference) is the full spec, and
`validate_book` checks a repository before you push.

## The admin screen

`/admin` is for the people listed as administrators. Every action is checked again on the server, so
anyone else who opens it sees only "Admin only". It has four sections:

| Section | Manages |
| --- | --- |
| **Submit allowlist** | who may save judged submissions |
| **Content editors** | who may propose edits |
| **Content repositories** | which repositories feed the library: register, remove, sync now; each row shows its last fetch, its commit and any error; warnings below list books two sources both claim |
| **Readers** (per repository) | who may read a private repository |

The two allowlists are separate on purpose. Saving judged attempts spends shared compute; proposing
edits opens pull requests on a public repository under the platform's own token. Granting one must never
grant the other.

Lesson-view counts — which lessons get opened — are readable by admins through the API.
