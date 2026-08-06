from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from typing import Any, Sequence


ROOT = Path(__file__).resolve().parents[1]
MATERIALIZER_PATH = ROOT / "tools/materialize_switchy_godot_live_editor_pilot.py"
CONTRACT_PATH = ROOT / "tools/godot-live-editor-pilot/pilot_contract.py"
BASE_SOURCE_PATH = ROOT / "tools/godot-live-editor-pilot/BASE_SOURCE.json"
SOURCE_BASELINE_PATH = ROOT / "tools/godot-live-editor-pilot/SOURCE_BASELINE.json"
RUNTIME_RESULT_RELATIVE = Path(
    "artifacts/godot-live-editor/switchy_real_project_pilot_result.json"
)
SUMMARY_PATTERN = re.compile(
    r"TEST SUMMARY: cases=(?P<cases>\d+) failed=(?P<failed>\d+) assertions=(?P<assertions>\d+)"
)
HEADLESS_THUMBNAIL_ERROR = 'ERROR: Parameter "t" is null.'
HEADLESS_THUMBNAIL_LOCATION = (
    "texture_2d_get (./servers/rendering/dummy/storage/texture_storage.h:110)"
)
REQUIRED_RUNTIME_FLAGS = (
    "scene_inspect_pass",
    "dirty_rename_pass",
    "dirty_undo_pass",
    "saved_rename_pass",
    "saved_undo_restore_pass",
    "stale_state_block_pass",
    "request_hash_block_pass",
    "expired_approval_block_pass",
    "approval_binding_block_pass",
    "result_hash_pass",
    "queue_capacity_pass",
    "batch_64_pass",
    "temporary_scene_byte_restore_pass",
)
ADVERSARIAL_CODES = {
    "stale_code": "TARGET_STATE_CONFLICT",
    "request_hash_code": "REQUEST_HASH_MISMATCH",
    "expired_approval_code": "APPROVAL_EXPIRED",
    "approval_binding_code": "APPROVAL_BINDING_MISMATCH",
}


def _load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"module unavailable: {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(65536), b""):
            digest.update(block)
    return digest.hexdigest()


