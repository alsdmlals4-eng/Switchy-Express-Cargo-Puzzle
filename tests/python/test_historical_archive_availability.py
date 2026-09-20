"""Archive availability is not package validation; unrelated errors remain fatal."""
import importlib.util
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]


class HistoricalArchiveAvailabilityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        spec = importlib.util.spec_from_file_location("availability", ROOT / "tools/check_historical_archive_availability.py")
        cls.module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(cls.module)

    def fixture(self, number="010"):
        evidence = json.loads((ROOT / f"evidence/acceptance/sx60_poc_accept_{number}_artifact.json").read_text(encoding="utf-8"))
        item = evidence["artifact"]
        metadata = dict(id=item["id"], name=item["name"], expired=False,
                        digest="sha256:" + item["api_digest_sha256"],
                        workflow_run={"id": item["workflow_run_id"]})
        return evidence, metadata

    def test_available_archive_requires_real_verification(self):
        evidence, meta = self.fixture()
        self.assertEqual("AVAILABLE", self.module.classify(evidence, meta))

    def test_exact_retired_archive_expiry_is_not_run(self):
        evidence, meta = self.fixture()
        meta["expired"] = True
        self.assertEqual("NOT_RUN_EXPIRED_HISTORICAL", self.module.classify(evidence, meta))

    def test_unknown_candidate_expiry_is_fatal(self):
        evidence, meta = self.fixture()
        evidence["candidate_id"] = "SX60-POC-ACCEPT-999"
        meta["expired"] = True
        with self.assertRaisesRegex(ValueError, "not an approved historical"):
            self.module.classify(evidence, meta)

    def test_identity_mismatch_is_fatal_even_if_expired(self):
        for field in ("id", "name", "digest", "workflow_run"):
            with self.subTest(field=field):
                evidence, meta = self.fixture()
                meta["expired"] = True
                meta[field] = None
                with self.assertRaises(ValueError):
                    self.module.classify(evidence, meta)

    def test_missing_or_string_expired_flag_is_fatal(self):
        for flag in (None, "false", "true", 0, 1):
            evidence, meta = self.fixture()
            meta["expired"] = flag
            with self.assertRaisesRegex(ValueError, "boolean"):
                self.module.classify(evidence, meta)

    def test_changed_historical_source_cannot_be_exempted(self):
        evidence, meta = self.fixture()
        evidence["artifact"]["workflow_head_sha"] = "0" * 40
        meta["expired"] = True
        with self.assertRaises(ValueError):
            self.module.classify(evidence, meta)

    def test_legacy_003_exact_identity_is_also_retired(self):
        evidence = json.loads((ROOT / "evidence/acceptance/sx59_poc_accept_003_artifact.json").read_text(encoding="utf-8"))
        item = evidence["artifact"]
        meta = dict(id=item["id"], name=item["name"], expired=True,
                    digest="sha256:" + item["api_digest_sha256"],
                    workflow_run={"id": item["workflow_run_id"]})
        self.assertEqual("NOT_RUN_EXPIRED_HISTORICAL", self.module.classify(evidence, meta))

    def test_coercible_numeric_identity_is_still_malformed(self):
        evidence, meta = self.fixture()
        meta["id"] = float(meta["id"])
        with self.assertRaisesRegex(ValueError, "types"):
            self.module.classify(evidence, meta)


if __name__ == "__main__":
    unittest.main()
