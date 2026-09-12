"""Publication fingerprints survive Git's Windows newline conversion."""
import hashlib
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
TEXT_SUFFIXES = {'.md', '.py', '.json'}


class BlueprintPublicationHashes(unittest.TestCase):
    def test_receipt_declares_text_normalization(self):
        receipt = json.loads((ROOT / 'evidence/design/blueprint-20260911/publication.json').read_text('utf-8'))
        self.assertEqual(receipt.get('hash_policy'), 'SHA256_TEXT_MD_PY_JSON_CRLF_TO_LF_BINARY_RAW')

    def test_all_published_input_fingerprints(self):
        receipt = json.loads((ROOT / 'evidence/design/blueprint-20260911/publication.json').read_text('utf-8'))
        paths = dict(receipt['assets_and_maps'])
        paths.update({receipt['source']: receipt['source_sha256'],
                      'tools/build_blueprint_review_20260911.py': receipt['generator_sha256'],
                      receipt['runtime_receipt']: receipt['runtime_receipt_sha256'],
                      receipt['pdf']: receipt['sha256']})
        for relative, expected in paths.items():
            path = ROOT / relative.replace('\\', '/')
            with self.subTest(path=relative):
                data = path.read_bytes()
                if path.suffix in TEXT_SUFFIXES:
                    data = data.replace(b'\r\n', b'\n')
                self.assertEqual(hashlib.sha256(data).hexdigest(), expected)


if __name__ == '__main__':
    unittest.main()
