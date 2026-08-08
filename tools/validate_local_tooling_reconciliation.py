from __future__ import annotations

import subprocess
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[1]
ALLOWLIST = ROOT / "docs/tooling/asset_vault_legacy_tracked_allowlist.txt"
IGNORE_FILE = ROOT / ".gitignore"
LOCAL_ONLY_PREFIXES = (".asset-vault/", "assets/_vault_local/")


def load_allowlist(path: Path = ALLOWLIST) -> set[str]:
    return {
        line.strip()
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    }


def validate_tracked_paths(tracked_paths: Iterable[str], allowed_paths: set[str]) -> list[str]:
    violations: list[str] = []
    for raw in tracked_paths:
        path = raw.strip().replace("\\", "/")
        if not path:
            continue
        if path.startswith("assets/_vault_local/") or path == "assets/_vault_local":
            violations.append(f"tracked local-only path is forbidden: {path}")
        elif path.startswith(".asset-vault/") or path == ".asset-vault":
            if path not in allowed_paths:
                violations.append(f"tracked asset-vault expansion is forbidden: {path}")
    return violations


def tracked_local_only_paths(project_root: Path = ROOT) -> list[str]:
    result = subprocess.run(
        ["git", "-C", str(project_root), "ls-files", "--", ".asset-vault", "assets/_vault_local"],
        check=True,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    return sorted(line for line in result.stdout.splitlines() if line.strip())


def validate_ignore_rules(project_root: Path = ROOT) -> list[str]:
    lines = {
        line.strip()
        for line in (project_root / ".gitignore").read_text(encoding="utf-8").splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    }
    return [entry for entry in LOCAL_ONLY_PREFIXES if entry not in lines]


def main() -> int:
    allowed = load_allowlist()
    tracked = tracked_local_only_paths()
    errors: list[str] = []

    if len(allowed) != 14:
        errors.append(f"legacy allowlist must contain exactly 14 paths, got {len(allowed)}")
    if any(not path.startswith(".asset-vault/") for path in allowed):
        errors.append("legacy allowlist may contain only .asset-vault paths")

    errors.extend(f"missing .gitignore entry: {entry}" for entry in validate_ignore_rules())
    errors.extend(validate_tracked_paths(tracked, allowed))

    tracked_vault = {path for path in tracked if path.startswith(".asset-vault/")}
    missing_legacy = sorted(allowed - tracked_vault)
    unexpected_legacy = sorted(tracked_vault - allowed)
    if missing_legacy:
        errors.append(f"frozen legacy paths no longer tracked without allowlist reconciliation: {missing_legacy}")
    if unexpected_legacy:
        errors.append(f"new tracked asset-vault paths detected: {unexpected_legacy}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        return 1

    print(
        "local tooling reconciliation: PASS · "
        f"legacy_tracked={len(tracked_vault)} · assets/_vault_local_tracked=0 · "
        "status=LEGACY_TRACKED_PRESERVED"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
