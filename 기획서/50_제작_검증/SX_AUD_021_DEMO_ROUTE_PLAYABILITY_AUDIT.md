# SX-AUD-021 — Demo Route Playability Audit

- Date: `2026-08-06`
- Decision: `SX-DEC-038`
- Evidence: `EV-USER-024`
- Scope: recommended route, balanced map, open terminals, runtime route controls, warning correctness
- Automated state: `PASS`
- Manual local state: `RETEST_REQUIRED`

## Adversarial Findings Resolved

| Finding | Resolution | Evidence |
|---|---|---|
| 역·화물 주변에 배치가 집중되어 맵 활용도가 낮음 | 보드를 15×11로 확대하고 마커를 넓게 분산 | `test_demo_recommended_route.gd` |
| 권장 배치 부재 | BUILD HUD `권장 배치` 버튼과 canonical provider 추가 | `test_recommended_layout_ui.gd` |
| 완주 가능 여부를 구현 후에만 확인 | RED-first 실제 자동 완주 통합 테스트 추가 | `test_demo_recommended_route.gd` |
| 사용하지 않는 선로 끝까지 닫아야 해 불필요한 경고 발생 | 제품 맵에서 필수 지점 도달 후 열린 종착 허용 | preflight + recommended route PASS |
| 교차 선로가 항상 직진하고 상태가 보이지 않음 | `직→우→좌` 순환 상태와 보드 오버레이 추가 | `test_interactive_route_controls.gd` |
| 운행 중 분기·교차 클릭 경로가 화면과 도메인에 함께 반영되지 않음 | 공용 route control command와 snapshot/overlay 동기화 | `test_route_control_runtime_ui.gd` |
| Godot AI `.uid`가 Pilot 검증을 거짓 실패시킴 | `.uid` companion 무시, 임의 파일은 계속 차단 | Pilot Workflow #820 PASS |

## Proof Route

권장 노선은 다음 화물 순서와 LIFO 하역을 실제로 수행한다.

```text
A 화물 → B 화물 → A 화물 → A 화물
→ A역에서 TOP A·A 하역
→ B역에서 TOP B 하역
→ 외곽 순환 후 A역 재방문
→ 마지막 A 하역
→ SUCCESS
```

교차의 사용하지 않는 위·아래 분기는 열린 상태여도 권장 노선의 필수 배송과 무관하므로 붉은 경고를 만들지 않는다. 운행 중 클릭하면 실제 다음 칸이 `직진 → 우회전 → 좌회전`으로 변경된다.

## Verification Evidence

```yaml
workflow_name: Godot Tests
workflow_number: 820
workflow_run_id: 31082270619
commit: d064e10ff93a25760f5de044698f79ac4a8f4134
result: PASS
godot_cases: 90
godot_assertions: 11389
godot_failures: 0
live_editor_pilot: PASS
p0: 0
p1_automated: 0
```

## Open Manual Gate

```text
LOCAL PROJECT PLAY VISUAL·INPUT RETEST: REQUIRED
WINDOWS ARTIFACT RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```

자동 PASS를 실제 사용자 플레이 PASS로 대체하지 않는다.
