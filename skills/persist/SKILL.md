---
name: persist
description: Extracts, stamps, and persists durable facts, decisions, and knowledge into a two-hop hierarchical memory system (global MEMORY.md -> topic MEMORY.md -> detail.md). Enforces topic lifecycles (active, evergreen, reference, done), no-op guards, secrets redaction (type + location only), copy-don't-recall, downgrade-not-delete, and budget archiving.
---

# Persist: Memory Distillation & Curation

**Role:** Distill durable technical facts, verified configurations, and architectural decisions from the current session into the two-hop memory hierarchy. Works in tandem with `recall`.

## 1. Memory Roots & Hierarchy

Resolve `<memory_root>` in order:

1. **Workspace Memory:** `.agent/memory/`, `.agents/memory/`, or `memory/` at repository root.
2. **Global Memory:** `~/.memory/`.

```text
<memory_root>/
├── MEMORY.md                     # Global Index (Hop 1 - Living topics only)
└── <topic>/
    ├── MEMORY.md                 # Topic Index (Hop 2 - Declares _State: ..._)
    ├── <slug>.md                 # Detail records & runbooks
    └── archive/                  # Budget overflow & superseded notes
        └── <old_slug>.md
```

### Schemas

#### Global Index (`<memory_root>/MEMORY.md`)

The L1 Global Index functions as an **Operational Dispatch Table**, structured in priority sections. It lists **only** living topics (`active`, `evergreen`, `reference`). Completed (`done`) topics are excluded to prevent LLM state conflict and context pollution.

```markdown
# Global Memory Index

_Last Reconciled: YYYY-MM-DD_

## 1. Active Focus Areas
| Topic | State | Directory | Description | Last Updated | Tags |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ClickHouse Sharding** | `active` | [clickhouse/](clickhouse/MEMORY.md) | Sharding migration & memory tuning | YYYY-MM-DD | `#tool:clickhouse` |

## 2. Evergreen System Knowledge
| Topic | State | Directory | Description | Last Updated | Tags |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **macOS Setup** | `evergreen` | [macos/](macos/MEMORY.md) | OS configs, Homebrew, plist services | YYYY-MM-DD | `#env:macos`, `#brew` |

## 3. Reference Catalogs & Cheatsheets
| Topic | State | Directory | Description | Last Updated | Tags |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Postgres Syntax** | `reference` | [postgres/](postgres/MEMORY.md) | Window functions, EXPLAIN cheat sheet | YYYY-MM-DD | `#tool:postgres` |
```

#### Topic Index (`<memory_root>/<topic>/MEMORY.md`)

Topic header prominently declares its operational state: `_State: active | evergreen | reference | done_`.

```markdown
# Topic Memory: <Topic Name>

_State: active_
_Scope: Domain boundary for this topic._
_Last Updated: YYYY-MM-DD_

## Active Details

| Detail File                            | Title / Subject          | Stamped Date | Shelf Life  | Tags                    |
| :------------------------------------- | :----------------------- | :----------- | :---------- | :---------------------- |
| [ollama-service.md](ollama-service.md) | Ollama LaunchAgent Setup | YYYY-MM-DD   | `#shelf:1y` | `#verified`, `#launchd` |

## Archived Records

- [old-workaround.md](archive/old-workaround.md) - [SUPERSEDED: YYYY-MM-DD by ollama-service.md]
```

When a topic completes:
```markdown
# Topic Memory: <Topic Name>

_State: done_
_Scope: Historical record of completed migration/project._
_Completed: YYYY-MM-DD_

## Final Records
...
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

### 1. Topic Lifecycles & States (Judgment-Based)

Every topic belongs to one of four lifecycle states:

- **`active`**: Current in-flight projects, WIP investigations, active migrations.
  - *Audit:* Strict stale countdowns (`#shelf:*`), detail file caps (`<=15`), line limits (`<=250`).
- **`evergreen`**: Durable system axioms, OS configurations, shell runbooks, core architecture principles.
  - *Audit:* Index line budget (`<=250`), secrets, link integrity. **Exempt from stale expiration.**
- **`reference`**: External specs, vendor documentation, API cheat sheets, syntax manuals.
  - *Audit:* Secrets, link integrity. **Exempt from stale expiration and file caps.**
- **`done`**: Shipped milestones, completed projects, retrospectives, historical ADRs.
  - *Audit:* **Excluded from L1**. Secrets scan and relative link integrity only.

### 2. The Three Exit Vectors (Promote, DM, Delete)

Non-active topics are not decaying fruit to be polished on a timer; they are finished products on a loading dock:

1. **Promote to Something Bigger:** When an `evergreen` runbook or `reference` spec stabilizes across multiple tasks, promote it out of private agent memory into the repository `docs/`, `README.md`, or company wiki.
2. **DM Someone With Me:** When an active task completes (`done`), synthesize the final notes into a handoff artifact (PR description, Slack release summary, peer onboarding note).
3. **Delete Me (Garbage Collection):** When temporary scaffolding notes have served their purpose and the resulting code is merged and verified in production, delete the directory (`rm -rf <topic>/`). No L1 edits or reconciliation needed.

