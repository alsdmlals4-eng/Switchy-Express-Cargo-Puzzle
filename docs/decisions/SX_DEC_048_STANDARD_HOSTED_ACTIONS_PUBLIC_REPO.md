# GMB-006 — Standard GitHub-hosted Actions for the Public Repository

```yaml
approval_batch_id: GMB-006
decision_id: SX-DEC-048
audit_id: SX-AUD-029
contract: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.3
baseline_main: a18b9fd52734f1884286bc3d0830e337d0c800c9
approved_at: 2026-08-07 KST
state: APPROVED_VALIDATION_PATH_CONFIRMED
supersedes:
  - SX-DEC-047
superseded_pr:
  - 103
```

## Decision

이 공개 저장소의 자동 검증은 기존 표준 GitHub-hosted runner를 사용한다.

```yaml
repository_visibility: public
allowed_standard_runner_labels:
  - ubuntu-latest
  - ubuntu-24.04
  - ubuntu-22.04
  - windows-latest
  - windows-2022
current_primary_labels:
  - ubuntu-latest
  - ubuntu-24.04
billing_class: FREE_UNLIMITED_FOR_STANDARD_RUNNERS_ON_PUBLIC_REPOSITORY
larger_runner: NOT_AUTHORIZED
self_hosted_runner: FALLBACK_ONLY_REQUIRES_SEPARATE_APPROVAL
```

현재 프로젝트의 `Godot Tests`, `Project Contract`, `Validate Thin Adapter Migration` 핵심 워크플로는 표준 runner label을 사용한다. larger runner를 별도 승인 없이 도입하지 않는다.

## Root-cause correction

PR #103의 hosted workflow가 실행되지 않은 직접 원인은 결제 예산이 아니라 HEAD 커밋 메시지의 `[skip actions]` 지시였다. GitHub는 이 지시가 있는 `push`와 `pull_request` workflow를 건너뛴다.

따라서 다음 운영 규칙을 적용한다.

```yaml
validation_pr_head:
  skip_actions_token: FORBIDDEN
  required_behavior: RUN_EXISTING_PULL_REQUEST_WORKFLOWS
  evidence_authority: GITHUB_CHECK_RUNS_ON_EXACT_HEAD
merge_commit:
  skip_actions_token: FORBIDDEN_UNLESS_A_SEPARATE_NON_VALIDATION_DECISION_APPROVES_IT
```

## Hosted validation evidence

PR #104의 commit `a4534537c9078e1d7006fad1cad60d9ffc9ca8d3`에서 다음 `pull_request` workflow가 표준 hosted runner로 완료됐다.

```yaml
validated_commit: a4534537c9078e1d7006fad1cad60d9ffc9ca8d3
checks:
  Project Contract: PASS
  Godot Tests: PASS
  Validate Thin Adapter Migration: PASS
```

초기 0-run 판정은 실행 생성 전 조회와 SHA 필터 해석 때문에 성급했다. connector 이벤트 차단으로 확정하지 않는다. merge 전에는 항상 현재 PR HEAD와 동일 SHA의 check run을 다시 확인한다.

## Supersession

`SX-DEC-047`의 Windows 3.11/3.12/3.13 + WSL2 Ubuntu 3.12 수동 exact-HEAD 검증팩은 구현 복잡도가 기존 Actions보다 커졌고, 공개 저장소 표준 runner가 무료라는 공식 정책과 맞지 않아 `SUPERSEDED_NOT_MERGED`로 종료한다.

PR #103의 파일은 `main`에 병합하지 않는다. 해당 PR과 Sheet 기록은 실패 은폐가 아니라 폐기된 접근의 이력으로 보존한다.

## Evidence model

```text
exact PR HEAD
→ standard hosted workflow runs created
→ relevant checks complete
→ diff/review/thread readback
→ merge
→ merged-main readback
→ same-ID Sheet sync
```

워크플로가 실제로 생성되지 않거나 차단되면 추정으로 결제 문제라 하지 않고, GitHub가 반환한 정확한 상태·오류를 근거로 원인을 재분류한다.

## Scope ceiling

이 결정은 검증 실행 위치와 과금 경로만 정한다. 다음 상태는 변경하지 않는다.

- GUT 9.7.1 Phase B formal consumers/JUnit/mutation guard: PENDING
- gameplay implementation: BLOCKED
- HiGodot authoring connection: UNVERIFIED
- Windows runtime smoke: NOT_RUN
- Android device validation: NOT_RUN
- human comprehension validation: NOT_RUN

## Official authority

- GitHub-hosted runners reference: standard runners are free and unlimited for public repositories.
- GitHub Actions billing: standard hosted runners are free for public repositories; larger runners are always billed.
- Skipping workflow runs: `[skip actions]` suppresses `push` and `pull_request` workflow runs.
