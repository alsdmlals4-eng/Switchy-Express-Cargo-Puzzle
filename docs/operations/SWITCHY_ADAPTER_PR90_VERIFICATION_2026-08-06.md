# Switchy Express PR #90 Exact-Head Verification Record

```yaml
decision_id: DEC-BASE-20260805-001
pull_request: 90
trusted_base_validator: bfdc9e44d4a6920dc085eaa3f9d19d31b1acd2a1
exact_pr_base: 8c6dd60c634019e64178e72aa4959a2a970708e1
pre_record_head: a71a15c4975c133046c1347ce5ed2dc715b87b79
main_sync_pr: 92
main_sync_merge: b6badeeb2ed1eaaeac50b0cea16c12178abb0560
bounded_migration_run: 31054923110
baseline_refresh_run: 31055315554
adapter_contract_generation: PASS
base_contract_check: PASS
exact_head_pull_request_workflows: RERUN_REQUESTED_BY_OWNER_COMMIT
product_files: UNCHANGED_BY_ADAPTER_MIGRATION
google_sheets: UNCHANGED
physical_device_validation: NOT_RUN
human_validation: HUMAN_NOT_RUN
production_adapter_ready: NOT_READY
merge_authorization: NOT_GRANTED
```

## Why this record exists

The bounded generator and baseline-refresh workflows committed their verified outputs using `github-actions[bot]`. GitHub classified the resulting pull-request workflow attempts as `action_required` without creating jobs. This owner-authored record requests a normal exact-head pull-request run without changing the adapter contract, product behavior, Godot Pilot adoption, APK evidence, or Google Sheet.

## Preserved boundaries

- PR #89's self-contained Godot Pilot evidence is present from current `main` and is not modified by the adapter migration.
- The active project Registry contains project-owned Skills only; the full previous mixed Registry is preserved in `docs/PROJECT_OPERATING_STATE.json`.
- Base routes remain resolved from the immutable Base Registry and are not copied into project authority.
- The adapter baseline equals the exact pull-request base.
- The official Base generator produced the Snapshot, Dashboard, router, and compatibility views.
- Runtime, device, accessibility, human, and production-readiness claims are not promoted by this repository-contract migration.
