# FP Core Proof Map Correction

```yaml
status: IMPLEMENTATION_CORRECTION
correction_id: FP-CORR-001
parent_spec: FP-DOR-001
parent_plan: docs/superpowers/plans/2026-08-05-finite-puzzle-first-vertical-slice.md
trigger: ADVERSARIAL_STRUCTURAL_REVIEW
risk: HIGH_CANON_IMPACT
checkpoint_policy: EARLY_CHECKPOINT_ALLOWED
implementation_package: FP-01C
```

## 발견된 충돌

승인 계획의 초기 `FP_CORE_PROOF_01` 좌표는 승인된 구조 규칙과 동시에 만족될 수 없다.

1. `[5,4]`의 수평 B 화물 앵커는 `[4,4]` 차단 셀과 직접 충돌한다.
2. `[9,2]`, `[9,6]`의 수평 역 앵커는 승인된 `buildable_rects`가 `x=9`에서 끝나므로 우측 연결 선로를 만들 수 없다.
3. 첫 Slice에는 종착역·자동 반전·회차 선로가 없으며, preflight는 모든 도달 가능한 비종착 상태가 후속 경로를 가져야 한다.
4. 따라서 기존 수치를 유지하려면 구조 검사를 약화하거나 승인되지 않은 종착·반전 규칙을 추가해야 한다.

## 교정 원칙

규칙을 약화하거나 새 기능을 몰래 추가하지 않고, Task 5에서 자동 검증된 폐쇄 방향망을 대표 맵에 적용한다.

- 보드: `11×9`
- 시작/진입: `[1,4]` / `[0,4]`
- 제한 시간: `90.0` TEST_VALUE
- 차단 셀: `[4,3]`, `[4,5]`, `[6,3]`, `[6,5]`
- 역 A: `[8,5]`, 수직 직선
- 역 B: `[10,7]`, 좌상 곡선
- 화물 조우 순서: A `[9,4]` → B `[10,5]` → A `[10,6]` → A `[9,7]`
- 건설 사각형: `[1,1]..[10,8]`, 양 끝 포함
- 시작·진입·역·화물·차단 셀은 건설 가능 목록에서 제외

## 핵심 재미 보존

폐쇄 순환망에서 A/B/A/A를 적재한 뒤 B역은 TOP 불일치로 통과하고 A역에서 A 두 개만 먼저 하역한다. 다음 순환에서 B를 하역하고, A역을 다시 방문해 마지막 A를 하역할 수 있다.

두 수용 fixture는 동일 정답을 노출하지 않도록 첫 분기의 초기 출구를 다르게 하며, 서로 다른 `layout_signature`를 가진다. 두 fixture 모두 preflight PASS와 동일한 LIFO 재방문 가능성을 증명해야 한다.

## 권위 해석

이 교정은 `FP-DOR-001`의 핵심 범위·규칙·수용 기준을 바꾸지 않는다. 충돌하는 초기 좌표 수치만 대체하며, 기존 좌표는 `[대체됨: FP-CORR-001]`으로 취급한다.
