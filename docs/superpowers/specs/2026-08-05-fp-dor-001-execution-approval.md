# FP-DOR-001 Execution Approval

```yaml
status: IMPLEMENTATION_AUTHORIZED
spec_id: FP-DOR-001
plan: docs/superpowers/plans/2026-08-05-finite-puzzle-first-vertical-slice.md
approval_evidence: EV-USER-021
approved_at: 2026-08-05T00:23+09:00
execution_mode_requested: SUBAGENT_DRIVEN_DEVELOPMENT
available_execution_mode: TASK_GATED_INLINE_WITH_INDEPENDENT_REVIEWS
first_package: FP-01A
legacy_runtime_default: true
next_gate: FP-01A_TASK_1_RED
```

사용자는 권장 실행안으로 구현을 진행하도록 승인했다.

이 환경에는 실제 Codex 하위 에이전트 호출 인터페이스가 노출되어 있지 않으므로, 다음 품질 계약을 동일하게 적용한다.

- Task마다 독립적인 TDD red→green→refactor 증거를 남긴다.
- Task 구현 후 명세 준수 검토와 코드 품질 검토를 분리한다.
- 각 package는 독립 PR로 작성하며 이전 package를 암묵적으로 확장하지 않는다.
- Critical·Important finding이 남으면 다음 Task로 넘어가지 않는다.
- 기존 endless runtime은 FP-02C 수용 Gate 전까지 기본 진입점으로 유지한다.
- 구현·Android·사람 검증은 실제 증거 전 PASS로 표시하지 않는다.

권위 연결:

- 제품 정본: `GMB-002 · SX-DEC-027~036`
- 선행 감사: `SX-AUD-012`
- 승인 명세: `FP-DOR-001`
- 명세 승인: `EV-USER-020`
- 실행 승인: `EV-USER-021`
