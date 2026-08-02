from __future__ import annotations
import json, unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]; ADAPTER=ROOT/'skills/PROJECT_BASE_ADAPTER.json'
PAYLOAD='7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8'; EVIDENCE='da33a350d61b8adc52df97fccc7001708a933370'; FINAL='0b7c94f38d959efc0fc9442274c60b2e268a3c97'
def load(): return json.loads(ADAPTER.read_text(encoding='utf-8'))
class AdoptionTests(unittest.TestCase):
 def test_release_and_route(self):
  a=load(); r=a['base_release']; self.assertEqual(('9.4.3',PAYLOAD,EVIDENCE,FINAL),(r['version'],r['release_commit'],r['release_evidence_commit'],r['finalization_commit'])); self.assertIn('managing-project-intake-and-work-contract',a['routing']['base_routes']); self.assertFalse((ROOT/'skills/managing-project-intake-and-work-contract/SKILL.md').exists())
 def test_first_prompt_and_planning(self):
  a=load(); i=a['shared_overrides']['managing-project-intake-and-work-contract']; f=i['first_prompt_governance']; p=i['planning_first_governance']; self.assertEqual(['route','first-prompt','contract','clarify'],f['instruction_flow']); self.assertEqual('AWAITING_USER_CONFIRMATION',f['unconfirmed_state']); self.assertEqual('REUSE_EXACT_APPROVAL_REFERENCE',f['approval_reuse']); self.assertEqual('base-v9.4.3.lock.json',f['base_release_lock']); self.assertEqual(FINAL,f['base_release_finalization_commit']); self.assertEqual('NOT_RUN',f['actual_project_instruction_execution']); self.assertEqual('base-v9.4.3.lock.json',p['base_release_lock']); self.assertEqual(10,p['max_approved_decisions_per_batch'])
 def test_boundaries(self):
  a=load(); self.assertEqual('SYNCED',a['gdd_sheet']['sync_status']); self.assertEqual(['project.godot','game/**','assets/**','기획서/**'],a['protected_paths']); self.assertEqual('NOT_RUN',a['shared_overrides']['orchestrating-deepseek-worktrees']['actual_external_ai_worktree_execution'])
if __name__=='__main__': unittest.main()