### 3. No-Op Guard

If the session produced no durable facts, environment configurations, or finalized decisions: **ABORT. Write nothing.**

- **Ignore:** Trivial Q&A, discarded debugging attempts, conversational chatter, standard library lookups.
- **Persist:** Environment quirks, verified runbooks, architectural decisions, secret locations.

### 4. Secrets Hard Rule

**Record location + type ONLY. NEVER write secret values.**

- [OK] `GitHub Personal Access Token located in ~/.vault/tokens.json (key: GITHUB_PAT)`
- [OK] `Stripe API test key configured in environment variable STRIPE_API_KEY`
- [FORBIDDEN] Never write `ghp_...`, `sk_live_...`, raw tokens, private keys, or passwords.

### 5. Copy-Don't-Recall

- Copy exact strings, CLI invocations, flags, and error signatures directly from terminal output or inspected source files.
- Do not paraphrase, retype from memory, or normalize paths without verifying.

### 6. Explicit Date Stamping (`YYYY-MM-DD`)

- All entries, updates, and status tags must include the ISO date (`YYYY-MM-DD`).
- Never use relative dates ("today", "yesterday", "recently").

### 7. Implied Shelf Life

Assign an explicit shelf-life tag based on topic state:

- In **`active`** topics: Explicit decaying shelf-life tags are mandatory (`#shelf:volatile`, `#shelf:30d`, `#shelf:90d`, `#shelf:1y`). **`#shelf:permanent` is forbidden in active topics** (an active project cannot be permanent; either assign a decaying timer or reclassify the topic as `evergreen`).
- In **`evergreen`** and **`reference`** topics: Notes default to `#shelf:permanent` or `#shelf:1y`.
- In **`done`** topics: Notes are frozen historical records.

### 8. Opportunistic Maintenance

During active engineering sessions, if an agent touches an `active` topic that contains expired or stale notes, it should opportunistically prompt the user with a concise one-liner:
> *"Note: `<topic>/<slug>.md` is past its shelf-life. Should we refresh its date, mark the topic `_State: done_`, or prune it?"*

### 9. Downgrade-Not-Delete (Within Living Topics)

- When existing memory within a living topic is invalidated or superseded: **DO NOT DELETE IT.**
- Update its status tag and append a concise reason:
    - `[SUPERSEDED: YYYY-MM-DD by <new_slug>.md]`
    - `[STALE: YYYY-MM-DD]` (requires re-verification)
    - `[DEPRECATED: YYYY-MM-DD]`

### 10. Honest Tagging & Standard Prefixes

Tag with exact provenance using standardized facet prefixes:

- `#env:<platform>`: Target OS or shell (e.g., `#env:macos`, `#env:linux`, `#env:zsh`).
- `#tool:<name>`: Specific tool or utility (e.g., `#tool:ollama`, `#tool:docker`, `#tool:git`, `#tool:brew`).
- `#topic:<area>`: Functional domain (e.g., `#topic:networking`, `#topic:auth`, `#topic:launchd`).
- Status tags: `#verified` (tested in session), `#unverified` (discussion/docs only), `#workaround` (temporary patch).

### 11. Budget & Archiving

Keep topic indexes concise and fast to scan.

- **Trigger:** If an **`active`** `<topic>/` exceeds **15 active detail files** or `MEMORY.md` exceeds **250 lines**:
    1. Move older, superseded, or low-frequency detail files into `<topic>/archive/<slug>.md`.
    2. Move their entries in `<topic>/MEMORY.md` to `## Archived Records` with a 1-line summary.
- **Reference Exemption:** `reference` topics are exempt from the 15-file cap (only the 250-line index limit applies).

### 12. Zero Fabrication

- Record only what was observed, executed, or explicitly decided.
- Never invent hypothetical flags, unverified configs, or filler parameters.

### 13. Link & Path Reconciliation

Whenever writing memory:

- Confirm all relative markdown links point to existing files.
- Living topics (`active`, `evergreen`, `reference`) must be registered in `<memory_root>/MEMORY.md`.
- Completed (`done`) topics must be unlisted from `<memory_root>/MEMORY.md`.

## 3. Execution Sequence

1. **Gate:** Apply No-Op Guard. Exit immediately if nothing durable occurred.
2. **Locate & Classify:** Resolve topic directory or create `<topic>/` with judgment-based state (`active`, `evergreen`, `reference`).
3. **Draft Detail:** Write `<topic>/<slug>.md` with `YYYY-MM-DD`, appropriate shelf-life tag, exact copies, and redacted secrets.
4. **Index Topic:** Add entry to `<topic>/MEMORY.md`. If active topic is over budget, move stale files to `archive/`.
5. **Index Global:** If living topic, update `<memory_root>/MEMORY.md` under its respective section. If completed (`done`), remove from L1.
6. **Reconcile:** Verify all relative markdown links resolve.
