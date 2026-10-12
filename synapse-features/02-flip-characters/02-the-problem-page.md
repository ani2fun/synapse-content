---
title: "The problem page"
summary: "A tour of the two-pane problem page: Description, Editorial, Coach and Submissions on the left; Think, Code and Notes on the right — what each one does, and what needs an account."
---

# The problem page

[Flip Characters](/synapse/synapse-features/flip-characters/flip-characters) is a practice problem, and
opening it gives you a page built for solving rather than reading: two panes, side by side, with a
splitter between them you can drag. This page walks through it.

## The left pane: the problem

| Tab | What is in it |
| --- | --- |
| **Description** | the statement, examples and constraints, with any diagrams and runnable snippets the author added |
| **Editorial** | the worked solutions — often a brute-force approach and an optimal one — each behind a **reveal** card, so you decide when to look. Revealed code has a **copy to editor** button that drops it into the matching language tab on the right |
| **Coach** | a Socratic chat that answers with hints, not solutions, and reads the code you are writing. Off on the live site for now — the tab says "coming soon" |
| **Submissions** | your judged attempts for this problem, newest first, with the verdict and the first failing case. A failing case can be added to your tests with one click |

A ⌘K result that matched a solution opens the page straight on the Editorial tab.

## The right pane: your work

| Tab | What it does | Needs an account? |
| --- | --- | --- |
| **Think** | the design canvas: plan before you code | no — saving a plan does |
| **Code** | the editor, your tests, Run and Submit | to edit and to submit |
| **Notes** | a Markdown scratchpad for this problem | no — syncing does |

### Think

The **Think** tab is an algorithm design canvas: a set of areas to fill in before writing code — the
problem in one sentence, constraints, inputs, what to return, errors and edge cases, ideas with their
complexity, tests, and maintenance. Each area has an ℹ️ that explains what it is for and links the
original write-up the canvas is based on.

What you type is a **draft**, autosaved to this browser, so a half-finished plan survives a reload.
**Save** turns the draft into an entry stored with your account; saved entries are listed under the
canvas and you can load any of them back.

### Code

The editor holds one tab per language the author provided. Signed in, it is editable straight away;
signed out, it is read-only and the Edit and Submit buttons explain how to sign in. **Reset** puts the
author's code back whenever yours differs.

- **Run** executes your code against the sample cases and shows each one's output and verdict. Add
  your own cases in the tests panel; what you type there is kept.
- **Visualise** appears when the code has a visualisation hint, and steps through the run.
- **Submit** sends your solution to the judge, which runs it against the hidden cases too. The result
  arrives in a few seconds and appears under Submissions. An accepted solution marks the problem done.

On the live site, submitting also needs your account on the submit list. Running never does.

### Notes

A Markdown scratchpad, one page per problem. **Write** has a small toolbar that types the Markdown
for you; **Preview** renders it. There is no Save button: every change is kept in this browser at once
and, when you are signed in, pushed to your account a moment later — so your notes follow you to
another device.

## The problem inside a lesson

A problem can also sit *inside* a lesson as a compact card, at the width of the reading column:
Description and Editorial on the left, the editor on the right, and an **Enlarge** button that opens the
same live panes nearly full screen. The embedded card has **Run** but no **Submit** — judging belongs
to the problem's own page.
