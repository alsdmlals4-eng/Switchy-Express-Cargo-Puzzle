# SX-DEC-037 · PC 대응 단일 대표 스테이지 Vertical Slice 승인 원장

상태: `CONFIRMED_CANONICAL · IMPLEMENTATION_NOT_STARTED · PR_83_MAIN_PENDING`

## 승인 증거

```yaml
decision_id: SX-DEC-037
evidence_id: EV-USER-023
approval_date: 2026-08-06
approval_wording: 정본승인
approved_spec: docs/superpowers/specs/2026-08-06-pc-vertical-slice-demo-design.md
implementation_plan: docs/superpowers/plans/2026-08-06-pc-vertical-slice-demo.md
pull_request: 83
branch: agent/pc-vertical-slice-demo-design
```

## 승인된 결정

Switchy Express: Cargo Puzzle의 다음 제품형 실행 패키지는 기존 finite delivery 도메인과 검증 command 경계를 재사용하는 **PC 대응 고완성도 단일 대표 스테이지 Vertical Slice Demo**로 제작한다.

- 단일 대표 스테이지에 집중한다.
- 첫 플레이 목표 길이는 약 5~10분이다.
- 타이틀 → 브리핑 → BUILD → RUN → 결과 → 같은 노선 재시도/노선 수정/타이틀 복귀의 완결 흐름을 제공한다.
- 마우스 중심 조작과 키보드 단축키를 제공한다.
- 기존 터치 command 경계는 유지한다.
- 산업 물류 보드게임형 UI와 따뜻한 철도 디오라마 분위기를 적용한다.
- 기존 `fp_core_proof_01.json`은 검증 증거용으로 보존하고 데모 전용 맵을 별도 작성한다.
- 현재 `game/finite/main/finite_slice.gd`의 application orchestration은 공용 `FiniteSliceSessionController`로 추출한다.
- validation 화면과 제품형 Demo는 같은 controller를 소비하며 게임 상태를 중복 소유하지 않는다.
- Godot 에디터에서는 전용 `vertical_slice_demo.tscn`을 F6으로 실행한다.
- 구현·검수 완료 전에는 `project.godot`의 기본 진입점을 변경하지 않는다.

## 보호 경계

이번 결정은 다음 상태를 변경하지 않는다.

```text
FINITE AUTOMATED CORE: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
CANONICAL ANDROID APK: UNCHANGED
```

다음 행위를 금지한다.

- PC Demo 완성을 Android Device Smoke PASS로 보고
- Windows export 성공을 production release readiness로 보고
- 기본 F5 진입점을 승인 없이 전환
- canonical Android validation APK를 이번 패키지에서 재생성
- proof 맵을 제품형 데모 맵으로 덮어쓰기
- 제품형 View에 선로·적재·분기·시간·배송·결과 판정 권위 부여
- 별·랭킹·온라인·과금·게임패드·다중 스테이지를 이번 범위에 추가

## 아키텍처 결정

```text
FiniteSliceSessionController
├─ ValidationFiniteSlice compatibility wrapper
└─ ProductFiniteSlice

VerticalSliceDemo
├─ DemoFlowController
├─ TitleScreen
├─ BriefingScreen
├─ ProductFiniteSlice
├─ PauseOverlay
├─ ResultOverlay
└─ DemoAudioDirector
```

`FiniteSliceSessionController`가 map load, build session, preflight, run session, command dispatch, retry, edit, presenter model과 read-only render snapshot의 유일한 application-state owner다.

## 완료 기준

1. `res://game/demo/vertical_slice_demo.tscn` F6 실행 성공
2. Title → Briefing → BUILD → RUN → Result 완결
3. 성공과 실패 모두 재현 가능
4. same-layout retry와 edit-layout이 서로 다른 의미로 동작
5. 승인된 마우스·키보드 조작 동작
6. 기존 터치 command 회귀 없음
7. 제품형 board·HUD에서 선로, 역, 화물, 열차, TOP, 분기 상태 판독 가능
8. 1280×720, 1600×900, 1920×1080 clipping 없음
9. Windows debug export 생성·실행 확인
10. 전체 자동 테스트 PASS
11. validation wrapper가 공용 controller 위에서 기존 proof 결과 유지
12. default entrypoint와 Android validation harness 불변
13. 외부 자산 권리 상태 기록
14. P0·P1 open finding 0

## 동기화 상태

```yaml
github_spec: RECORDED_IN_PR_83
github_approval_ledger: RECORDED_IN_PR_83
github_plan: PENDING_SAME_PR
current_decisions: PENDING_SAME_PR
google_sheet: PENDING_SAME_DECISION_ID
main_merge: NOT_DONE
implementation: NOT_STARTED
```

PR #83이 main에 병합되기 전까지 모든 GitHub·Sheet 표기는 `MAIN_PENDING`을 유지한다.
