from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"


class SXDec067CandidateFreshnessTests(unittest.TestCase):
    def test_pointer_binds_an_exact_sx_dec_067_package_after_mint(self) -> None:
        pointer = json.loads(POINTER.read_text(encoding="utf-8"))

        self.assertEqual("PREPARED_PACKAGE_VERIFIED", pointer["candidate_status"])
        self.assertEqual("SX60-POC-ACCEPT-007", pointer["current_candidate_id"])
        self.assertEqual(
            "c0bb86efa5bad6050217ca67dd6aa9eba155dc75",
            pointer["minimum_product_source_main"],
        )
        self.assertEqual(
            "SX60-POC-ACCEPT-006",
            pointer["historical_superseded_after_sx_dec_067"]["candidate_id"],
        )
        self.assertEqual(
            "HISTORICAL_SUPERSEDED_BY_SX_DEC_067_PLAYER_FACING_PRODUCT_BYTE_CHANGE",
            pointer["historical_superseded_after_sx_dec_067"]["role"],
        )
        self.assertEqual(
            "FINAL_USER_REVIEW_ON_UNCHANGED_SX60_POC_ACCEPT_007",
            pointer["current_next_action"],
        )
