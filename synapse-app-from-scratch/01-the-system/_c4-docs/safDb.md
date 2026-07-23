---
title: Application store
kind: Relational database
technology: PostgreSQL 17
---

## Application store

The system of record — and the only thing that grows. Six small tables in three pairs: attempts and
who may make them, what a reader has finished and what gets read, and who may propose a content
change plus what they proposed.

Everything else the platform serves is **derived data** reconstructable from a git repository, which
is why the schema is this small. Books are Markdown on disk, not rows — and in-app editing did not
change that, because its two tables hold a branch name, never a lesson.

The full schema, the check constraint that makes an illegal row unrepresentable, and the story of
adopting a schema created by a different migration tool are all in
[Data design and the schema](/synapse/synapse-app-from-scratch/low-level-design/data-design) —
where the data view lets you click straight into each table's DDL.
