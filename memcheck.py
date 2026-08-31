#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime
import re
import sys
from pathlib import Path

# Common credential patterns for secrets scan
SECRET_PATTERNS: list[tuple[str, re.Pattern[str]]] = [
    ("GitHub Personal Access Token", re.compile(r"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9_]{36,}\b")),
    ("GitHub Fine-Grained PAT", re.compile(r"\bgithub_pat_[A-Za-z0-9_]{82}\b")),
    ("Stripe API Key", re.compile(r"\b(?:sk|pk)_(?:live|test)_[0-9a-zA-Z]{24,}\b")),
    ("AWS Access Key ID", re.compile(r"\b(?:AKIA|ABIA|ACCA|ASIA)[0-9A-Z]{16}\b")),
    ("Slack Token", re.compile(r"\bxox[baprs]-[0-9]{10,}-[a-zA-Z0-9]+\b")),
    ("Private Key Block", re.compile(r"-----BEGIN (?:RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----")),
    ("Generic Bearer Token", re.compile(r"(?i)\bbearer\s+[a-zA-Z0-9_\-\.]{30,}\b")),
]

# Shelf life duration thresholds in days
SHELF_THRESHOLDS: dict[str, int] = {
    "volatile": 14,
    "30d": 30,
    "90d": 90,
    "1y": 365,
}

MAX_ACTIVE_FILES_PER_TOPIC = 15
MAX_INDEX_LINES_PER_TOPIC = 250


def find_memory_root(explicit_path: str | None) -> Path | None:
    """Resolve the active memory root directory."""
    if explicit_path:
        target = Path(explicit_path).expanduser().resolve()
        return target if target.is_dir() else None

    # Check project workspace roots first
    cwd = Path.cwd()
    for candidate in [".agent/memory", ".agents/memory", "memory"]:
        candidate_path = cwd / candidate
        if candidate_path.is_dir() and (candidate_path / "MEMORY.md").is_file():
            return candidate_path

    # Fall back to global user memory
    global_mem = Path.home() / ".memory"
    if global_mem.is_dir():
        return global_mem

    return None


def scan_secrets(memory_root: Path) -> list[str]:
    """Scan all markdown files for accidental credential leaks."""
    errors: list[str] = []
    for md_file in sorted(memory_root.rglob("*.md")):
        try:
            content = md_file.read_text(encoding="utf-8", errors="ignore")
        except OSError as e:
            errors.append(f"Failed to read {md_file.relative_to(memory_root)}: {e}")
            continue

        for line_num, line in enumerate(content.splitlines(), start=1):
            for name, pattern in SECRET_PATTERNS:
                if pattern.search(line):
                    rel_path = md_file.relative_to(memory_root)
                    errors.append(f"{rel_path}:{line_num}: Potential {name} detected. Follow Secrets Hard Rule (type + location only, no values).")
    return errors


def check_integrity(memory_root: Path) -> list[str]:
    """Check two-hop link validity, orphan detail files, and topic registration."""
    errors: list[str] = []
    global_index = memory_root / "MEMORY.md"

    if not global_index.is_file():
        errors.append("Missing global index: MEMORY.md at memory root.")
        return errors

    # Extract relative markdown links: [text](path)
    link_pattern = re.compile(r"\[([^\]]+)\]\(([^)#]+)(?:#[^)]+)?\)")

    # 1. Check links in Global Index
    try:
        global_content = global_index.read_text(encoding="utf-8", errors="ignore")
    except OSError as e:
        errors.append(f"Failed to read MEMORY.md: {e}")
        return errors

    registered_topics: set[Path] = set()
    for match in link_pattern.finditer(global_content):
        raw_link = match.group(2).strip()
        if raw_link.startswith(("http://", "https://", "mailto:")):
            continue
        target_path = (memory_root / raw_link).resolve()
        if not target_path.exists():
            errors.append(f"MEMORY.md: Broken link '{raw_link}' -> target does not exist.")
        elif target_path.name == "MEMORY.md":
            registered_topics.add(target_path.parent)
        elif target_path.is_dir() and (target_path / "MEMORY.md").is_file():
            registered_topics.add(target_path)

    # 2. Check each topic directory
    topic_dirs = [d for d in memory_root.iterdir() if d.is_dir() and not d.name.startswith((".", "_"))]

    for topic_dir in sorted(topic_dirs):
        topic_index = topic_dir / "MEMORY.md"
        if not topic_index.is_file():
            continue

        if topic_dir.resolve() not in {r.resolve() for r in registered_topics}:
            errors.append(f"Topic not registered in global MEMORY.md: {topic_dir.name}/")

        try:
            topic_content = topic_index.read_text(encoding="utf-8", errors="ignore")
        except OSError as e:
            errors.append(f"Failed to read {topic_dir.name}/MEMORY.md: {e}")
            continue

        # Extract links in topic index
        indexed_files: set[Path] = set()
        for match in link_pattern.finditer(topic_content):
            raw_link = match.group(2).strip()
            if raw_link.startswith(("http://", "https://", "mailto:")):
                continue
            target_path = (topic_dir / raw_link).resolve()
            if not target_path.exists():
                errors.append(f"{topic_dir.name}/MEMORY.md: Broken link '{raw_link}' -> target does not exist.")
            else:
                indexed_files.add(target_path)

        # Orphan detection: active .md files in topic directory not indexed
        for md_file in sorted(topic_dir.glob("*.md")):
            if md_file.name == "MEMORY.md":
                continue
            if md_file.resolve() not in indexed_files:
                errors.append(f"Orphan detail file: {md_file.relative_to(memory_root)} is not indexed in {topic_dir.name}/MEMORY.md")

    return errors


