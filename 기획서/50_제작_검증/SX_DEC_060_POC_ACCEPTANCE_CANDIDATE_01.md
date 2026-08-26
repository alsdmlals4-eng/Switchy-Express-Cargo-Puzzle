# SX-DEC-060 POC Acceptance Candidate 01

Status: `PREPARED_PACKAGE_VERIFIED · INITIAL_WINDOWS_RENDER_AUTOMATION_OBSERVED · HUMAN_PHYSICAL_EVIDENCE_NOT_RUN`

```yaml
candidate_id: SX60-POC-ACCEPT-001
decision_id: SX-DEC-060
source_main: 7b7f350345619e870bb94e12954fbe81b1ef9403
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

Candidate 003 remains historical pre-060 evidence only. This candidate is the sole explicit post-060 package route. The launcher redownloaded and rechecked the pinned package with `-NoLaunch`, then an automation-observed Windows run rendered the title screen and reached the Demo Start build board. That limited observation is neither a human self-run nor full visual/input/audio validation.
