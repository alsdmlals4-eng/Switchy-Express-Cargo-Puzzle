# SX-AUD-029 — Public Repository Standard Hosted Actions Audit

```yaml
audit_id: SX-AUD-029
date: 2026-08-07 KST
approval_batch_id: GMB-006
decision_id: SX-DEC-048
baseline_main: a18b9fd52734f1884286bc3d0830e337d0c800c9
superseded_decision: SX-DEC-047
superseded_pr: 103
status: STANDARD_HOSTED_PATH_CONFIRMED
```

## Question

GitHub Actions 결제비용 없이 v4.3 검증 계약을 유지할 수 있는가?

## Readback

```yaml
base_repository:
  main: 4f98f968a377f7b6a11aafa4fc94d11bddbebedc
project_repository:
  visibility: public
  default_branch: main
  main: a18b9fd52734f1884286bc3d0830e337d0c800c9
  open_pr_at_entry:
    - 103
sheet_entry_state:
  current_decision: SX-DEC-047
  current_audit: SX-AUD-028
  current_path: WINDOWS_WSL2_LOCAL_EXACT_HEAD_PACK
```

## Evidence

프로젝트의 핵심 workflow는 다음 표준 GitHub-hosted runner label을 사용한다.

```yaml
.github/workflows/godot-tests.yml: ubuntu-latest
.github/workflows/project-contract.yml: ubuntu-latest
.github/workflows/validate-thin-adapter-migration.yml: ubuntu-24.04
```

GitHub 공식 문서는 공개 저장소의 표준 GitHub-hosted runner 사용을 무료·무제한으로 규정한다. larger runner는 공개 저장소에서도 과금되지만, 현재 핵심 workflow에는 larger runner label이 없다.

PR #103의 exact HEAD에는 `[skip actions]`가 포함되어 workflow run 0건이 의도적으로 발생했다. 이 상태는 비용 차단 증거가 아니며 `NOT_RUN`이다.

PR #104의 commit `a4534537c9078e1d7006fad1cad60d9ffc9ca8d3`에서는 다음 pull-request workflow가 모두 성공했다.

```yaml
Project Contract:
  run_id: 31130288582
  conclusion: success
Validate Thin Adapter Migration:
  run_id: 31130288581
  conclusion: success
Godot Tests:
  run_id: 31130288577
  conclusion: success
```

## Findings

```yaml
FINDING_1:
  severity: P1
  result: INITIAL_BILLING_ASSUMPTION_INCORRECT
  detail: public repository standard hosted runners do not require paid minutes
FINDING_2:
  severity: P1
  result: WORKFLOW_SUPPRESSED_BY_COMMIT_DIRECTIVE
  detail: '[skip actions] suppressed pull_request and push workflows on PR #103'
FINDING_3:
  severity: P2
  result: LOCAL_PACK_OVERENGINEERED
  detail: Windows and WSL matrix duplicated existing hosted validation and introduced local path/tool discovery burden
FINDING_4:
  severity: P2
  result: INITIAL_ZERO_RUN_DIAGNOSIS_PREMATURE
  detail: connector-created synchronize workflows appeared after the first zero-run readback; no connector block is established
FINDING_5:
  severity: P3
  result: NO_PRODUCTION_IMPACT
  detail: PR #103 changed validation tooling/docs/tests only and was not merged
```

## Correction

1. PR #103을 `SUPERSEDED_NOT_MERGED`로 닫는다.
2. `SX-DEC-047`을 폐기 이력으로 보존한다.
3. `SX-DEC-048`을 현재 운영 결정으로 승인한다.
4. validation PR에는 workflow skip 지시를 넣지 않는다.
5. 현재 PR HEAD와 동일 SHA의 hosted checks를 확인한 뒤 병합한다.
6. GitHub main과 Sheet를 같은 ID로 readback한다.
7. GUT 9.7.1 Phase B는 병합된 `SX-DEC-048` 기준 main에서 별도 TDD PR로 진행한다.

## Pass criteria

```yaml
pr_103: CLOSED_SUPERSEDED_NOT_MERGED
sx_dec_047: SUPERSEDED
new_pr_scope: DECISION_AND_AUDIT_DOCS_ONLY
skip_actions_on_validation_head: ABSENT
hosted_runs_created: PASS
standard_runner_labels_only: PASS
production_workflow_scene_project_changes: NONE
current_head_exact_checks: REQUIRED_BEFORE_MERGE
sheet_same_id_sync: REQUIRED
```

## Evidence ceiling

이 감사는 hosted Actions 운영 경로를 정정한다. GUT Phase B, gameplay, HiGodot authoring, Windows runtime, Android device, human gate의 PASS를 주장하지 않는다.
