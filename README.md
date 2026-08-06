# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 선로를 건설해 화물을 만나는 순서를 설계하고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 모든 배송을 끝내는 가로형 물류 퍼즐입니다.

## 핵심 재미

> 선로가 적재 순서를 만들고, LIFO가 역 방문 순서를 만들며, TOP의 연속 동일 화물 하역이 다음 설계를 낳는다.

## 현재 제품 기준선

- 건설 불가 구역을 제외한 자유 선로 건설
- 선로별 건설비와 철거 전액 환급
- 구조적 도달 가능성 검사 뒤 운행 시작
- 수동 적재 기본·자동 적재 토글
- 무제한 CargoStack
- persistent branch 직접 전환과 점유 잠금
- TOP 연속 동일 화물 자동 하역
- 제한 시간 미배송 실패, 마지막 하역 즉시 성공
- 동일 노선 fresh-runtime 재시도
- 색상+형상+텍스트 중복 표현
- 성능 없는 꾸미기 보상

## 바로 실행하기

승인 권위: `SX-DEC-037 · EV-USER-023`  
구현 감사: `SX-AUD-020`

1. GitHub Desktop에서 저장소와 `agent/pc-vertical-slice-demo-design` 브랜치를 선택한다.
2. `Fetch origin → Pull origin`으로 최신 커밋을 받는다.
3. Godot `4.7.1-stable`에서 저장소 루트의 `project.godot`을 연다.
4. 별도 Scene을 선택하거나 설정을 바꾸지 않고 **Project Play(F5 / ▶)** 를 누른다.

기본 `res://game/main/main.tscn`이 `VerticalSliceDemo`를 직접 부트하므로, 실행 즉시 타이틀이 나타나고 다음 전체 흐름을 진행할 수 있어야 한다.

```text
Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title
```

별도 `res://game/demo/vertical_slice_demo.tscn`은 개발·테스트용으로 유지하지만 사용자 검수에 필요하지 않다.

### 조작

```text
좌클릭: 설치·선택·분기 전환
우클릭: 선택 취소·선로 철거
1~4: 직선·곡선·분기·교차 도구
R: 회전
Space: 운행 시작·일시정지·재개
Shift: 누르는 동안 수동 적재
A: 자동 적재 전환
Enter: 타이틀·브리핑 확인
Esc: 취소·뒤로
```

## 자동 검증

최신 기본 실행 변경 커밋: `8807cdbdd670a0cb67948e97f922c9bd9700e1a7`

```text
Project Contract #822: PASS
Godot Tests #757: PASS
Godot: 85 cases · 11,284 assertions · 0 failures
Thin Adapter Migration #82: PASS
Platform release and asset rights #47: PASS
Windows Demo Export #40: PASS
```

자동 테스트는 기본 Project Play가 타이틀, 브리핑, gameplay, HUD, BUILD 도구를 생성하고 기존 성공·실패·재시도·수정 경로와 Android validation 경계를 유지하는지 검사한다.

## Windows artifact

`Windows Demo` debug export에는 다음 두 파일이 같은 폴더에 있어야 한다.

```text
SwitchyExpressVerticalSlice.exe
SwitchyExpressVerticalSlice.pck
```

export·구성·해시 무결성 PASS는 실제 Windows 화면·음향·물리 입력 PASS를 대신하지 않는다.

## 현재 상태

```text
FINITE AUTOMATED CORE: PASS
PC VERTICAL SLICE AUTOMATED CORE: PASS
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
PC WINDOWS DEBUG EXPORT: PASS
PC WINDOWS ARTIFACT INTEGRITY: PASS
PC LOCAL PROJECT PLAY RETEST: FAIL · RETEST_REQUIRED
PC WINDOWS ARTIFACT RUNTIME SMOKE: NOT_RUN
VALIDATION PREPARATION: PASS
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID
PRODUCTION CUTOVER: BLOCKED
PR #83: DRAFT
```

사용자가 이전 커밋에서 HUD와 입력 화면 누락을 확인했기 때문에 로컬 실행 Gate는 `FAIL · RETEST_REQUIRED`다. 최신 커밋을 Fetch/Pull한 뒤 F5로 다시 확인하기 전에는 PASS로 올리지 않는다.

Canonical Android validation APK:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

Android validation feature override와 package ID는 기본 PC Project Play 변경과 분리되어 보존된다.

## 정본 읽기 순서

1. `기획서/00_프로젝트_허브/START_HERE.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
4. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
5. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
6. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
7. `기획서/50_제작_검증/SX_AUD_020_PC_VERTICAL_SLICE_IMPLEMENTATION_AUDIT.md`

## 기술

- Godot 4.7.1-stable
- GDScript
- PC / Android landscape
- GitHub 정본 + Google Sheets 동기화

## 다음 Gate

```text
사용자: 최신 branch Fetch origin → Pull origin → Godot 재실행 → F5
→ Title/Briefing/BUILD/HUD/도구/입력 확인
→ 대표 성공·실패·Retry/Edit 완주
→ PASS 또는 결함 기록

별도 Android track: canonical APK physical-device smoke
```
