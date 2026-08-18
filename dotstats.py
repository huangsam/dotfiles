#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
import shlex
import sys
from collections import Counter
from pathlib import Path


def parse_defined_names(custom_dir: Path) -> set[str]:
    """Extract alias and function names defined in custom *.zsh files."""
    alias_re = re.compile(r"^\s*alias(?:\s+-[A-Za-z]+)*\s+([A-Za-z0-9_.-]+)=")
    func_re = re.compile(r"^\s*(?:function\s+([A-Za-z0-9_.-]+)|([A-Za-z0-9_.-]+)\s*\(\))")

    names: set[str] = set()
    if not custom_dir.is_dir():
        return names

    for file_path in sorted(custom_dir.glob("*.zsh")):
        try:
            content = file_path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue

        for line in content.splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue

            alias_match = alias_re.match(line)
            if alias_match:
                names.add(alias_match.group(1))
                continue

            func_match = func_re.match(line)
            if func_match:
                name = func_match.group(1) or func_match.group(2)
                if name:
                    names.add(name)

    return names


def count_history_usage(hist_file: Path, defined_names: set[str]) -> Counter[str]:
    """Parse history file and count occurrences of defined names in command positions."""
    counts: Counter[str] = Counter({name: 0 for name in defined_names})

    if not hist_file.is_file() or not defined_names:
        return counts

    delimiters = {
        ";",
        "&&",
        "||",
        "|",
        "&",
        "|&",
        "(",
        ")",
        "{",
        "}",
        "do",
        "then",
        "else",
        "elif",
    }
    prefixes = {
        "sudo",
        "time",
        "noglob",
        "builtin",
        "command",
        "exec",
        "eval",
        "source",
        ".",
        "nohup",
        "xargs",
    }

    try:
        lines = hist_file.read_text(encoding="utf-8", errors="ignore").splitlines()
    except OSError as e:
        print(f"Error reading history file: {e}", file=sys.stderr)
        return counts

    for raw_line in lines:
        line = raw_line.strip()
        if not line:
            continue

        # Strip zsh extended history timestamp (: timestamp:duration;command)
        if line.startswith(": "):
            parts = line.split(";", 1)
            if len(parts) == 2:
                line = parts[1].strip()

        # Tokenize with POSIX shell rules, recognizing punctuation delimiters
        try:
            lexer = shlex.shlex(line, posix=True, punctuation_chars=True)
            lexer.whitespace_split = True
            tokens = list(lexer)
        except ValueError:
            # If line has unclosed quotes or syntax errors, fallback to whitespace split
            tokens = line.split()

        is_command_position = True
        for tok in tokens:
            if tok in delimiters:
                is_command_position = True
                continue

            if is_command_position:
                # Skip environment variable assignments like FOO=bar
                if "=" in tok and not tok.startswith("="):
                    continue

                # Skip wrapper/prefix commands (e.g. sudo, time, source, .)
                if tok in prefixes:
                    continue

                # Clean token of any surrounding non-identifier noise
                clean_tok = re.sub(r"[^A-Za-z0-9_.-]", "", tok)
                if clean_tok in defined_names:
                    counts[clean_tok] += 1

                is_command_position = False

    return counts


def main() -> int:
    script_dir = Path(__file__).resolve().parent
    default_custom_dir = os.environ.get("DOTFILES_CUSTOM", str(script_dir / "custom"))
    default_hist_file = os.environ.get("HISTFILE", os.path.expanduser("~/.zsh_history"))

    parser = argparse.ArgumentParser(description="Rank custom dotfiles aliases and functions by usage count in shell history.")
    parser.add_argument(
        "--custom-dir",
        type=Path,
        default=Path(default_custom_dir),
        help=f"Directory containing custom *.zsh definitions (default: {default_custom_dir})",
    )
    parser.add_argument(
        "--histfile",
        type=Path,
        default=Path(default_hist_file),
        help=f"Path to zsh history file (default: {default_hist_file})",
    )
    parser.add_argument(
        "--unused",
        action="store_true",
        help="Only display unused aliases and functions (count == 0)",
    )

    args = parser.parse_args()

    if not args.custom_dir.is_dir():
        print(f"Error: custom dir not found: {args.custom_dir}", file=sys.stderr)
        return 1

    if not args.histfile.is_file():
        print(f"Error: history file not found: {args.histfile}", file=sys.stderr)
        return 1

    defined_names = parse_defined_names(args.custom_dir)
    if not defined_names:
        print(f"0 defined, 0 used, 0 unused {args.histfile}")
        return 0

    counts = count_history_usage(args.histfile, defined_names)

    # Sort least-used first, then alphabetically
    ranked = sorted(counts.items(), key=lambda item: (item[1], item[0]))

    if args.unused:
        ranked = [item for item in ranked if item[1] == 0]

    for name, count in ranked:
        print(f" {count:5d}    {name}")

    total = len(defined_names)
    used = sum(1 for c in counts.values() if c > 0)
    unused = total - used

    print(f"\n{total} defined, {used} used, {unused} unused {args.histfile}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
