# Roadmap

## 현재 제품 권위

```text
GMB-002 · SX-DEC-027~036
→ finite delivery track-building puzzle
→ automated core implemented and verified
→ validation preparation complete
→ CANONICAL MAIN APK EXPORT · PASS
→ ANDROID DEVICE SMOKE · CURRENT
```

정본:

- `FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `CURRENT_CONFIRMED_DECISIONS.md`
- `ACTIVE_CONTEXT.md`
- `DEVELOPMENT_GATES.md`
- `../50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

## 완료된 기반

### M0 — 제품 기준선·실행 계약 · PASS

- [x] finite delivery product pivot
- [x] `GMB-002 · SX-DEC-027~036`
- [x] correct Sheet same-ID sync and readback
- [x] finite Definition of Ready and package plan
- [x] legacy code inventory and authority separation

### M1 — 건설 가능한 대표 맵 · PASS

- [x] authored map and buildable/non-buildable surface
- [x] 직선·곡선·분기·교차
- [x] 비용·철거 전액 환급
- [x] start·station·cargo reachability
- [x] dangling edge·crossing·branch exit·permanent trap 검사
- [x] sealed TrackLayout and graph identity

추천 ghost route와 확장 선로 종류는 후속 범위다.

### M2 — 유한 배송 코어 · PASS

- [x] 수동 적재와 자동 적재 토글
- [x] 무제한 CargoStack
- [x] TOP 연속 그룹 하역
- [x] 최대 1초 가시 하역
- [x] 제한 시간 success/failure
- [x] pause integrity
- [x] 실패 후 노선 유지와 fresh-runtime retry
- [x] persistent branch direct tap and occupied lock

### M3 — 제품 화면·통합 Proof · PASS

- [x] landscape BUILD/RUN/PAUSE/RESULT surface
- [x] preflight 문제와 비용 표시
- [x] 색상+형상+텍스트 LIFO 표현
- [x] 최소 48dp 상당 핵심 조작 영역
- [x] UI command 기반 `A → B → A → A` / `2 → 1 → 1` 자동 proof

### M4 — Validation 준비 · PASS

- [x] isolated validation launcher
- [x] `PROOF / STACK 8 / STACK 16 / STACK 32`
- [x] on-device Selector and Back
- [x] fail-closed invalid mode
- [x] Android validation preset and isolated package
- [x] production entrypoint invariance

### M5 — CANONICAL MAIN APK EXPORT · PASS

```yaml
workflow_run_id: 31011620357
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
tests: 65 cases · 10,792 assertions · 0 failures
attestation_id: 39044925
```

- [x] APK, `.sha256`, manifest and provenance match
- [x] product default entrypoint remains legacy

## M6 — ANDROID DEVICE SMOKE · CURRENT

Authority:

- `../50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- `../50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`

- [ ] canonical full APK SHA-256 verification
- [ ] physical Android landscape device record
- [ ] install·first boot·cold reboot
- [ ] four Selector modes and Back
- [ ] BUILD·preflight·RUN·pause/resume·result·retry/edit
- [ ] LOAD hold·auto-load·branch direct tap·occupied lock
- [ ] 8/16/32 rear/TOP readability
- [ ] safe area·touch target·clipping·overlap·input omission
- [ ] crash·ANR·script error·severe frame degradation check
- [ ] AND-01~20 all item evidence
- [ ] completeness·privacy·adversarial review

Status: `NOT_RUN`.

## M7 — FIVE-PERSON COMPREHENSION

Status: `NOT_RUN · BLOCKED_BY_M6`.

Same canonical APK hash after reviewed Android PASS:

- [ ] P01~P05 first-contact sessions
- [ ] 4/5+ identify last-loaded cargo as TOP
- [ ] 4/5+ explain A-station revisit for `A/B/A/A`
- [ ] 4/5+ distinguish same-layout retry and edit
- [ ] shape/text identification without color-only dependence
- [ ] facilitator coaching and participant evidence separation

## M8 — PRODUCTION CUTOVER REVIEW

Status: `BLOCKED_BY_M6_M7`.

- [ ] Android reviewed PASS
- [ ] Five-person reviewed PASS
- [ ] P0/P1 open finding 0
- [ ] default entrypoint cutover design and rollback
- [ ] separate production package/signing evidence
- [ ] GitHub canon and correct Sheet same-ID closure

Legacy deletion is not part of cutover and requires a separate migration package.

## 후속 제작 Roadmap

### Core expansion

- 가속·저비용·일방통행·회차·터널·교량
- Combo 가속·점수 tuning
- 추천 ghost route and cost comparison
- dominant-strategy simulation

### Campaign·meta

- tutorial stages 1~10
- chapter·bundle·exam
- speed·cost·score stars and local records
- result analysis and cosmetic-only rewards

### Production content·online

- 100+ official validated layouts
- fixed-seed daily/weekly challenge
- online leaderboards and anti-cheat
- archive replay
- UGC editor·publication·moderation·privacy·community

### Release

- final art and production icon
- localization and accessibility stress
- Google Play rating·target audience·store consistency
- asset rights and provenance completion
- release signing and submission

## 역사 경계

기존 endless 생존 흐름과 old `VS03-R1 → VS03-05A → VS03-04 → VS03-05B → VS03-06 → VS03-07` 순서는 `[대체됨 · 역사 증거]`다. 과거 구현·감사·계획은 보존하지만 현재 Roadmap과 다음 작업 권위를 갖지 않는다.
