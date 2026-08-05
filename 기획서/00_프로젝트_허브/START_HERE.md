# Switchy Express 프로젝트 허브

## 현재 제품 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | Switchy Express: Cargo Puzzle |
| 장르 | 유한 스테이지 선로 건설·LIFO 화물 배송 퍼즐 |
| 플랫폼 | Android · landscape |
| 엔진 | Godot 4.7.1 · GDScript |
| 현재 결정 | GMB-002 · SX-DEC-027~036 |
| 현재 감사 | SX-AUD-019 · EV-FP-APK-001 |
| FINITE AUTOMATED CORE | PASS |
| VALIDATION PREPARATION | PASS |
| ON-DEVICE SELECTOR | PASS |
| CANONICAL MAIN APK EXPORT | PASS |
| 현재 Gate | ANDROID DEVICE SMOKE · NOT_RUN |
| 다음 Gate | FIVE-PERSON COMPREHENSION · BLOCKED_BY_ANDROID |
| 기본 진입점 | LEGACY |
| PRODUCTION CUTOVER | BLOCKED |
| Sheet | correct `1EpQ...` GDD · SX-AUD-019 synced |

## 한 문장

> 선로를 건설해 화물을 원하는 순서로 만나고, 마지막에 실은 화물부터 내리는 LIFO를 역산해 제한 시간 안에 모든 배송을 끝내는 비용·속도·점수 최적화 퍼즐.

## 반드시 먼저 읽기

1. `FINITE_DELIVERY_PUZZLE_BASELINE.md`
2. `CURRENT_CONFIRMED_DECISIONS.md`
3. `../50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
4. `../50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
5. `../50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`
6. `../50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
7. `ACTIVE_CONTEXT.md`
8. `DEVELOPMENT_GATES.md`
9. `ROADMAP.md`

## 현재 핵심 플레이

```text
선로 건설
→ 화물 조우 순서 설계
→ 수동/자동 적재로 unlimited LIFO 구성
→ persistent branch와 역 방문 순서 실행
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 전체 배송 완료
→ 시간·건설비·점수별 재설계
```

## 현재 검증 APK

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
artifact_expiry: 2026-08-19T13:45:27Z
```

이 APK는 debug validation 전용이며 출시용 APK가 아니다. Android·HUMAN 결과는 동일한 전체 APK hash에만 귀속한다.

## 현재 작업

```text
canonical APK hash 확인
→ 물리 Android landscape 기기에서 AND-01~20 실행
→ 증거 Template 작성
→ 적대적 검토
→ GitHub 정본·correct Sheet same-ID closure
```

Android Device Smoke가 reviewed PASS가 되기 전에는 Five-person Comprehension과 production cutover를 시작하지 않는다.

## 현재 중요한 경계

- LIFO, 색상+형상+텍스트 중복 표현, same-layout retry와 immutable identity를 유지한다.
- endless survival, fuel/fuel-zero, player BOOST, capacity 8, cargo slowdown, pickup respawn과 switch auto-reset은 `LEGACY_IMPLEMENTATION · HISTORICAL_EVIDENCE`다.
- 과거 VS03 계획과 구현은 역사 증거이며 현재 실행 권위가 아니다.
- 기본 진입점은 legacy 상태를 유지한다.
- Android PASS를 HUMAN 또는 production cutover PASS로 확대하지 않는다.
- Correct Sheet는 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`다.
- Wrong `19Ff...` Sheet는 변경하지 않는다.

## 별도 후속 Gate

- Five-person Comprehension
- final art와 production icon
- target100 공식 카탈로그
- online challenge·UGC
- Google Play submission·등급·asset rights evidence
- production default entrypoint cutover
