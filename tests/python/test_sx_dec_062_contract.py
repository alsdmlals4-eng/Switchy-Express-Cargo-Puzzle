from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DECISION = ROOT / "docs/decisions/SX_DEC_062_BOARD_FIRST_RUNTIME_COMPOSITION.md"
SPEC = ROOT / "docs/superpowers/specs/2026-08-28-board-first-runtime-composition-design.md"
PLAN = ROOT / "docs/superpowers/plans/2026-08-28-board-first-runtime-composition.md"
HANDOFF = ROOT / "기획서/50_제작_검증/SX_DEC_062_CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF.md"
ACTIVE = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
REGISTRY = ROOT / "기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class SxDec062ContractTests(unittest.TestCase):
    def test_contract_owners_exist_and_preserve_runtime_boundary(self) -> None:
        for path in (DECISION, SPEC, PLAN, HANDOFF):
            self.assertTrue(path.is_file(), f"missing SX-DEC-062 owner: {path}")

        decision = read(DECISION)
        handoff = read(HANDOFF)
        self.assertIn("RUNTIME_UNCHANGED", decision)
        self.assertIn("Issue #227", decision)
        self.assertIn("No new raster asset", decision)
        self.assertIn("T2", handoff)
        self.assertIn("Preserve v02 in T2", handoff)

    def test_plan_is_existing_asset_board_composition_only(self) -> None:
        plan = read(PLAN)
        for required in (
            "DemoPalette.CONTROL_DECK_RAISED",
            "TUTORIAL_FOCUS",
            "PreflightPanel",
            "STATION_SERVICE",
            "ROUTE",
            "art/product_assets/**",
            "runtime_visual_manifest.json",
            "do not implement or close Issue #227",
        ):
            self.assertIn(required, plan)

        self.assertLess(plan.index("STATION_SERVICE"), plan.index("ROUTE"))
        self.assertIn("IMPLEMENTATION_NOT_STARTED", read(SPEC))

    def test_current_canon_routes_the_approved_contract(self) -> None:
        active = read(ACTIVE)
        decisions = read(DECISIONS)
        self.assertIn("current_decisions: SX-DEC-027~063", active)
        self.assertIn("sx_dec_062_runtime_composition: MERGED_MAIN_VERIFIED · PR_237", active)
        self.assertIn("SX_DEC_062_CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF.md", active)
        self.assertIn("current_decision_span: SX-DEC-027~063", decisions)
        self.assertIn("sx_dec_062_runtime_composition: MERGED_MAIN_VERIFIED · PR_237", decisions)
        self.assertIn("SX-DEC-063", decisions)

        registry = json.loads(read(REGISTRY))
        document_ids = {document["id"] for document in registry["documents"]}
        self.assertIn("SX-DEC-062-BOARD-FIRST-RUNTIME-COMPOSITION", document_ids)
        self.assertIn("SX-DEC-062-IMPLEMENTATION-CONTRACT", document_ids)


if __name__ == "__main__":
    unittest.main()
