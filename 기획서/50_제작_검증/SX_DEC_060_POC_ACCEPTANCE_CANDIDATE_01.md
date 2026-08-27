# SX-DEC-060 POC Acceptance Candidate 01

Status: `HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE · PACKAGE_EVIDENCE_PRESERVED · HUMAN_PHYSICAL_EVIDENCE_NOT_RUN`

```yaml
candidate_id: SX60-POC-ACCEPT-001
decision_id: SX-DEC-060
source_main: 7b7f350345619e870bb94e12954fbe81b1ef9403
candidate_status_at_invalidation: PREPARED_PACKAGE_VERIFIED
historical_role: HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE
invalidation_reason: PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE
invalidated_by_product_source_main: a8eee4f875a95e8da69802c4e60452df3535fe0e
current_candidate_eligibility: PROHIBITED
workflow_run: 32977087650
artifact_id: 9609930575
artifact_evidence_owner: evidence/acceptance/sx60_poc_accept_001_artifact.json
deep_pck_evidence_owner: evidence/acceptance/sx60_poc_accept_001_pck_deep_audit.json
package_integrity: PASS
windows_runtime_json: PASS
android_validation_runtime_json: PASS
launcher_no_launch_package_verification: PASS
windows_physical_startup_and_build_entry_automation_observed: PASS
developer_self_run: NOT_RUN
windows_physical_runtime: NOT_RUN
audio_perceptual_qa: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
```

Candidate 003 remains historical pre-060 evidence only. Candidate 001 is immutable package evidence for `7b7f350…`, but it is no longer a current acceptance route: the player-facing runtime route-readability merge `a8eee4f875a95e8da69802c4e60452df3535fe0e` changed product bytes afterward. Its pinned hashes, artifact/PCK audit, and limited automation observation remain preserved; every human evidence field remains `NOT_RUN`. `PR #201` is tooling-only and does not invalidate a candidate. Mint a new exact package candidate sourced from `a8eee4f…` (or an explicitly verified descendant) before any Windows physical, audio, Android, five-person, or player-experience gate.
