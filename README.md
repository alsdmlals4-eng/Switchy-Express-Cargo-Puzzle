# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 직접 선로를 건설해 화물을 만나는 순서를 만들고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 모든 배송을 끝내는 가로형 물류 퍼즐입니다.

## 핵심 재미

> 선로가 적재 순서를 만들고, LIFO가 역 방문 순서를 만들며, TOP의 연속 동일 화물 하역이 다음 설계를 낳는다.

## 현재 제품 기준선

- 건설 불가 구역을 제외한 자유 선로 건설
- 선로별 건설비와 철거 전액 환급
- 구조적 도달 가능성 검사 뒤 운행 시작
- 수동 적재 기본·자동 적재 토글
- 무제한 CargoStack
- persistent branch 직접 탭과 점유 잠금
- TOP 연속 동일 화물 자동 하역
- 제한 시간 미배송 실패, 마지막 하역 즉시 성공
- 동일 노선 fresh-runtime 재시도
- 색상+형상+텍스트 중복 표현
- 성능 없는 꾸미기 보상

## PC Vertical Slice Demo

승인 권위: `SX-DEC-037 · EV-USER-023`  
구현 감사: `SX-AUD-020`

Godot Editor에서 다음 Scene을 열고 **Run Current Scene(F6)** 을 실행한다.

```text
res://game/demo/vertical_slice_demo.tscn
```

`F5`는 의도적으로 기존 `res://game/main/main.tscn`을 실행한다. 기본 진입점 전환은 Android·HUMAN Gate 이후 별도 production-cutover 승인으로만 수행한다.

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

### Windows artifact

`Windows Demo` debug export에는 다음 두 파일이 함께 필요하다.

```text
SwitchyExpressVerticalSlice.exe
SwitchyExpressVerticalSlice.pck
```

최신 자동 검증 artifact:

```yaml
workflow_run_id: 31065293030
artifact_id: 8953621440
artifact_name: switchy-express-windows-demo-c6c9eb1ffcf755845872638478e6c1e431110b41
artifact_expiry: 2026-08-20T02:20:34Z
artifact_zip_sha256: 7c44092b3837d84d3f027fc1625aaccaa1543d5307a174eda37824b27889af9e
exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
pck_sha256: 66ffec232a851d1858da6a5bc0b90ca3c3e4b3769dc472fe1e97a15c0a82c741
```

이 artifact는 생성·구성·해시 무결성까지 확인됐지만 Windows 실기기 실행·화면·음향·물리 입력 검수는 아직 `NOT_RUN`이다.

## 프로젝트 상태

```text
GMB-002 · SX-DEC-027~037: CURRENT PRODUCT/DEMO AUTHORITY
FINITE AUTOMATED CORE: PASS
PC VERTICAL SLICE AUTOMATED CORE: PASS
PC WINDOWS DEBUG EXPORT: PASS
PC WINDOWS ARTIFACT INTEGRITY: PASS
PC WINDOWS RUNTIME SMOKE: NOT_RUN
VALIDATION PREPARATION: PASS
ON-DEVICE SELECTOR: PASS
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

Canonical Android validation APK:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

이 APK는 debug validation 전용이며 출시용 APK가 아니다. PC Demo export는 이 Android 증거를 대체하지 않는다.

기존 무한 생존·fuel·player acceleration input·capacity-eight·pickup respawn 기준선은 `[대체됨/폐기 · 역사 증거]`이며 현재 제품 권위가 아니다.

## 정본 읽기 순서

1. `기획서/00_프로젝트_허브/START_HERE.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
4. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
5. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
6. `docs/superpowers/specs/2026-08-06-pc-vertical-slice-demo-design.md`
7. `기획서/50_제작_검증/SX_AUD_020_PC_VERTICAL_SLICE_IMPLEMENTATION_AUDIT.md`
8. `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
9. `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
10. `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`
11. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

## 기술

- Godot 4.7.1-stable
- GDScript
- PC / Android landscape
- GitHub 정본 + Google Sheets GDD 동기화

## 다음 작업

```text
PC: Windows artifact 실제 실행·시각·음향·마우스·키보드 smoke
Android: canonical APK 전체 SHA-256 확인 → 물리 Android AND-01~20
→ 증거 completeness·privacy·적대적 검토
→ 각 플랫폼 Gate 판정
```

Android reviewed PASS 전에는 Five-person Comprehension과 production cutover를 진행하지 않는다.
