# Switchy Express PR #90 Exact-Head Verification Record

```yaml
decision_id: DEC-BASE-20260805-001
pull_request: 90
trusted_base_validator: bfdc9e44d4a6920dc085eaa3f9d19d31b1acd2a1
exact_pr_base: 8c6dd60c634019e64178e72aa4959a2a970708e1
main_sync_pr: 92
main_sync_merge: b6badeeb2ed1eaaeac50b0cea16c12178abb0560
bounded_migration_run: 31054923110
baseline_refresh_run: 31055315554
adapter_contract_generation: PASS
base_contract_check: PASS
legacy_contract_tests: ALIGNED_TO_TYPED_ROUTES_PROJECT_ONLY_REGISTRY_AND_CURRENT_SHEET_TOKEN
exact_head_pull_request_workflows: FINAL_RERUN_REQUESTED
product_files: UNCHANGED_BY_ADAPTER_MIGRATION
google_sheets: UNCHANGED
physical_device_validation: NOT_RUN
human_validation: HUMAN_NOT_RUN
production_adapter_ready: NOT_READY
merge_authorization: NOT_GRANTED
```

## Verification sequence

1. The bounded migration preserved the original adapter and mixed Registry in `docs/PROJECT_OPERATING_STATE.json`.
2. The active project Registry was narrowed to project-owned Skills and retains `switchy-express-design` with matching legacy `id` and canonical `skill_id`.
3. The adapter was rebuilt as a typed Base v1 thin adapter.
4. Current `main` from PR #89 was merged into the feature branch without changing its four Godot Pilot adoption files.
5. The exact adapter baseline was refreshed to the current PR base.
6. Base's official generator and validator passed on that baseline.
7. The first owner-triggered PR run exposed four legacy tests that still expected string routes, mixed Registry ownership, or `SYNCED` as the contract token.
8. Those tests now read typed `skill_id` routes, project-only Registry authority, and `CURRENT` plus preserved `declared_sync_status: SYNCED`.
9. This owner-authored update requests the final exact-head workflow run.

## Preserved boundaries

- PR #89's self-contained Godot Pilot evidence is present from current `main` and is not modified by the adapter migration.
- Base routes remain resolved from the immutable Base Registry and are not copied into project authority.
- The adapter baseline equals the exact pull-request base.
- The official Base generator produced the Snapshot, Dashboard, router, and compatibility views.
- Product code, planning canon, APK evidence, Godot Pilot adoption content, and Google Sheet cells are unchanged by the adapter migration.
- Runtime, device, accessibility, human, and production-readiness claims are not promoted by this repository-contract migration.
