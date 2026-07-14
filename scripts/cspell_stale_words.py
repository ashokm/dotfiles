#!/usr/bin/env python3
"""Find or remove unused words from .cspell.json."""

from __future__ import annotations

import argparse
import json
import pathlib
import re
import shutil
import subprocess  # nosec B404 - needed for a fixed local git command
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
CSPELL = ROOT / ".cspell.json"
GIT_EXE = shutil.which("git")


def tracked_files() -> list[pathlib.Path]:
    """Return regular, non-symlink Git-tracked files."""
    if not GIT_EXE:
        print("ERROR: git executable not found in PATH.", file=sys.stderr)
        raise SystemExit(2)

    result = subprocess.run(  # nosec B603 - args are static and shell is not used
        [GIT_EXE, "-C", str(ROOT), "ls-files", "-z"],
        check=True,
        capture_output=True,
    )

    return [
        path
        for name in result.stdout.decode(
            "utf-8",
            errors="replace",
        ).split("\0")
        if name
        and (path := ROOT / name).is_file()
        and not path.is_symlink()
        and path != CSPELL
    ]


def build_corpus() -> str:
    """Read tracked UTF-8 text files into a searchable corpus."""
    text: list[str] = []

    for path in tracked_files():
        try:
            text.append(path.read_text(encoding="utf-8"))
        except (OSError, UnicodeDecodeError):
            continue

    return "\n".join(text)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--fix",
        action="store_true",
        help="Remove stale words from .cspell.json",
    )
    args = parser.parse_args()

    data = json.loads(CSPELL.read_text(encoding="utf-8"))
    words = data.get("words", [])
    corpus = build_corpus()

    stale = [
        word
        for word in words
        if re.search(re.escape(word), corpus, re.IGNORECASE) is None
    ]

    if not stale:
        print("No stale CSpell words found.")
        return 0

    print(f"Found {len(stale)} stale CSpell word(s):")

    for word in stale:
        print(f"  - {word}")

    if not args.fix:
        return 1

    stale_words = {word.casefold() for word in stale}
    data["words"] = [word for word in words if word.casefold() not in stale_words]

    CSPELL.write_text(
        json.dumps(data, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )

    print(f"Removed {len(stale)} stale CSpell word(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
