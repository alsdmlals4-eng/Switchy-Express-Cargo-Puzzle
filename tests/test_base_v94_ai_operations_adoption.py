from __future__ import annotations
import hashlib,json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
class TestBaseV94Switchy(unittest.TestCase):
 def test_identity_registry_routes_and_core(self):
  a=json.loads((ROOT/'skills/PROJECT_BASE_ADAPTER.json').read_text(encoding='utf-8')); r=json.loads((ROOT/'skills/SKILL_REGISTRY.json').read_text(encoding='utf-8'))
  self.assertEqual('9.4.1',a['base_release']['version']); self.assertEqual('3f2c4a624d302b704c1b5322eb5c9f34ad55abb9',a['base_release']['release_commit']); self.assertEqual('ff117d24d5bdb121314e109a6aa9b4f552e0fdc1',a['base_release']['release_evidence_commit']); self.assertEqual('693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59',a['skill_registry']['base']['sha256']); self.assertEqual(hashlib.sha256((ROOT/'skills/SKILL_REGISTRY.json').read_bytes()).hexdigest(),a['skill_registry']['project']['sha256']); self.assertIn('optimizing-ai-model-and-prompt-costs',a['routing']['base_routes']); self.assertIn('optimizing-ai-model-and-prompt-costs',{x['id'] for x in r['skills']}); self.assertEqual(['switchy-express-design'],a['routing']['project_routes']); self.assertEqual(['project.godot','game/**','assets/**','기획서/**'],a['protected_paths'])
 def test_contracts(self):
  ai=(ROOT/'docs/AI_WORKFLOW.md').read_text(encoding='utf-8'); ui=(ROOT/'기획서/40_표현/VISUAL_DIRECTION.md').read_text(encoding='utf-8'); audit=(ROOT/'기획서/50_제작_검증/BASE_V9_4_ADOPTION_AUDIT.md').read_text(encoding='utf-8')
  for x in ('[모델 추천]','HARD_CONSTRAINT','Interface-first','Example-as-Fixture','refresh_trigger','LIFO','NOT_RUN'): self.assertIn(x,ai)
  for x in ('입력 접수','처리 중','중단','즉시 완료','빠른 반복','재진입','재시작','Reduced Motion','mute','haptic-off','권위 시점'): self.assertIn(x,ui)
  self.assertIn('product_logic_changed: false',audit); self.assertIn('HUMAN_NOT_RUN',audit)
if __name__=='__main__': unittest.main()
