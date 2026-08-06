# SX-DEC-037 · PC 대응 단일 대표 스테이지 Vertical Slice 승인 원장

상태: `CONFIRMED_CANONICAL · IMPLEMENTED_ON_PR_83 · LOCAL_RETEST_REQUIRED · MAIN_PENDING`

## 승인·수정 증거

```yaml
decision_id: SX-DEC-037
evidence_id: EV-USER-023
initial_approval_date: 2026-08-06
initial_approval_wording: 정본승인
approved_spec: docs/superpowers/specs/2026-08-06-pc-vertical-slice-demo-design.md
approved_plan: docs/superpowers/plans/2026-08-06-pc-vertical-slice-demo.md
one_click_amendment: docs/superpowers/specs/2026-08-06-pc-vertical-slice-one-click-entrypoint-amendment.md
amendment_evidence: 사용자는 Scene 선택·추가 설정 없이 Project Play만 눌러 실제 데모 전체를 진행해야 함
pull_request: 83
branch: agent/pc-vertical-slice-demo-design
latest_verified_commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
```

## 현재 승인 결정

Switchy Express: Cargo Puzzle의 대표 제품형 실행 패키지는 기존 finite delivery 도메인과 validation command 경계를 재사용하는 PC 대응 고완성도 단일 대표 스테이지 Vertical Slice Demo다.

- 첫 플레이 목표 5~10분
- Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title
- 마우스 중심·키보드 단축키·touch path 보존
- 산업 물류 보드게임형 UI와 따뜻한 철도 디오라마 방향
- proof map과 분리된 `VS_DEMO_01@1`
- 공용 `FiniteSliceSessionController`
- validation wrapper와 ProductFiniteSlice가 같은 controller 소비
- 외부 자산 없이 repository-owned presentation/audio

## One-click Project Play 수정 결정

초기 설계의 다음 두 조건은 후속 사용자 요구로 대체됐다.

```text
대체 전:
- 전용 vertical_slice_demo.tscn을 F6으로 실행
- 구현 패키지에서 기본 진입점 변경 금지

현재 정본:
- project.godot을 열고 Project Play(F5 / ▶)만 실행
- 기본 game/main/main.tscn이 VerticalSliceDemo를 직접 부트
- 별도 Scene 선택·Project Settings·입력 모드·플러그인 설정 불필요
- 실제 성공·실패·Retry/Edit/Title까지 진행 가능해야 함
```

이 변경은 store production cutover가 아니다. 일반 PC 검수 진입점을 playable Vertical Slice로 전환한 것이며 Android validation feature override는 별도 경로로 유지한다.

## 보호 경계

```text
FINITE AUTOMATED CORE: PASS
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
PC LOCAL PROJECT PLAY: FAIL · RETEST_REQUIRED
WINDOWS EXPORT·INTEGRITY: PASS
WINDOWS ARTIFACT RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
CANONICAL ANDROID APK: UNCHANGED
PR #83: DRAFT
```

금지:

- F6·별도 Scene 선택을 사용자 필수 절차로 안내
- Fetch만으로 최신 파일이 적용됐다고 판단
- 자동·export PASS를 실제 local runtime PASS로 확대
- PC Demo 결과를 Android Device Smoke 또는 HUMAN PASS로 확대
- Android validation launcher·package ID·canonical APK evidence 변경
- proof map 덮어쓰기
- 제품 View에 finite 판정 권위 부여
- 사용자 재검수 전 PR Ready·merge

## 완료 기준

1. 기본 `res://game/main/main.tscn`이 `VerticalSliceDemo` 부트
2. Project Play(F5 / ▶)로 TITLE 시작
3. TITLE → BRIEFING → GAMEPLAY 전환
4. HUD·BUILD toolbar·board·TOP surface 표시
5. 성공·실패 모두 재현
6. same-layout retry와 edit-layout 구분
7. mouse·keyboard·touch command 회귀 없음
8. 3개 기준 해상도 clipping 없음
9. Windows export·integrity PASS
10. 전체 자동 테스트 PASS
11. validation wrapper proof 결과 유지
12. Android validation feature override·package evidence 보존
13. 외부 자산 권리 기록
14. 사용자 최신 커밋 local F5 retest PASS

자동 1~13은 충족했다. 14는 아직 `RETEST_REQUIRED`다.

## 최신 자동 증거

```yaml
project_contract: 822 · PASS
godot_tests: 757 · PASS
godot_cases: 85
godot_assertions: 11284
godot_failures: 0
thin_adapter: 82 · PASS
asset_rights: 47 · PASS
windows_export: 40 · PASS
```

## 동기화 상태

```yaml
github_spec_and_amendment: RECORDED_IN_PR_83
github_approval_ledger: UPDATED
github_current_decisions: UPDATED
github_contract_and_gates: UPDATED
google_sheet: UPDATE_REQUIRED_SAME_DECISION_ID
main_merge: NOT_DONE
manual_local_retest: REQUIRED
```
