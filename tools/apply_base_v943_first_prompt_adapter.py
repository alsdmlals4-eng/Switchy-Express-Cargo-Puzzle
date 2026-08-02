from __future__ import annotations
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]; A=ROOT/'skills/PROJECT_BASE_ADAPTER.json'
P='7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8'; E='da33a350d61b8adc52df97fccc7001708a933370'; F='0b7c94f38d959efc0fc9442274c60b2e268a3c97'
a=json.loads(A.read_text(encoding='utf-8')); a['base_release'].update({'version':'9.4.3','release_commit':P,'release_evidence_commit':E,'finalization_commit':F}); i=a.setdefault('shared_overrides',{}).setdefault('managing-project-intake-and-work-contract',{}); p=i.get('planning_first_governance');
if isinstance(p,dict): p['base_release_lock']='base-v9.4.3.lock.json'; p['base_release_finalization_commit']=F
i['first_prompt_governance']={'actual_project_instruction_execution':'NOT_RUN','approval_reuse':'REUSE_EXACT_APPROVAL_REFERENCE','base_contract_source':'skills/managing-project-intake-and-work-contract/SKILL.md','base_release_finalization_commit':F,'base_release_lock':'base-v9.4.3.lock.json','direction_anchor_reference':'skills/managing-project-intake-and-work-contract/references/first-prompt-direction-anchoring.md','instruction_flow':['route','first-prompt','contract','clarify'],'l0_exceptions':['TYPO','OBVIOUS_FORMAT','IDENTICAL_VALIDATION_RERUN'],'unconfirmed_state':'AWAITING_USER_CONFIRMATION'}
cmd='python tests/test_base_v943_first_prompt_adoption.py'; validators=a.setdefault('validators',[]); commands={x if isinstance(x,str) else x.get('command') for x in validators};
if cmd not in commands: validators.append({'command':cmd,'status':'REQUIRED_ON_PULL_REQUEST','evidence_commit':None})
A.write_text(json.dumps(a,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
old={'dd705d7f48a7919187bc0507610ba5fc5b43a658':P,'0c6cdd128bf1f5782e96b3a6240c9585f8d1ef6d':E,'ac9466edc2d93b59f274c9ac55ca719eba2809e3':F}
paths=list((ROOT/'tests').rglob('*.py'))+[ROOT/'tools/validate_project_contract.py']
for path in paths:
 if not path.is_file(): continue
 text=path.read_text(encoding='utf-8')
 if 'PROJECT_BASE_ADAPTER.json' not in text and 'base_release' not in text: continue
 updated=text
 for before,after in old.items(): updated=updated.replace(before,after)
 updated=updated.replace('"9.4.2"','"9.4.3"').replace("'9.4.2'","'9.4.3'").replace('base-v9.4.2.lock.json','base-v9.4.3.lock.json')
 if updated!=text: path.write_text(updated,encoding='utf-8')
