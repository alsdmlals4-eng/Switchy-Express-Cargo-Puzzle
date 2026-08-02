# Base v9.4 적용 감사 — Switchy Express

```yaml
decision_id: DEC-2026-08-01-001
issue: 14
baseline_commit: 4e435a1a6d10ab146197671049da80709fd18c1f
adoption_main_commit: 539d2bae18d20e303649f047b9df69e8e224b2e7
base_version: 9.4.0
base_payload: a728712cb776ec98f4875914a580fcf7d0156593
base_evidence: ef1fba11167e4da0b298123b0c85ebd268191a42
base_finalization: 87a0b54c2847ce4b685879209205957c170cc1cd
base_registry_sha256: 693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59
adoption_scope: OPERATING_CONTRACT_ONLY
product_logic_changed: false
gdd_sheet_written: PENDING_POST_VS02_CANONICAL_SYNC
android_validation: NOT_RUN
human_validation: HUMAN_NOT_RUN
provider_measurement: NOT_RUN
```

프로젝트 Skill 1개, 자동 열차·15×10 RailGraph·분기·직진 우선·LOAD·LIFO·배송·연료·속도·BOOST·게임오버·결정론·spawn 회복 규칙을 보존한다.

UI 모션은 분기·적재·하역·점수·연료·게임오버·저장의 권위가 아니다. Context 큐레이션은 영구 생존·후보 부족·경로 엔트로피·LIFO 회귀 근거를 제거하지 않는다.

## 검증 증거

- PR #15 exact HEAD
- Project Contract: PASS
- Base v9.4 focused adoption test: PASS
- Godot full headless regression: PASS
- `9 cases / 6915 assertions / 0 failures`

## 남은 동기화

PR #15는 의도적으로 Google Sheets를 쓰지 않았다. Post-VS02 canonical recovery에서 다음을 같은 `DEC-2026-08-01-001`과 `EV-BASE-V94-001`로 연결한다.

- Base version·payload·evidence
- 제품 로직 미변경
- 자동 검증과 미검증 경계
- 실제 canonical recovery commit
- Sheet readback 결과

Sheet 재조회 전에는 `SYNCED`로 판정하지 않는다.
