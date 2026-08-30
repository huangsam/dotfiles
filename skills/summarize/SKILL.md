---
name: summarize
description: Extracts, stamps, and persists durable facts, decisions, and knowledge into a two-hop hierarchical memory system (global MEMORY.md -> topic MEMORY.md -> detail.md). Enforces no-op guards, secrets redaction (type + location only), copy-don't-recall, downgrade-not-delete, and budget archiving.
---

# Summarize: Memory Distillation & Curation

**Role:** Distill durable technical facts, verified configurations, and architectural decisions from the current session into the two-hop memory hierarchy. Works in tandem with `recall`.

## 1. Memory Roots & Hierarchy

Resolve `<memory_root>` in order:

1. **Workspace Memory:** `.agent/memory/`, `.agents/memory/`, or `memory/` at repository root.
2. **Global Memory:** `~/.memory/`.

```text
<memory_root>/
├── MEMORY.md                     # Global Index (Hop 1)
└── <topic>/
    ├── MEMORY.md                 # Topic Index (Hop 2)
    ├── <slug>.md                 # Detail records & runbooks
    └── archive/                  # Budget overflow & superseded notes
        └── <old_slug>.md
```

### Schemas

#### Global Index (`<memory_root>/MEMORY.md`)

```markdown
# Global Memory Index

_Last Reconciled: YYYY-MM-DD_

| Topic           | Directory                 | Description                          | Last Updated | Tags                  |
| :-------------- | :------------------------ | :----------------------------------- | :----------- | :-------------------- |
| **macOS Setup** | [macos/](macos/MEMORY.md) | OS configs, Homebrew, plist services | YYYY-MM-DD   | `#env:macos`, `#brew` |
```

#### Topic Index (`<memory_root>/<topic>/MEMORY.md`)

```markdown
# Topic Memory: <Topic Name>

_Scope: Domain boundary for this topic._
_Last Updated: YYYY-MM-DD_

## Active Details

| Detail File                            | Title / Subject          | Stamped Date | Shelf Life  | Tags                    |
| :------------------------------------- | :----------------------- | :----------- | :---------- | :---------------------- |
| [ollama-service.md](ollama-service.md) | Ollama LaunchAgent Setup | YYYY-MM-DD   | `#shelf:1y` | `#verified`, `#launchd` |

## Archived Records

- [old-workaround.md](archive/old-workaround.md) - [SUPERSEDED: YYYY-MM-DD by ollama-service.md]
```

#### Detail Record (`<memory_root>/<topic>/<slug>.md`)

```markdown
# <Title of Detail>

- **Created:** YYYY-MM-DD
- **Last Updated:** YYYY-MM-DD
- **Shelf Life:** #shelf:volatile | #shelf:30d | #shelf:90d | #shelf:1y | #shelf:permanent
- **Status:** #verified | #unverified | #workaround | [SUPERSEDED: YYYY-MM-DD] | [STALE: YYYY-MM-DD]
- **Tags:** `#tag1`, `#tag2`

## Context

Problem description, environment background, or decision rationale.

## Facts & Execution

Exact commands, paths, flags, configuration snippets.
```

## 2. Invariants & Rules

### 1. No-Op Guard

If the session produced no durable facts, environment configurations, or finalized decisions: **ABORT. Write nothing.**

- **Ignore:** Trivial Q&A, discarded debugging attempts, conversational chatter, standard library lookups.
- **Persist:** Environment quirks, verified runbooks, architectural decisions, secret locations.

### 2. Secrets Hard Rule

**Record location + type ONLY. NEVER write secret values.**

- [OK] `GitHub Personal Access Token located in ~/.vault/tokens.json (key: GITHUB_PAT)`
- [OK] `Stripe API test key configured in environment variable STRIPE_API_KEY`
- [FORBIDDEN] Never write `ghp_...`, `sk_live_...`, raw tokens, private keys, or passwords.

### 3. Copy-Don't-Recall

- Copy exact strings, CLI invocations, flags, and error signatures directly from terminal output or inspected source files.
- Do not paraphrase, retype from memory, or normalize paths without verifying.

### 4. Explicit Date Stamping (`YYYY-MM-DD`)

- All entries, updates, and status tags must include the ISO date (`YYYY-MM-DD`).
- Never use relative dates ("today", "yesterday", "recently").

### 5. Implied Shelf Life

Assign an explicit shelf-life tag to every detail file and topic row:

- `#shelf:volatile`: Transient workarounds or bug mitigations (~7–14 days).
- `#shelf:30d`: Active migration states, feature flags, sprint branches.
- `#shelf:90d`: Third-party dependencies, quarterly API versions.
- `#shelf:1y`: Toolchain setups, OS-level configurations, daemon scripts.
- `#shelf:permanent`: Core domain architecture constraints, invariant business rules.

### 6. Downgrade-Not-Delete

- When existing memory is invalidated or superseded: **DO NOT DELETE IT.**
- Update its status tag and append a concise reason:
    - `[SUPERSEDED: YYYY-MM-DD by <new_slug>.md]`
    - `[STALE: YYYY-MM-DD]` (requires re-verification)
    - `[DEPRECATED: YYYY-MM-DD]`

### 7. Honest Tagging & Standard Prefixes

Tag with exact provenance using standardized facet prefixes:

- `#env:<platform>`: Target OS or shell (e.g., `#env:macos`, `#env:linux`, `#env:zsh`).
- `#tool:<name>`: Specific tool or utility (e.g., `#tool:ollama`, `#tool:docker`, `#tool:git`, `#tool:brew`).
- `#topic:<area>`: Functional domain (e.g., `#topic:networking`, `#topic:auth`, `#topic:launchd`).
- Status tags: `#verified` (tested in session), `#unverified` (discussion/docs only), `#workaround` (temporary patch).
- **Multi-Topic Placement:** Store the physical detail file in the primary topic folder. Index all secondary domains via faceted tags rather than duplicating files.

### 8. Budget & Archiving

Keep topic indexes concise and fast to scan.

- **Trigger:** If `<topic>/` exceeds **15 active detail files** or `MEMORY.md` exceeds **250 lines**:
    1. Move older, superseded, or low-frequency detail files into `<topic>/archive/<slug>.md`.
    2. Move their entries in `<topic>/MEMORY.md` to `## Archived Records` with a 1-line summary.

### 9. Zero Fabrication

- Record only what was observed, executed, or explicitly decided.
- Never invent hypothetical flags, unverified configs, or filler parameters.
- Flag unknown parameters explicitly as `#unverified` or document them as open questions.

### 10. Link & Path Reconciliation

Whenever writing memory:

- Confirm all relative markdown links point to existing files.
- Confirm `<memory_root>/MEMORY.md` links to `<topic>/MEMORY.md`.
- Prune broken links resulting from renamed or archived files.

## 3. Execution Sequence

1. **Gate:** Apply No-Op Guard. Exit immediately if nothing durable occurred.
2. **Locate:** Resolve topic directory or create `<topic>/`.
3. **Draft Detail:** Write `<topic>/<slug>.md` with `YYYY-MM-DD`, shelf-life tag, exact copies, and redacted secrets.
4. **Index Topic:** Add entry to `<topic>/MEMORY.md`. If over budget, move stale files to `archive/`.
5. **Index Global:** Update `<memory_root>/MEMORY.md` row and timestamp.
6. **Reconcile:** Verify all relative markdown links resolve.
