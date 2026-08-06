# SX-AUD-022 — Mid-Run Exit Audit

- Date: `2026-08-06`
- Decision: `SX-DEC-039`
- Evidence: `EV-USER-025`
- Scope: persistent gameplay menu, BUILD/RUN pause ownership, destructive-action confirmation, shell input lock, gameplay disposal, title return
- Automated state: `PASS`
- Manual local state: `RETEST_REQUIRED`

## User Finding

사용자는 최신 PC Vertical Slice를 실제 실행하는 과정에서 현재 스테이지를 중간에 포기하고 타이틀로 돌아갈 버튼이 없음을 확인했다.

```text
권장안대로 진행해
1) 중간 종료 버튼이 없음
```

앱을 강제로 닫지 않고 현재 플레이만 안전하게 종료할 수 있어야 한다.

## Adopted Flow

```text
BUILD / RUN
→ 상단 메뉴
→ Pause Overlay
→ 현재 플레이 종료
→ Exit Confirmation
   ├─ 계속 플레이 → Pause Overlay
   └─ 종료하고 타이틀로 → gameplay instance 폐기 → TITLE
```

- `현재 플레이 종료`는 애플리케이션 종료가 아니다.
- 타이틀의 기존 `종료`만 애플리케이션을 종료한다.
- 파괴적 동작은 두 번의 명시적 입력이 필요하다.
- 확인 화면의 초기 포커스는 `계속 플레이`다.
- Pause·Exit Confirmation·Result가 열린 동안 제품 입력을 잠근다.

## TDD Evidence

### RED

```yaml
workflow: Godot Tests #825
run_id: 31088281091
head: 64ea693708f685337df3c90516e5aa9ade661722
result: EXPECTED_FAILURE
cases: 91
failed: 2
assertions: 11396
missing_contracts:
  - HUD/TopStatus/MenuButton
  - PauseOverlay ExitButton
  - ExitConfirmOverlay ContinueButton
  - ExitConfirmOverlay ConfirmButton
```

기존 게임·finite·validation 테스트는 유지됐고 새 중간 종료 계약만 실패했다.

### GREEN

```yaml
verified_code_head: 573309b644cf5f94ccb6290e4de26a645b936ea9
project_contract:
  workflow: 901
  run_id: 31089231562
  result: PASS
godot_tests:
  workflow: 832
  run_id: 31089231587
  result: PASS
  cases: 91
  assertions: 11429
  failures: 0
live_editor_pilot: PASS
thin_adapter:
  workflow: 99
  run_id: 31089231561
  result: PASS
windows_demo_export:
  workflow: 57
  run_id: 31089231983
  result: PASS
  python_contracts: PASS
  godot_headless: PASS
  exe_pck_export: PASS
  artifact_hash: PASS
  artifact_upload: PASS
```

## Adversarial Findings

| Finding | Resolution | State |
|---|---|---|
| BUILD에는 finite PAUSE 명령이 존재하지 않음 | Shell만 `PAUSED`로 전환하고 finite phase는 `BUILD` 유지 | PASS |
| RUN 중 메뉴가 열려도 열차가 계속 움직일 위험 | 기존 finite `PAUSE` 명령을 요청하고 phase `PAUSED` 확인 | PASS |
| 확인 화면에서 게임 단축키가 뒤로 전달될 위험 | ProductFiniteSlice에 shell input lock 추가 | PASS |
| 한 번의 Enter로 파괴 동작이 실행될 위험 | 확인 화면 초기 포커스를 `계속 플레이`에 부여하고 flow confirm 직접 종료 금지 | PASS |
| 취소 시 노선·화물·시간 상태가 초기화될 위험 | 동일 gameplay instance를 유지하고 PAUSED로 복귀 | PASS |
| 확정 종료 후 이전 결과나 오디오가 남을 위험 | result clear, gameplay parent 제거·free, 기존 `_exit_tree` 오디오/효과 정리 | PASS |
| 앱 종료와 현재 플레이 포기가 혼동될 위험 | `종료하고 타이틀로`와 타이틀 `종료`를 분리 | PASS |
| Godot가 false 기본값을 생략해 Windows 계약이 거짓 실패 | preset 블록에 `runnable=true`가 없는지를 의미 기반으로 검증하고 실제 export로 확인 | PASS |

## Preserved Boundaries

- finite delivery·LIFO·map·route control 규칙: 변경 없음
- `project.godot` 기본 진입점: 변경 없음
- Android validation feature override·package ID·canonical APK: 변경 없음
- Windows artifact 실제 실행: `NOT_RUN`
- Android device smoke: `NOT_RUN`
- five-person comprehension: `NOT_RUN`
- production cutover: `BLOCKED`

## Open Manual Gate

```text
Fetch/Pull PR #95 branch or merged main
→ F5
→ BUILD에서 메뉴
→ 현재 플레이 종료
→ 계속 플레이로 동일 노선 유지 확인
→ 운행 시작
→ 메뉴로 실제 일시정지 확인
→ 종료하고 타이틀로 복귀 확인
```

자동 PASS를 실제 사용자의 화면·마우스·키보드 검수 PASS로 대체하지 않는다.
