# Roadmap

## 현재 제품 권위

```text
GMB-002 · SX-DEC-027~036
→ finite delivery track-building puzzle
→ implementation replan required
```

정본: `FINITE_DELIVERY_PUZZLE_BASELINE.md`
감사: `SX-AUD-012_FINITE_DELIVERY_PIVOT_AUDIT.md`

## 역사적으로 완료된 기반

- [x] M0 운영체계 설치
- [x] Godot RailGraph·자동 이동·분기 기반
- [x] CargoStack·LIFO·Station domain
- [x] compact token/TrainFootprint seam
- [x] map/session/restart identity 기반
- [x] old endless run lifecycle·difficulty implementation

마지막 항목은 `[역사 증거]`이며 새 제품 권위가 아니다.

## 제품 기준선 전환 — CURRENT

- [x] 자유 선로 건설·비용·건설 불가 구역 승인
- [x] 유한 배송·제한 시간·성공/실패 승인
- [x] 무제한 LIFO·수동/자동 적재 승인
- [x] 선로 종류·Combo 가속 승인
- [x] 별·3종 리더보드 승인
- [x] 튜토리얼·챕터·반복 도전 승인
- [x] SX-AUD-012 적대적 검토
- [ ] GitHub canonical PR merge
- [ ] correct Sheet same-ID sync and 12-tab readback

## FP-M0 — 새 Definition of Ready

- [ ] legacy code 재사용·제거 inventory
- [ ] MapDefinition/TrackLayout identity
- [ ] track editor graph·cost contract
- [ ] finite run state contract
- [ ] unlimited stack representation
- [ ] star/score/leaderboard ruleset
- [ ] tutorial 1~10 map specification
- [ ] package boundaries·rollback·test plan
- [ ] adversarial DoR audit
- [ ] 사용자 승인

## FP-M1 — 건설 가능한 대표 맵

- [ ] 건설 가능/불가 표면
- [ ] 직선·곡선·분기·교차
- [ ] 비용·철거 전액 환급
- [ ] 추천 ghost route와 예상 비용
- [ ] 모든 역·화물 도달 가능성 검사
- [ ] trap detector

## FP-M2 — 유한 배송 코어

- [ ] 수동 적재 기본
- [ ] 자동 적재 토글
- [ ] 무제한 CargoStack
- [ ] TOP 연속 그룹 하역
- [ ] station skip
- [ ] 최대 1초 가시 하역
- [ ] time limit success/failure
- [ ] 실패 후 노선 유지
- [ ] pause integrity

## FP-M3 — 최적화 선로와 Combo

- [ ] 가속·저비용·일방통행
- [ ] 회차
- [ ] Combo 가속·점수
- [ ] 속도 상한
- [ ] 지배 전략 simulation

## FP-M4 — 튜토리얼·캠페인

- [ ] 1~10 tutorial
- [ ] 요청형 3단계 hint
- [ ] chapter/bundle/exam
- [ ] 최소 3개 본편 representative maps
- [ ] speed/cost/score 별 목표 playtest

## FP-M5 — 별·기록·제품 화면

- [ ] 누적 3별
- [ ] local speed/cost/score board
- [ ] build/run/result HUD
- [ ] 결과 분석
- [ ] cosmetic-only chapter rewards

## FP-M6 — Android·사람 검증

- [ ] landscape build UX
- [ ] 8/16/32 cargo readability
- [ ] 분기 reach·load hold ergonomics
- [ ] color+shape accessibility
- [ ] Korean/English localization stress
- [ ] balance simulation
- [ ] 최소 5명 human test

## FP-Production — 온라인 반복 도전

- [ ] fixed-seed daily/weekly
- [ ] online 3 leaderboards
- [ ] percentile rewards
- [ ] archive replay
- [ ] anti-cheat·ruleset identity
- [ ] live ops and moderation

## 보류

- UGC editor·publication·community
- 환적역
- 다중 열차·신호 자동화
- procedural campaign

## 대체된 실행 순서

기존 `VS03-R1 → VS03-05A → VS03-04 → VS03-05B → VS03-06 → VS03-07`은 `[대체됨]`이다. 새 DoR 승인 전 제품 구현을 자동 진행하지 않는다.
