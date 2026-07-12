---
title: Core Libraries & Data Structures
summary: Tier 3 of the Java book — the standard data structures and the contracts that make objects work inside them. Strings in depth and StringBuilder, the Collections Framework (List/Set/Map), the equals/hashCode contract, generics and type erasure, and enums/records/sealed for precise data modeling. Every example compiled and run.
prereqs: []
---

# Core Libraries & Data Structures

This is Tier 3. With [the object model](/synapse/programming-languages/java/classes-and-objects/references-equality-and-the-object-model) behind you, these six chapters give you the standard library's workhorses — the growable, hashed, and sorted collections you'll reach for every day — and the *contracts* that make your own types behave correctly inside them. The thread running through the tier: a collection is only as good as the `equals`/`hashCode` of what you put in it, and the modern type tools (generics, records, sealed) let you model data so the compiler catches mistakes for you.

Six chapters, in order:

1. [**Strings in Depth**](/synapse/programming-languages/java/core-libraries/strings-in-depth) — the cost of immutability, `StringBuilder`, interning, formatting, and text blocks.
2. [**The Collections Framework**](/synapse/programming-languages/java/core-libraries/the-collections-framework) — `List` and program-to-the-interface, the `Iterator`, and choosing an implementation.
3. [**Sets & Maps**](/synapse/programming-languages/java/core-libraries/sets-and-maps) — uniqueness and key→value lookup, hash buckets vs ordering, the counting idiom.
4. [**equals & hashCode**](/synapse/programming-languages/java/core-libraries/equals-and-hashcode) — the contract that makes objects usable as set elements and map keys.
5. [**Generics**](/synapse/programming-languages/java/core-libraries/generics) — type parameters, bounds, wildcards (PECS), and type erasure.
6. [**Enums & Records**](/synapse/programming-languages/java/core-libraries/enums-and-records) — fixed constant sets, immutable data carriers, and a first look at `sealed`.

Every code block with a ▶ Run button is live. The highest-value habit at this tier is to **respect the contracts**: when you put your own type into a `HashSet` or use it as a `HashMap` key, ask whether its `equals`/`hashCode` are correct — and prefer a `record`, which gets them right for free.

> **How to read the Intuition boxes.** Each one is built in three moves: (1) the **mechanism** — what the compiler and the JVM are *actually doing*; (2) a **concrete bite** — a specific, runnable failure (often a real compiler error), shown so the trap is visible; (3) the **earned rule** — the decision heuristic, now justified rather than asserted, plus its cost.
