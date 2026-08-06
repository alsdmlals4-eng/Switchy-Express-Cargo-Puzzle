# SX-DEC-038 — Demo Route Refinement Approval Ledger

- Date: `2026-08-06`
- Evidence: `EV-USER-024`
- Status: `USER_DIRECTED · IMPLEMENTED · AUTOMATED_PASS · LOCAL_RETEST_REQUIRED`
- Supersedes: `SX-DEC-037`의 `VS_DEMO_01@1` 맵 배치·엄격 폐쇄 노선 조건
- Preserves: finite core rules, LIFO delivery, F5 Project Play, Android validation authority

## Approved Decision

1. BUILD HUD에 `권장 배치`를 제공하고, 누르면 실제 완주 가능한 대표 노선을 설치한다.
2. 대표 맵을 `15×11`로 확대하고 역·화물을 넓고 균형 있게 분산한다.
3. 모든 필수 화물을 적재·하역해 배송을 완료할 수 있다면 사용하지 않는 노선 끝은 닫히지 않아도 된다.
4. 분기와 교차는 운행 중 클릭으로 진행 경로를 바꿀 수 있어야 한다.
5. 분기는 활성 출구 화살표, 교차는 `직/우/좌` 상태로 현재 경로를 표시한다.
6. 권장 배치는 사전검사에서 붉은 문제 셀 `0`개이며 제한시간 안에 실제 `SUCCESS`를 만들어야 한다.
7. 새 맵이나 권장 노선은 구현 전에 자동 완주 테스트를 먼저 작성하고 RED를 확인한 뒤 구현한다.

## Canonical Implementation

- `data/maps/vs_demo_01.json` → `VS_DEMO_01@2`
- `game/demo/recommended_layout_provider.gd`
- `game/finite/rail/finite_track_crossing.gd`
- `game/finite/rail/finite_track_graph.gd`
- `game/demo/presentation/route_control_overlay.gd`
- `game/demo/presentation/product_hud.tscn`
- `game/demo/product_finite_slice.gd`

## Automated Evidence

```yaml
godot_workflow: 820
workflow_run_id: 31082270619
head_commit: d064e10ff93a25760f5de044698f79ac4a8f4134
godot_cases: 90
godot_assertions: 11389
godot_failures: 0
pilot_materialization: PASS
recommended_route_full_delivery: PASS
recommended_button_warning_free_install: PASS
runtime_switch_crossing_click: PASS
legacy_validation_regression: PASS
```

## Manual Boundary

자동 검증은 규칙·완주·UI 명령 경로를 증명한다. 실제 Windows 화면에서 배치 가독성, 경로 표시 가독성, 마우스 클릭 감각은 사용자가 최신 `main`을 Pull하여 F5로 재검수하기 전까지 `LOCAL_RETEST_REQUIRED`다.