def _write_report(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def _is_exact_headless_thumbnail_error(lines: list[str], index: int) -> bool:
    if lines[index].strip() != HEADLESS_THUMBNAIL_ERROR:
        return False
    following = "\n".join(line.strip() for line in lines[index + 1 : index + 4])
    return HEADLESS_THUMBNAIL_LOCATION in following


def _headless_thumbnail_error_count(stream: str) -> int:
    lines = stream.splitlines()
    return sum(
        1
        for index, line in enumerate(lines)
        if line.strip() == HEADLESS_THUMBNAIL_ERROR
        and _is_exact_headless_thumbnail_error(lines, index)
    )


def _unexpected_godot_errors(stream: str) -> list[str]:
    lines = stream.splitlines()
    unexpected: list[str] = []
    for index, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("SCRIPT ERROR:"):
            unexpected.append(stripped)
        elif stripped.startswith("ERROR:") and not _is_exact_headless_thumbnail_error(
            lines, index
        ):
            unexpected.append(stripped)
    return unexpected


def _contains_godot_error(*streams: str) -> bool:
    return any(_unexpected_godot_errors(stream) for stream in streams)


def _failure(
    code: str,
    *,
    detail: str = "",
    diagnostics: dict[str, Any] | None = None,
    production_adapter_ready: bool = False,
) -> dict[str, Any]:
    payload: dict[str, Any] = {
        "status": "FAIL",
        "code": code,
        "detail": detail,
        "production_adapter_ready": production_adapter_ready,
    }
    if diagnostics is not None:
        payload["diagnostics"] = diagnostics
    return payload


def _validate_runtime_result(payload: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    if payload.get("status") != "PASS":
        errors.append(f"status={payload.get('status')}")
    for flag in REQUIRED_RUNTIME_FLAGS:
        if payload.get(flag) is not True:
            errors.append(f"{flag}=false")
    for key, expected in ADVERSARIAL_CODES.items():
        if payload.get(key) != expected:
            errors.append(f"{key}={payload.get(key)!r}")
    if payload.get("network_listener_enabled") is not False:
        errors.append("network_listener_enabled")
    if payload.get("batch_64_completed") != 64:
        errors.append(f"batch_64_completed={payload.get('batch_64_completed')}")
    if payload.get("ledger_states") != ["COMPLETED", "COMPLETED"]:
        errors.append(f"ledger_states={payload.get('ledger_states')!r}")
    if payload.get("production_adapter_ready") is not False:
        errors.append("production_adapter_ready")
    for key in (
        "original_scene_sha256",
        "restored_scene_sha256",
        "saved_scene_sha256",
    ):
        value = payload.get(key)
        if not isinstance(value, str) or not re.fullmatch(r"[0-9a-f]{64}", value):
            errors.append(f"{key}=invalid")
    if payload.get("original_scene_sha256") != payload.get("restored_scene_sha256"):
        errors.append("restored_scene_sha256_mismatch")
    return errors


def _environment(workspace: Path) -> dict[str, str]:
    environment = os.environ.copy()
    home = workspace / "home"
    temporary = workspace / "tmp"
    home.mkdir(parents=True, exist_ok=True)
    temporary.mkdir(parents=True, exist_ok=True)
    environment.update(
        {
            "HOME": str(home),
            "TMPDIR": str(temporary),
            "TMP": str(temporary),
            "TEMP": str(temporary),
        }
    )
    return environment


def run_pilot(
    *,
    godot: Path | None,
    preserve_failure: bool = False,
) -> tuple[int, dict[str, Any]]:
    if godot is None:
        return 0, {
            "status": "SKIPPED_NOT_CONFIGURED",
            "code": "GODOT_BIN_REQUIRED",
            "production_adapter_ready": False,
        }
    godot = godot.expanduser().resolve()
    if not godot.is_file():
        return 1, _failure("GODOT_BIN_NOT_FOUND")

    try:
        version_run = subprocess.run(
            [str(godot), "--version"],
            check=False,
            capture_output=True,
            text=True,
            timeout=30,
        )
    except subprocess.TimeoutExpired:
        return 2, _failure("RUNTIME_TIMEOUT", detail="Godot version timeout")
    version = version_run.stdout.strip()
    if version_run.returncode != 0 or "4.7.1" not in version:
        return 1, _failure("GODOT_VERSION_MISMATCH", detail=version)

    contract = _load_module(CONTRACT_PATH, "switchy_pilot_runner_contract")
    materializer = _load_module(MATERIALIZER_PATH, "switchy_pilot_runner_materializer")
    base_source = contract.load_json(BASE_SOURCE_PATH)
    source_baseline = contract.load_json(SOURCE_BASELINE_PATH)
    source_before = contract.protected_inventory(ROOT)
    workspace = Path(tempfile.mkdtemp(prefix="switchy-live-editor-pilot-"))
    project = workspace / "project"
    failed = True
    try:
        materialization_started = time.perf_counter_ns()
        try:
            materialized = materializer.materialize(ROOT, project)
        except Exception as error:
            return 1, _failure("MATERIALIZATION_FAILED", detail=str(error))
        materialization_usec = (
            time.perf_counter_ns() - materialization_started
        ) // 1000

        environment = _environment(workspace)
        editor_started = time.perf_counter_ns()
        try:
            editor = subprocess.run(
                [
                    str(godot),
                    "--editor",
                    "--headless",
                    "--path",
                    str(project),
                    "--quit-after",
                    "900",
                ],
                check=False,
                capture_output=True,
                text=True,
                timeout=240,
                env=environment,
            )
        except subprocess.TimeoutExpired:
            return 2, _failure("RUNTIME_TIMEOUT", detail="Editor Pilot timeout")
        editor_wall_usec = (time.perf_counter_ns() - editor_started) // 1000
        editor_output = editor.stdout + "\n" + editor.stderr
        if editor.returncode != 0:
            return 1, _failure(
                "RUNTIME_RESULT_INVALID",
                detail=f"editor_exit={editor.returncode}\n{editor_output[-4000:]}",
            )

        runtime_result_path = project / RUNTIME_RESULT_RELATIVE
        if not runtime_result_path.is_file():
            unexpected = _unexpected_godot_errors(editor_output)
            detail = "runtime result missing"
            if unexpected:
                detail += "|" + "|".join(unexpected)
            return 1, _failure("RUNTIME_RESULT_MISSING", detail=detail)
        try:
            runtime = json.loads(runtime_result_path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, UnicodeDecodeError) as error:
            return 1, _failure("RUNTIME_RESULT_INVALID", detail=str(error))
        if not isinstance(runtime, dict):
            return 1, _failure("RUNTIME_RESULT_INVALID", detail="JSON object required")

        headless_thumbnail_error_count = _headless_thumbnail_error_count(editor_output)
        runtime_errors = _validate_runtime_result(runtime)
        if runtime_errors:
            return 1, _failure(
                "RUNTIME_RESULT_INVALID",
                detail="|".join(runtime_errors),
                diagnostics={
                    "editor_runtime": runtime,
                    "headless_thumbnail_error_count": headless_thumbnail_error_count,
                },
            )

        unexpected_editor_errors = _unexpected_godot_errors(editor_output)
        if unexpected_editor_errors:
            return 1, _failure(
                "RUNTIME_RESULT_INVALID",
                detail="|".join(unexpected_editor_errors),
                diagnostics={
                    "editor_runtime": runtime,
                    "headless_thumbnail_error_count": headless_thumbnail_error_count,
                },
            )
        runtime["headless_thumbnail_error_count"] = headless_thumbnail_error_count

        regression_started = time.perf_counter_ns()
        try:
            regression = subprocess.run(
                [
                    str(godot),
                    "--headless",
                    "--path",
                    str(project),
                    "--script",
                    "res://tests/run_tests.gd",
                ],
                check=False,
                capture_output=True,
                text=True,
                timeout=180,
                env=environment,
            )
        except subprocess.TimeoutExpired:
            return 2, _failure("RUNTIME_TIMEOUT", detail="project regression timeout")
        regression_wall_usec = (
            time.perf_counter_ns() - regression_started
        ) // 1000
        regression_text = regression.stdout + "\n" + regression.stderr
        summary = SUMMARY_PATTERN.search(regression_text)
        if (
            regression.returncode != 0
            or _contains_godot_error(regression.stdout, regression.stderr)
            or summary is None
            or int(summary.group("failed")) != 0
        ):
            return 1, _failure(
                "PROJECT_REGRESSION_FAILED",
                detail=regression_text[-4000:],
                diagnostics={"editor_runtime": runtime},
            )

        source_after = contract.protected_inventory(ROOT)
        source_integrity_pass = source_after == source_before
        if not source_integrity_pass:
            return 1, _failure(
                "SOURCE_INTEGRITY_FAILURE",
                diagnostics={"editor_runtime": runtime},
            )

        runtime["source_integrity_pass"] = True
        runtime["project_regression_pass"] = True
        payload = {
            "status": "PASS",
            "code": "OK",
            "source_commit": source_baseline.get("baseline_commit"),
            "base_adapter_commit": base_source.get("commit"),
            "godot_version": version,
            "godot_executable_sha256": _sha256_file(godot),
            "materialization": {
                "status": "PASS",
                "duration_usec": materialization_usec,
                "project_godot_sha256": materialized.project_godot_sha256,
                "target_scene_sha256": materialized.target_scene_sha256,
                "project_fingerprint": materialized.project_fingerprint,
            },
            "editor_runtime": runtime,
            "project_regression": {
                "status": "PASS",
                "cases": int(summary.group("cases")),
                "failed": int(summary.group("failed")),
                "assertions": int(summary.group("assertions")),
                "duration_usec": regression_wall_usec,
            },
            "protected_source_integrity": {
                "status": "PASS",
                "file_count": len(source_before),
            },
            "performance_measurement": {
                "editor_process_wall_usec": editor_wall_usec,
                "pilot_elapsed_usec": runtime.get("elapsed_usec"),
                "batch_64_elapsed_usec": runtime.get("batch_64_elapsed_usec"),
            },
            "limitations": {
                "headless_dummy_thumbnail_errors_observed": headless_thumbnail_error_count,
                "headless_dummy_thumbnail_error_policy": (
                    "KNOWN_EXACT_GODOT_DUMMY_RENDERER_SAVE_THUMBNAIL_ERROR_ONLY"
                ),
                "windows_runtime": "NOT_RUN",
                "android_device": "NOT_RUN",
                "physical_input": "NOT_RUN",
                "human_usability": "HUMAN_NOT_RUN",
                "external_transport": "NOT_IMPLEMENTED",
                "mcp_profile": "NOT_IMPLEMENTED",
            },
            "production_adapter_ready": False,
        }
        failed = False
        return 0, payload
    finally:
        if failed and preserve_failure:
            print(f"preserved failed Pilot workspace: {workspace}", file=sys.stderr)
        else:
            shutil.rmtree(workspace, ignore_errors=True)


def _parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run the isolated Switchy Godot live-editor real-project Pilot."
    )
    parser.add_argument("--godot", type=Path)
    parser.add_argument("--report", required=True, type=Path)
    parser.add_argument("--preserve-failure", action="store_true")
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = _parse_args(argv)
    exit_code, payload = run_pilot(
        godot=args.godot,
        preserve_failure=args.preserve_failure,
    )
    _write_report(args.report, payload)
    print(json.dumps(payload, ensure_ascii=False))
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
