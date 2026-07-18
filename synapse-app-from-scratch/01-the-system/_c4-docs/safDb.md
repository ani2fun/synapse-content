---
title: Submissions store
kind: Relational database
technology: PostgreSQL 17
---

## Submissions store

The system of record — and the only thing that grows. Two tables: attempts, and who may make them.

Everything else the platform serves is **derived data** reconstructable from a git repository, which
is why the schema is this small. Books are Markdown on disk, not rows.

The full schema, the check constraint that makes an illegal row unrepresentable, and the story of
adopting a schema created by a different migration tool are all in
[Data design and the schema](/synapse/synapse-app-from-scratch/low-level-design/data-design) —
where the data view lets you click straight into each table's DDL.
