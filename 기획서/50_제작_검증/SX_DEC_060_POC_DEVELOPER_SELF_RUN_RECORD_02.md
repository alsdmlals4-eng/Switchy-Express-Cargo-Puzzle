# SX-DEC-060 POC Developer Self-Run Record 02

Status: `PACKAGE_VERIFICATION_PASS · HUMAN_PHYSICAL_SELF_RUN_NOT_RUN`

```yaml
candidate_id: SX60-POC-ACCEPT-002
pointer: evidence/acceptance/post_sx_dec_060_candidate.json
source_main: 0e882764b837d13282a7642b115948d4e061d163
artifact_evidence_owner: evidence/acceptance/sx60_poc_accept_002_artifact.json
deep_pck_evidence_owner: evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json
candidate_zip_sha256: b2602554ec28ba8597cc509c6dc2e1b61a946ca193a31673ed96bf9671c8c8e3
no_launch_package_verification: PASS · 2026-08-27 · explicit Candidate 002 NoLaunch PowerShell verification
physical_self_run_verdict: NOT_RUN
```

From current project `main`, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1
```

The launcher may download only the explicit Candidate 002 artifact after archive/API digest, EXE/PCK hash, proof-log, and source-ancestry checks. Record actual Windows visual/input/audio observations separately. No human, device, or player-experience result is pre-filled in this record.