def check_lifecycle_and_budget(memory_root: Path, today: datetime.date | None = None) -> tuple[list[str], list[str]]:
    """Audit topic budgets and shelf-life expiration dates."""
    warnings: list[str] = []
    errors: list[str] = []
    if today is None:
        today = datetime.date.today()

    date_re = re.compile(r"\b(20\d{2}-\d{2}-\d{2})\b")
    shelf_re = re.compile(r"#shelf:(volatile|30d|90d|1y|permanent)\b")

    topic_dirs = [d for d in memory_root.iterdir() if d.is_dir() and not d.name.startswith((".", "_"))]

    for topic_dir in sorted(topic_dirs):
        topic_index = topic_dir / "MEMORY.md"
        if not topic_index.is_file():
            continue

        # Budget check 1: Active detail files
        active_files = [f for f in topic_dir.glob("*.md") if f.name != "MEMORY.md"]
        if len(active_files) > MAX_ACTIVE_FILES_PER_TOPIC:
            warnings.append(
                f"Topic '{topic_dir.name}' has {len(active_files)} active detail files "
                f"(budget <= {MAX_ACTIVE_FILES_PER_TOPIC}). Move older/stale notes to archive/."
            )

        # Budget check 2: Topic MEMORY.md line count
        try:
            line_count = len(topic_index.read_text(encoding="utf-8", errors="ignore").splitlines())
            if line_count > MAX_INDEX_LINES_PER_TOPIC:
                warnings.append(f"{topic_dir.name}/MEMORY.md has {line_count} lines (budget <= {MAX_INDEX_LINES_PER_TOPIC}). Condense index.")
        except OSError:
            pass

        # Shelf-life audit for active detail files
        for md_file in active_files:
            try:
                content = md_file.read_text(encoding="utf-8", errors="ignore")
            except OSError:
                continue

            rel_path = md_file.relative_to(memory_root)

            # Skip if explicitly marked superseded or deprecated
            if "[SUPERSEDED" in content or "[DEPRECATED" in content:
                continue

            # Extract date
            date_match = date_re.search(content)
            if not date_match:
                warnings.append(f"{rel_path}: Missing explicit YYYY-MM-DD date stamp.")
                continue

            try:
                entry_date = datetime.date.fromisoformat(date_match.group(1))
            except ValueError:
                warnings.append(f"{rel_path}: Invalid date format '{date_match.group(1)}'.")
                continue

            age_days = (today - entry_date).days

            # Extract shelf life
            shelf_match = shelf_re.search(content)
            shelf_type = shelf_match.group(1) if shelf_match else None

            if shelf_type and shelf_type in SHELF_THRESHOLDS:
                max_days = SHELF_THRESHOLDS[shelf_type]
                if age_days > max_days:
                    warnings.append(
                        f"{rel_path}: #shelf:{shelf_type} is {age_days} days old (limit {max_days}d). Verify and refresh date, or mark [STALE] / archive."
                    )

    return errors, warnings


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify integrity, security, and lifecycle budgets of hierarchical agent memory.")
    parser.add_argument(
        "path",
        nargs="?",
        default=None,
        help="Path to memory root directory (defaults to .agent/memory, memory/, or ~/.memory)",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Treat warnings as errors (exit code 1 on warnings)",
    )
    args = parser.parse_args()

    memory_root = find_memory_root(args.path)
    if memory_root is None:
        target_display = args.path or ".agent/memory, memory/, or ~/.memory"
        print(f"Error: No valid memory root found at '{target_display}'.", file=sys.stderr)
        print("Usage: python3 memcheck.py [path_to_memory_root]", file=sys.stderr)
        return 1

    print(f"Checking agent memory at: {memory_root}\n")

    # 1. Security scan
    secret_errors = scan_secrets(memory_root)
    if secret_errors:
        print("[1/3] Secrets Scan: FAIL")
        for err in secret_errors:
            print(f"  ERROR: {err}")
    else:
        print("[1/3] Secrets Scan: PASS (No credentials detected)")

    # 2. Integrity & link check
    integrity_errors = check_integrity(memory_root)
    if integrity_errors:
        print("[2/3] Hierarchy & Link Integrity: FAIL")
        for err in integrity_errors:
            print(f"  ERROR: {err}")
    else:
        print("[2/3] Hierarchy & Link Integrity: PASS (All links resolve, zero orphans)")

    # 3. Lifecycle & budget audit
    lifecycle_errors, lifecycle_warnings = check_lifecycle_and_budget(memory_root)
    total_errors = len(secret_errors) + len(integrity_errors) + len(lifecycle_errors)
    total_warnings = len(lifecycle_warnings)

    if lifecycle_errors or lifecycle_warnings:
        status_label = "FAIL" if lifecycle_errors else "WARN"
        print(f"[3/3] Lifecycle & Budget Audit: {status_label}")
        for err in lifecycle_errors:
            print(f"  ERROR: {err}")
        for warn in lifecycle_warnings:
            print(f"  WARNING: {warn}")
    else:
        print("[3/3] Lifecycle & Budget Audit: PASS (All shelf-lives and budgets valid)")

    # Final Summary
    print("\n" + "=" * 50)
    print(f"Summary: {total_errors} error(s), {total_warnings} warning(s)")
    print("=" * 50)

    if total_errors > 0:
        return 1
    if args.strict and total_warnings > 0:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
