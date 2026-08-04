# [대체됨] VS-03 Package Status Registry

```yaml
status: REPLACED_BY_GMB_002
historical_main: a2eec83f55b172fdf6d7a69cca9659dc30448fe0
old_last_package: VS03_R1_HEADLESS_MERGED
current_product_state: FINITE_PUZZLE_REPLAN_REQUIRED
next_authority: FINITE_PUZZLE_DEFINITION_OF_READY
```

## 역사적으로 완료됨

| Package | 상태 | 역사 증거 |
|---|---|---|
| VS03-01 | MERGED_AND_VERIFIED | PR #37/#38 · SX-AUD-006 |
| VS03-02 | MERGED_AND_VERIFIED | PR #41/#42 · SX-AUD-008 |
| VS03-03 | MERGED_AND_VERIFIED | PR #46/#47/#48 · SX-AUD-010 |
| VS03-R1 | MERGED_AND_VERIFIED | PR #49 · SX-AUD-011 |

이 기록은 old endless core의 구현 사실이다.

## 실행 금지

다음 old order는 `[대체됨]`이며 자동 실행하지 않는다.

```text
VS03-05A
→ VS03-04
→ VS03-05B
→ VS03-06
→ VS03-07
```

사유:

- player track construction이 기존 완성형 RailGraph 제품 화면을 대체
- finite delivery/time limit가 fuel-zero endless loop를 대체
- unlimited stack이 capacity 8 표현을 대체
- tutorial 1~10이 first endless run onboarding을 대체
- stars/3 leaderboards가 old standard records를 대체

## 새 package 준비

새 package ID는 `FP-*` prefix를 사용한다.

- FP-DoR: product contract·identity·test boundary
- FP-01: track construction domain
- FP-02: finite delivery run
- FP-03: Combo and track performance
- FP-04: tutorial and authored maps
- FP-05: stars and local records
- FP-06: product surface and device evidence
- FP-Production: online challenges and leaderboards

새 DoR 승인 전 모든 FP package는 `NOT_READY_FOR_BUILD`다.

## 권위 링크

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- `기획서/00_프로젝트_허브/ROADMAP.md`
- `기획서/50_제작_검증/SX_AUD_012_FINITE_DELIVERY_PIVOT_AUDIT.md`
