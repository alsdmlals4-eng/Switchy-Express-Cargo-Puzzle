from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
README = ROOT / "README.md"
ACTIVE = ROOT / "기획서" / "00_프로젝트_허브" / "ACTIVE_CONTEXT.md"
GATES = ROOT / "기획서" / "00_프로젝트_허브" / "DEVELOPMENT_GATES.md"
BASE_RULES = ROOT / "docs" / "BASE_RULES_VERSION.md"
ADAPTER = ROOT / "skills" / "PROJECT_BASE_ADAPTER.json"
AUDIT = ROOT / "기획서" / "50_제작_검증" / "SX_AUD_025_POST_MERGE_CANON_FRESHNESS_AND_GATE_RECOVERY.md"


def _read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def test_active_canon_uses_main_and_merged_pr_83() -> None:
    combined = "\n".join((_read(README), _read(ACTIVE), _read(GATES)))

    for stale in (
        "branch: agent/pc-vertical-slice-demo-design",
        "`agent/pc-vertical-slice-demo-design` 브랜치",
        "PR #83: DRAFT",
        "pull_request_83: DRAFT",
        "PR #83은 Draft",
        "MAIN_PENDING",
        "PR #83 MERGE REVIEW: BLOCKED",
    ):
        assert stale not in combined

    for required in (
        "branch: main",
        "pull_request_83: MERGED",
        "PR #83 MERGE: PASS",
        "SX-AUD-025",
        "repository_main_observed",
        "latest_automated_verified_product_main",
        "RETEST_REQUIRED",
    ):
        assert required in combined


def test_base_protection_uses_finite_authority_without_promoting_candidate() -> None:
    rules = _read(BASE_RULES)
    data = json.loads(_read(ADAPTER))

    assert "GMB-002" in rules
    assert "SX-DEC-027~039" in rules
    assert "Base v9.4.3 release pin은 유지" in rules
    assert "현재 제품 보호 권위가 아니다" in rules

    authority = data["current_product_authority"]
    assert authority["decision_batch"] == "GMB-002"
    assert authority["product_kind"] == "FINITE_AUTHORED_DELIVERY_PUZZLE"
    assert authority["demo_decisions"] == ["SX-DEC-037", "SX-DEC-038", "SX-DEC-039"]

    assert data["base_release"]["version"] == "9.4.3"
    assert data["freshness"]["repository_main_observed"] == "212d37e4577a6ffdb7b93e92de6a82785c2976eb"
    assert data["freshness"]["latest_automated_verified_product_main"] == "1339a9467312d0ac680725894a9efb59746ec2cc"
    assert data["gdd_sheet"]["spreadsheet_id"] == "1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo"
    assert data["gdd_sheet"]["declared_sync_status"] == "APPROVED_PENDING_MERGE"

    historical = set(authority["historical_not_current"])
    assert {"ENDLESS_SURVIVAL", "FUEL_ZERO_GAME_OVER", "BOOST", "CAPACITY_8"} <= historical


def test_audit_preserves_manual_evidence_ceiling() -> None:
    text = _read(AUDIT)

    for required in (
        "F143",
        "F144",
        "F145",
        "F146",
        "F147",
        "pc_local_route_and_mid_run_retest: RETEST_REQUIRED",
        "windows_artifact_runtime: NOT_RUN",
        "android_device_smoke: NOT_RUN",
        "production_cutover: BLOCKED",
    ):
        assert required in text

    assert "pc_local_route_and_mid_run_retest: PASS" not in text
    assert "windows_artifact_runtime: PASS" not in text
    assert "android_device_smoke: PASS" not in text
    assert "production_cutover: PASS" not in text
