#!/usr/bin/env python3
from __future__ import annotations
import hashlib, json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
V='9.4.0'; P='a728712cb776ec98f4875914a580fcf7d0156593'; E='ef1fba11167e4da0b298123b0c85ebd268191a42'; F='87a0b54c2847ce4b685879209205957c170cc1cd'; R='693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59'; B='4e435a1a6d10ab146197671049da80709fd18c1f'; NEW='optimizing-ai-model-and-prompt-costs'
def load(p): return json.loads((ROOT/p).read_text(encoding='utf-8'))
def save(p,d): (ROOT/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

def registry_and_adapter():
 rp='skills/SKILL_REGISTRY.json'; reg=load(rp)
 if NEW not in {x['id'] for x in reg['skills']}:
  reg['skills'].append({'id':NEW,'owner':'base','base_path':'skills/optimizing-ai-model-and-prompt-costs/SKILL.md','status':'ACTIVE'})
 save(rp,reg); rh=hashlib.sha256((ROOT/rp).read_bytes()).hexdigest()
 ap='skills/PROJECT_BASE_ADAPTER.json'; a=load(ap); a['base_release']={'release_commit':P,'release_evidence_commit':E,'finalization_commit':F,'repository':'alsdmlals4-eng/Base','version':V}; a['protected_baseline']['commit']=B; a['skill_registry']['base']['sha256']=R; a['skill_registry']['project']['sha256']=rh
 if NEW not in a['routing']['base_routes']: a['routing']['base_routes'].append(NEW)
 a['routing']['base_routes'].sort(); a['shared_overrides'][NEW]={'modes':['route-model-and-effort','design-cacheable-prefix','estimate-cost','measure-actual-usage','recalibrate'],'provider_measurement_status':'NOT_RUN'}
 a['validators']=[{'command':'python tools/validate_project_contract.py','status':'PASSED_AT_BASELINE','evidence_commit':B},{'command':'godot --headless --path . --script res://tests/run_tests.gd','status':'PASSED_AT_BASELINE','evidence_commit':B,'summary':'9 cases / 6915 assertions / 0 failures'}]
 save(ap,a)

def docs():
 ag=ROOT/'AGENTS.md'; t=ag.read_text(encoding='utf-8').replace('Base` v9.3','Base` v9.4').replace('Base v9.3 기준','Base v9.4 기준')
 if '## Base v9.4 운영 계약' not in t: t=t.rstrip()+f'''\n\n## Base v9.4 운영 계약\n\n```yaml\nbase_version: {V}\nbase_payload_commit: {P}\nbase_trusted_evidence_commit: {E}\nbase_pin_finalization_commit: {F}\nbase_registry_sha256: {R}\n```\n\n- `[모델 추천]`은 실제 설정을 자동 변경하지 않으며 사용자가 checkpoint에서 변경한다.\n- 퍼즐 규칙·레벨 의미·LIFO·화물/역 색상+모양·저장 호환성은 `HARD_CONSTRAINT`다.\n- UI 모션은 퍼즐 결과·점수·연료·적재·하역·저장의 권위가 아니다.\n'''
 ag.write_text(t,encoding='utf-8')
 (ROOT/'docs/BASE_RULES_VERSION.md').write_text(f'''# Project Base Rules Version

| Field | Value |
|---|---|
| Base repository | `alsdmlals4-eng/Base` |
| Applied line | `v9.4.0` |
| Release state | `BASE_RELEASED` |
| Release commit | `{P}` |
| Release evidence commit | `{E}` |
| Pin finalization commit | `{F}` |
| Base Skill Registry SHA-256 | `{R}` |
| Project adoption date | `2026-08-01` |
| Project repository | `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle` |

`skills/SKILL_REGISTRY.json`과 `skills/PROJECT_BASE_ADAPTER.json`이 프로젝트의 선택적 공용 route를 소유한다. Base v9.4는 모델·추론·Prompt caching·비용 측정, 지시 권위, Interface-first Prompt, Context 큐레이션, Artifact 주장 상한, Godot UI 모션 계약을 제공한다.

## 보호 경계

- 자동 열차·15×10 연결 철도·분기·직진 우선·LOAD·LIFO·콤보·배송·연료·속도·BOOST·게임오버 규칙을 변경하지 않는다.
- 레벨/seed·화물/역 색상+모양·Route history·저장 호환성과 기존 Decision ID를 보존한다.
- `project.godot`, `game/**`, `assets/**`, `기획서/**`의 제품 의미를 이 적용에서 변경하지 않는다. UI 책임 문서에는 공용 검증 계약만 추가한다.
- Google Sheet는 기존 `SYNCED` 상태를 유지하며 이 적용에서 쓰지 않는다.
- Android 실기기·사람 이해·provider 비용은 `NOT_RUN` 또는 `HUMAN_NOT_RUN`이다.
''',encoding='utf-8')
 (ROOT/'docs/AI_WORKFLOW.md').write_text(f'''# Switchy Express AI·GitHub 작업 흐름

- `[모델 추천]`은 난도·실패 비용·재작업 위험으로 모델과 추론 단계를 제안한다. 실제 설정 변경은 사용자가 수행하고 다음 checkpoint부터 적용한다.
- 퍼즐 규칙·레벨 의미·LIFO·저장 호환성·데이터 무결성·불가역 변경은 `HARD_CONSTRAINT`다.
- 일반 기술 구조는 `RECOMMENDED_DEFAULT`, 비파괴 표현 초안은 `JUDGMENT_SPACE`다.
- Prompt는 `problem / player_or_user_value / inputs / authority_and_source / output_contract / invariants / failure_conditions / validation`의 Interface-first 계약을 사용한다.
- `Example-as-Fixture`: 예시는 정상·실패·경계·회귀 Fixture 또는 Golden Set이며 정본 권위가 아니다.
- Context는 `decision_question / include_criteria / exclude_criteria / authority_level / freshness / known_conflicts / progressive_load_trigger / refresh_trigger`를 기록한다.
- 반대 근거·막다른길·영구 생존 전략·후보 부족·경로 엔트로피·LIFO 회귀 사례를 큐레이션에서 제거하지 않는다.
- 화면·Schema·Fixture는 실제 Android 런타임·사람 이해·성능을 자동 증명하지 않는다. 미실행 자동 검증은 `NOT_RUN`, 사람 검증은 `HUMAN_NOT_RUN`이다.

Base identity: `{P}` / `{E}` / `{R}`.
''',encoding='utf-8')
 vp=ROOT/'기획서/40_표현/VISUAL_DIRECTION.md'; u=vp.read_text(encoding='utf-8')
 if '## UI 모션·중단·반복 계약' not in u: u=u.rstrip()+'''\n\n## UI 모션·중단·반복 계약\n\n```text\n입력 접수 → 처리 중 → 도메인 결과 확정 → 결과 표현\n```\n\n- 분기 전환·LOAD·화물 적재·LIFO 하역·콤보·BOOST·결과·재시작 모션은 중단과 즉시 완료 경로를 가진다.\n- 빠른 반복·재진입·재시작에서 분기 상태·화물 stack·점수·연료·배송·spawn이 중복되지 않아야 한다.\n- `AnimationPlayer`·`Tween` 완료 signal은 선로 선택·적재·하역·점수·연료·게임오버·저장의 권위 시점이 아니다.\n- `Reduced Motion`, `mute`, `haptic-off`에서도 활성 경로·다음 하역·연료·위험·결과 원인·다음 행동을 보존한다.\n- Android safe area·48dp·성능·사람 이해는 `NOT_RUN` / `HUMAN_NOT_RUN`으로 유지한다.\n'''
 vp.write_text(u,encoding='utf-8')
 ac=ROOT/'기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md'; t=ac.read_text(encoding='utf-8')
 if '## Base v9.4 운영 계약' not in t: t=t.rstrip()+f'''\n\n## Base v9.4 운영 계약\n\n- Base `{V}` payload/evidence와 model/prompt/cost route를 프로젝트 Registry·Adapter에 적용했다.\n- VS-01/VS-02 제품 코드·퍼즐 규칙·레벨·화물·선로·저장·Sheet는 변경하지 않는다.\n- Godot headless 회귀는 PR에서 재실행하며 Android 실기기·사람·provider 검증은 `NOT_RUN` 또는 `HUMAN_NOT_RUN`이다.\n'''
 ac.write_text(t,encoding='utf-8')
 dm=ROOT/'기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md'; t=dm.read_text(encoding='utf-8')
 if 'BASE_V9_4_ADOPTION_AUDIT' not in t: t=t.rstrip()+'''\n| AI 모델·지시·Context 작업 흐름은 무엇인가 | `../../../docs/AI_WORKFLOW.md` |\n| Base v9.4 적용·보호 감사는 무엇인가 | `../../50_제작_검증/BASE_V9_4_ADOPTION_AUDIT.md` |\n'''
 dm.write_text(t,encoding='utf-8')
 ap=ROOT/'기획서/50_제작_검증/BASE_V9_4_ADOPTION_AUDIT.md'; ap.write_text(f'''# Base v9.4 적용 감사 — Switchy Express

```yaml
decision_id: DEC-2026-08-01-001
issue: 14
baseline_commit: {B}
base_version: {V}
base_payload: {P}
base_evidence: {E}
base_finalization: {F}
base_registry_sha256: {R}
adoption_scope: OPERATING_CONTRACT_ONLY
product_logic_changed: false
gdd_sheet_written: false
android_validation: NOT_RUN
human_validation: HUMAN_NOT_RUN
```

프로젝트 Skill 1개, 자동 열차·15×10 RailGraph·분기·직진 우선·LOAD·LIFO·콤보·배송·연료·속도·BOOST·게임오버·결정론·spawn 회복 규칙을 보존한다. UI 모션은 분기·적재·하역·점수·연료·게임오버·저장의 권위가 아니다. Context 큐레이션은 영구 생존·후보 부족·경로 엔트로피·LIFO 회귀 근거를 제거하지 않는다.
''',encoding='utf-8')

def validator_tests():
 p=ROOT/'tools/validate_project_contract.py'; t=p.read_text(encoding='utf-8').replace('!= "9.3.0"','!= "9.4.0"'); p.write_text(t,encoding='utf-8')
 (ROOT/'tests/test_base_v94_ai_operations_adoption.py').write_text(f'''from __future__ import annotations
import hashlib,json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
class TestBaseV94Switchy(unittest.TestCase):
 def test_identity_registry_routes_and_core(self):
  a=json.loads((ROOT/'skills/PROJECT_BASE_ADAPTER.json').read_text(encoding='utf-8')); r=json.loads((ROOT/'skills/SKILL_REGISTRY.json').read_text(encoding='utf-8'))
  self.assertEqual('{V}',a['base_release']['version']); self.assertEqual('{P}',a['base_release']['release_commit']); self.assertEqual('{E}',a['base_release']['release_evidence_commit']); self.assertEqual('{R}',a['skill_registry']['base']['sha256']); self.assertEqual(hashlib.sha256((ROOT/'skills/SKILL_REGISTRY.json').read_bytes()).hexdigest(),a['skill_registry']['project']['sha256']); self.assertIn('{NEW}',a['routing']['base_routes']); self.assertIn('{NEW}',{{x['id'] for x in r['skills']}}); self.assertEqual(['switchy-express-design'],a['routing']['project_routes']); self.assertEqual(['project.godot','game/**','assets/**','기획서/**'],a['protected_paths'])
 def test_contracts(self):
  ai=(ROOT/'docs/AI_WORKFLOW.md').read_text(encoding='utf-8'); ui=(ROOT/'기획서/40_표현/VISUAL_DIRECTION.md').read_text(encoding='utf-8'); audit=(ROOT/'기획서/50_제작_검증/BASE_V9_4_ADOPTION_AUDIT.md').read_text(encoding='utf-8')
  for x in ('[모델 추천]','HARD_CONSTRAINT','Interface-first','Example-as-Fixture','refresh_trigger','LIFO','NOT_RUN'): self.assertIn(x,ai)
  for x in ('입력 접수','처리 중','중단','즉시 완료','빠른 반복','재진입','재시작','Reduced Motion','mute','haptic-off','권위 시점'): self.assertIn(x,ui)
  self.assertIn('product_logic_changed: false',audit); self.assertIn('HUMAN_NOT_RUN',audit)
if __name__=='__main__': unittest.main()
''',encoding='utf-8')
registry_and_adapter(); docs(); validator_tests()
