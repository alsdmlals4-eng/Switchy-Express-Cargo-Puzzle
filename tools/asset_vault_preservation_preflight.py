from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


DECISION_ID = "SX-DEC-052"


def _is_within(path: Path, root: Path) -> bool:
    try:
        path.relative_to(root)
        return True
    except ValueError:
        return False


def validate_output_path(output_path: Path, project_root: Path) -> Path:
    root = project_root.resolve()
    resolved = output_path.resolve()
    forbidden = [root / ".asset-vault", root / "assets/_vault_local"]
    if any(_is_within(resolved, blocked.resolve()) for blocked in forbidden):
        raise ValueError("preservation report output must be outside local-only vault roots")
    return resolved


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def build_inventory(vault_root: Path, project_root: Path) -> dict:
    root = project_root.resolve()
    vault = vault_root.resolve()
    entries: list[dict] = []
    if vault.is_dir():
        for path in sorted(item for item in vault.rglob("*") if item.is_file()):
            resolved = path.resolve()
            try:
                relative = resolved.relative_to(root).as_posix()
            except ValueError:
                relative = resolved.as_posix()
            entries.append(
                {
                    "path": relative,
                    "size": resolved.stat().st_size,
                    "sha256": _sha256(resolved),
                }
            )
    return {
        "decision_id": DECISION_ID,
        "preservation_status": "inventory_only",
        "vault_present": vault.is_dir(),
        "vault_root": (
            vault.relative_to(root).as_posix()
            if _is_within(vault, root)
            else vault.as_posix()
        ),
        "entries": entries,
        "backup_verified": False,
        "safe_to_untrack": False,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Inventory the local asset vault without mutating or deleting vault files."
    )
    parser.add_argument("--project-root", type=Path, default=Path.cwd())
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    project_root = args.project_root.resolve()
    payload = build_inventory(project_root / ".asset-vault/library", project_root)
    rendered = json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n"
    if args.output is None:
        print(rendered, end="")
    else:
        output = validate_output_path(args.output, project_root)
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(rendered, encoding="utf-8")
        print(f"inventory report written: {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
