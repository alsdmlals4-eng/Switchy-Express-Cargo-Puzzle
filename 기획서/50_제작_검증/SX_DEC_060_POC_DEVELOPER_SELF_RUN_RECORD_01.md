# SX-DEC-060 POC Developer Self-Run Record 01

Status: `PACKAGE_VERIFICATION_PASS_NO_LAUNCH · INITIAL_WINDOWS_RENDER_AUTOMATION_OBSERVED · HUMAN_PHYSICAL_SELF_RUN_NOT_RUN`

```yaml
candidate_id: SX60-POC-ACCEPT-001
pointer: evidence/acceptance/post_sx_dec_060_candidate.json
artifact_evidence_owner: evidence/acceptance/sx60_poc_accept_001_artifact.json
no_launch_package_verification: PASS · 2026-08-26 · exact artifact re-downloaded and EXE/PCK/proof logs rechecked
windows_physical_startup_and_build_entry_automation_observed: PASS · 2026-08-26 · title screen rendered; Demo Start reached build board
physical_self_run_verdict: NOT_RUN
```

From current project `main`, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1
```

The launcher downloads only the explicitly pinned artifact, verifies its archive/API digest and EXE/PCK SHA-256 values, then launches it. `-NoLaunch` package verification passed on 2026-08-26. An automation-observed run rendered the title screen and build board; record human physical, audio, and input observations separately, because no human self-run result is pre-filled here.
