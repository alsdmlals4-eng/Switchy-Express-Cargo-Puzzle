# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 직접 선로를 건설해 화물을 만나는 순서를 만들고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 모든 배송을 끝내는 모바일 가로형 물류 퍼즐입니다.

## 핵심 재미

> 선로가 적재 순서를 만들고, LIFO가 역 방문 순서를 만들며, 같은 화물을 연속 하역한 Combo가 더 빠른 다음 배송으로 이어진다.

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

## 프로젝트 상태

```text
GMB-002 · SX-DEC-027~036: CURRENT PRODUCT AUTHORITY
FINITE AUTOMATED CORE: PASS
VALIDATION PREPARATION: PASS
ON-DEVICE SELECTOR: PASS
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

Canonical validation APK:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

이 APK는 debug validation 전용이며 출시용 APK가 아닙니다. 현재 작업은 동일 APK hash를 유지한 물리 Android landscape 기기 Smoke입니다.

기존 무한 생존·fuel·player acceleration input·capacity-eight·pickup respawn 기준선은 `[대체됨/폐기 · 역사 증거]`이며 현재 제품 권위가 아닙니다.

## 정본 읽기 순서

1. `기획서/00_프로젝트_허브/START_HERE.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
4. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
5. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
6. `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
7. `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
8. `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`
9. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

## 기술

- Godot 4.7.1-stable
- GDScript
- Android / landscape
- GitHub 정본 + Google Sheets GDD 동기화

## 다음 작업

```text
canonical APK 전체 SHA-256 확인
→ 물리 Android 기기에서 AND-01~20 실행
→ 증거 completeness·privacy·적대적 검토
→ Android Gate 판정
```

Android reviewed PASS 전에는 Five-person Comprehension과 production cutover를 진행하지 않습니다.
