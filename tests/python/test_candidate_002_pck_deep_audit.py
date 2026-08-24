from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ARTIFACT = ROOT / "evidence/acceptance/sx59_poc_accept_002_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx59_poc_accept_002_pck_deep_audit.json"
VERIFIER = ROOT / "tools/verify_godot_pck_integrity.py"


class Candidate002PckDeepAuditTests(unittest.TestCase):
    def _read(self) -> tuple[dict, dict]:
        self.assertTrue(ARTIFACT.is_file())
        self.assertTrue(AUDIT.is_file())
        return (
            json.loads(ARTIFACT.read_text(encoding="utf-8")),
            json.loads(AUDIT.read_text(encoding="utf-8")),
        )

    def test_deep_audit_binds_exact_candidate_package_identity(self) -> None:
        artifact, audit = self._read()
        self.assertEqual(audit["candidate_id"], artifact["candidate_id"])
        package = artifact["package"]
        identity = audit["package_identity"]
        self.assertEqual(identity["zip_sha256"], package["zip_sha256"])
        self.assertEqual(identity["windows_exe_sha256"], package["windows_exe_sha256"])
        self.assertEqual(identity["windows_pck_sha256"], package["windows_pck_sha256"])

    def test_pck_integrity_is_complete_and_fail_closed(self) -> None:
        _artifact, audit = self._read()
        pck = audit["pck_integrity"]
        self.assertTrue(VERIFIER.is_file())
        self.assertEqual(pck["verifier"], "tools/verify_godot_pck_integrity.py")
        self.assertEqual(pck["pack_format_version"], 4)
        self.assertEqual(pck["engine_version"], "4.7.1")
        self.assertEqual(pck["file_count"], 470)
        self.assertEqual(pck["verified_entry_count"], pck["file_count"])
        self.assertEqual(pck["md5_mismatch_count"], 0)
        self.assertEqual(pck["bounds_error_count"], 0)
        self.assertTrue(pck["integrity_pass"])

    def test_product_texture_packaging_has_one_ctex_per_import(self) -> None:
        _artifact, audit = self._read()
        textures = audit["product_texture_packaging"]
        self.assertEqual(textures["product_png_import_count"], 73)
        self.assertEqual(textures["unique_referenced_ctex_count"], 73)
        self.assertEqual(textures["missing_ctex_reference_count"], 0)
        self.assertEqual(textures["orphan_packed_ctex_count"], 0)
        self.assertEqual(textures["packaging_crosscheck"], "PASS")

    def test_supplemental_decode_is_not_promoted_to_physical_or_human_proof(self) -> None:
        _artifact, audit = self._read()
        supplemental = audit["supplemental_container_observation"]
        self.assertEqual(supplemental["classification"], "SUPPLEMENTAL_NOT_CI_AUTHORITY")
        self.assertEqual(supplemental["packed_ctex_checked"], 73)
        self.assertEqual(supplemental["embedded_webp_decoded"], 73)
        self.assertEqual(supplemental["decode_failure_count"], 0)
        ceiling = audit["evidence_ceiling"]
        for key in (
            "developer_self_run",
            "windows_physical_runtime",
            "audio_perceptual_qa",
            "android_device",
            "five_person_comprehension",
            "player_experience",
        ):
            self.assertEqual(ceiling[key], "NOT_RUN", f"{key} must remain fail closed")

    def test_audit_scope_does_not_authorize_product_expansion(self) -> None:
        _artifact, audit = self._read()
        scope = audit["scope"]
        self.assertFalse(scope["gameplay_runtime_bytes_changed_by_this_audit"])
        self.assertFalse(scope["image_bytes_changed_by_this_audit"])
        self.assertFalse(scope["audio_bytes_changed_by_this_audit"])
        self.assertFalse(scope["sx_dec_056a_056b_057_058_authorization_changed"])


if __name__ == "__main__":
    unittest.main()
