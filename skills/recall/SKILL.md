---
name: recall
description: Discovers, retrieves, and validates context from the hierarchical memory system (global MEMORY.md -> topic MEMORY.md -> detail.md). Employs two-hop index navigation, whole-corpus ripgrep fallback, and strict stale/deprecated filtering while treating memories as verifiable leads.
---

# Recall: Hierarchical Memory Discovery & Retrieval

**Role:** Retrieve, validate, and cite facts from the hierarchical memory system. Works in tandem with `summarize`.

## 1. Memory Roots

Resolve `<memory_root>` in order:

1. **Workspace Memory:** `.agent/memory/`, `.agents/memory/`, or `memory/` at repository root.
2. **Global Memory:** `~/.memory/`.

## 2. Retrieval Protocol: Two-Hop Discovery

Prefer structured index traversal over brute-force search to minimize token usage and maximize precision.

```text
Query ───> [Hop 1: Global MEMORY.md] ───> [Hop 2: Topic MEMORY.md] ───> [Target Detail File]
                     │                                │
                  (Miss)                           (Miss)
                     │                                │
                     └───────────────┬────────────────┘
                                     ▼
                      [Ripgrep Whole-Corpus Fallback]
```

### Hop 1: Global Index Match (`<memory_root>/MEMORY.md`)

1. Read `<memory_root>/MEMORY.md`.
2. Match query intent against topic names, descriptions, and faceted tags (`#env:...`, `#tool:...`, `#topic:...`).
3. Select candidate topic directory (e.g., `macos/`). Proceed to Hop 2.

### Hop 2: Topic Index Match (`<memory_root>/<topic>/MEMORY.md`)

1. Read `<topic>/MEMORY.md`.
2. Inspect `## Active Details`:
    - Match query against titles, subjects, and faceted tags (`#env:*`, `#tool:*`, `#topic:*`).
    - For multi-topic questions, intersect tags across candidates.
    - Check status: skip `[SUPERSEDED]` or `[DEPRECATED]` records unless historical context was requested.
    - Check shelf-life: flag if expired (e.g., `#shelf:volatile` >14 days old).
3. Read the selected detail file `<topic>/<slug>.md`.

## 3. Whole-Corpus Fallback (`ripgrep`)

**Do NOT declare "no memory found" without running fallback search.**

If Hop 1 or Hop 2 misses due to vocabulary mismatch or unindexed notes:

1. Search all markdown files across `<memory_root>` (use tag intersection for multi-topic queries):
    ```bash
    rg -i "<search_terms>" "<memory_root>"
    ```
2. Check matching hits in active details, topic indexes, and `archive/`.
3. **Reconcile Flag:** If `rg` hits an active detail file not listed in `<topic>/MEMORY.md`, flag it for reconciliation by `summarize`.
4. Report "no memory found" only after both Two-Hop Discovery and Ripgrep Fallback return zero hits.

## 4. Invariants & Rules

### 1. Filter Stale & Deprecated Tags

- Skip entries marked `[STALE: YYYY-MM-DD]`, `[DEPRECATED: YYYY-MM-DD]`, or `[SUPERSEDED: ...]`.
- If a stale/superseded entry is the _sole_ match for the query:
    - Disclose the status explicitly:
        > **WARNING (Stale Record):** Marked `[STALE / SUPERSEDED]` on `YYYY-MM-DD`; may no longer reflect current system state.
    - Reference the superseding file if specified.

### 2. Memory is a Lead (Verify Before Acting)

- Treat recalled memory as an investigatory lead, not immutable ground truth.
- Verify paths, branch names, and configs against the current codebase before executing commands based on recalled notes.

### 3. Zero Extrapolation (Honest Gaps)

- If recalled memory does not fully answer the query, state the gap plainly.
- Never hallucinate or extrapolate missing steps.

### 4. Enforce Shelf Life

- When reading detail records, evaluate expiration against current date:
    - `#shelf:volatile`: If >14 days old, treat as potentially invalid.
    - `#shelf:30d` / `#shelf:90d`: Check if version pins or branch references expired.
    - `#shelf:1y` / `#shelf:permanent`: Treat as durable system configuration.

## 5. Output Protocol

When reporting recalled context:

1. **Source:** Cite topic and detail file (`<topic>/<slug>.md`).
2. **Timestamp:** State `Last Updated` date (`YYYY-MM-DD`).
3. **Confidence:** State status tag (`#verified`, `#workaround`, `#unverified`).
4. **Verification:** State whether referenced paths/commands were verified in the active workspace.
