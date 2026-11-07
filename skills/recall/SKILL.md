---
name: recall
description: Discovers, retrieves, and validates context from the hierarchical memory system (global MEMORY.md -> topic MEMORY.md -> detail.md). Employs two-hop index navigation, section-aware routing (active, evergreen, reference), whole-corpus ripgrep fallback, and strict stale/deprecated filtering while treating memories as verifiable leads.
---

# Recall: Hierarchical Memory Discovery & Retrieval

**Role:** Retrieve, validate, and cite facts from the hierarchical memory system. Works in tandem with `persist`.

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
2. Match query intent against the three operational sections:
   - **`## 1. Active Focus Areas`**: In-flight projects, current migrations, active debugging.
   - **`## 2. Evergreen System Knowledge`**: OS configs, toolchains, permanent repo rules, core runbooks.
   - **`## 3. Reference Catalogs & Cheatsheets`**: Syntax lookups, CLI flag cheat sheets, vendor specs.
   *(Completed `done` topics are excluded from L1 to prevent context pollution).*
3. Select candidate topic directory (e.g., `clickhouse/` or `macos/`). Proceed to Hop 2.

### Hop 2: Topic Index Match (`<memory_root>/<topic>/MEMORY.md`)

1. Read `<topic>/MEMORY.md`.
2. Check `_State:` in header (`active`, `evergreen`, `reference`, `done`).
3. Inspect `## Active Details` (or `## Final Records`):
   - Match query against titles, subjects, and faceted tags (`#env:*`, `#tool:*`, `#topic:*`).
   - For multi-topic questions, intersect tags across candidates.
   - Check status: skip `[SUPERSEDED]`, `[DEPRECATED]`, or `[STALE]` records unless historical context was requested.
   - Check shelf-life:
     - In **`active`** topics: flag if expired (e.g., `#shelf:volatile` >14 days old).
     - In **`evergreen`** or **`reference`** topics: **do not** treat age as decay.
4. Read the selected detail file `<topic>/<slug>.md`.

## 3. Whole-Corpus Fallback (`ripgrep`)

**Do NOT declare "no memory found" without running fallback search.**

If Hop 1 or Hop 2 misses due to vocabulary mismatch, unindexed notes, or retrospective historical questions:

1. Search all markdown files across `<memory_root>` (use tag intersection for multi-topic queries):
   ```bash
   rg -i --glob '*.md' "<search_terms>" "<memory_root>"
   ```
2. Check matching hits in active details and topic indexes; check `archive/` only per the Archive Access Policy below.
3. **Handling `done` topics found via fallback:**
   - If a search hits a topic marked `_State: done_`, treat its contents as **historical retrospective only**.
   - **Never** adopt a temporary workaround or migration shim from a `done` project as current operational practice.
4. **Reconcile Flag:** If `rg` hits an active detail file not listed in `<topic>/MEMORY.md`, flag it for reconciliation by `persist`.
5. Report "no memory found" only after both Two-Hop Discovery and Ripgrep Fallback return zero hits.

### Historical Intent Detection

- Use historical mode proactively when the query contains intent such as "why did we," "previous decision," "old migration," "completed project," "historical context," "what happened during," "retrospective," or "before we changed."
- In historical mode, search living topics first for current framing, then search `done` topics and `archive/`.
- Clearly label results as historical/completed.
- Do not present old workarounds as current operational practice unless explicitly requested.

### Fallback Search Discipline

- Prefer markdown files only:
  ```bash
  rg -i --glob '*.md' "<search_terms>" "<memory_root>"
  ```
- First list matching files before reading full contents:
  ```bash
  rg -il --glob '*.md' "<search_terms>" "<memory_root>"
  ```
- Read only the most relevant files.
- Do not dump entire archives into context unless explicitly requested.

### Archive Access Policy

Do not read `archive/` by default for current operational questions. Read `archive/` only when:

- the topic index links to it as superseded context,
- historical mode is active,
- fallback search finds no living match,
- or the user explicitly asks for archived/historical material.

### Reconciliation Flag Format

When recall finds orphaned or unindexed memory, append a concise maintenance note:

> **Reconciliation needed:** `<topic>/<slug>.md` exists but is not listed in `<topic>/MEMORY.md`. Should `persist` index it?

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

### 4. Secrets Hard Rule (Recall Side)

- Never output secret values from memory, even if they were accidentally persisted.
- If a detail file contains only location/type information (e.g., "API token lives in `~/.config/foo/token`"), return that safely.
- If a recalled snippet appears to contain a raw token/password/private key, redact the value as `[REDACTED]` and state that secret values are not reproduced from memory.

### 5. Conflict Resolution Precedence

When multiple memories conflict, prefer in this order:

1. Non-superseded over `[SUPERSEDED]`, `[STALE]`, or `[DEPRECATED]`.
2. `#verified` over `#unverified` or `#workaround`.
3. Newer `Last Updated` date over older date.
4. Living topic (`active`, `evergreen`, `reference`) over `done`/archive for current operational questions.
5. Exact detail file over index summary.

If conflict remains material after applying precedence, disclose both sources and ask which should be treated as authoritative.

### 6. Exact Snippet Reproduction

- When returning commands, config snippets, paths, flags, SQL, or error signatures, quote the stored text exactly when possible.
- Do not normalize casing, punctuation, or path separators unless explicitly asked to summarize.
- If summarizing, clearly separate the summary from the exact quoted snippet.

### 7. Enforce Shelf Life (Active Topics Only)

- When reading detail records, evaluate expiration against current date:
  - In **`active`** topics:
    - `#shelf:volatile`: If >14 days old, treat as potentially invalid.
    - `#shelf:30d` / `#shelf:90d`: Check if version pins or branch references expired.
    - **Opportunistic Maintenance:** If recalling an active topic containing stale notes, prompt the user with a 1-line check: *"Note `<slug>.md` is expired. Should we refresh, mark the topic `_State: done_`, or prune it?"*
  - In **`evergreen`** and **`reference`** topics:
    - Treat `#shelf:1y` / `#shelf:permanent` as durable system configuration. Do not flag as expired due to elapsed time.

## 5. Output Protocol

When reporting recalled context:

1. **Source:** Cite topic and detail file (`<topic>/<slug>.md`).
2. **State & Timestamp:** State topic state (`active`, `evergreen`, `reference`, `done`) and `Last Updated` date (`YYYY-MM-DD`).
3. **Confidence:** State status tag (`#verified`, `#workaround`, `#unverified`).
4. **Verification:** State whether referenced paths/commands were verified in the active workspace.
