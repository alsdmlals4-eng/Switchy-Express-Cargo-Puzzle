# SX-AUD-032 — Windows Artifact Integrity / Physical Gate Audit

Date: `2026-08-08 KST`

## Verdict

`ARTIFACT_INTEGRITY_PASS · WINDOWS_RUNTIME_NOT_RUN · PHYSICAL_GATES_OPEN`

The final reviewed Windows Demo artifact produced for the already-merged `SX-DEC-041` / `SX-DEC-042` product change was downloaded and independently inspected. Archive and payload integrity are verified. This evidence does **not** establish a physical Windows launch, visual, audio, input, local F5, Android-device, connected-HiGodot, or human-readability PASS.

## Authority

- Base main: `fa69a77a14f923a756064f6ae151d34cadb374f7`
- Current project main before this audit: `8b91c88db49f223ecb59664bd9bfe7047343c9f6`
- Product merge: `12d1ef9b5c49e401d32dfc283db11a12574b5da3` · PR #106
- Reviewed final product PR head: `9c884e85efa9b60cbba21253fc71db034cc753d0`
- Windows Demo Export run: `31226750575` · PASS
- Windows artifact ID: `9012367353`
- Artifact name: `switchy-express-windows-demo-598103af43982332592772a4be5ea24dfd5a44c4`
- Artifact workflow head SHA: `9c884e85efa9b60cbba21253fc71db034cc753d0`
- `SX-DEC-041` — route-end failure ordering and SUCCESS priority
- `SX-DEC-042` — reciprocal three-direction direct switch selection / U-turn
- `SX-DEC-046` / `VIS-014` — procedural route-control component; no new binary visual/audio asset

## Downloaded artifact evidence

GitHub reported the artifact as unexpired and returned:

- artifact size: `38,013,769` bytes
- artifact digest: `sha256:d5255e6dcf1c21cbcd7a57deef5899975c1399a80eaaef3d3e99ee9f8deebd1e`

The downloaded ZIP was freshly hashed in the validation runtime:

```text
ZIP bytes=38013769
sha256=d5255e6dcf1c21cbcd7a57deef5899975c1399a80eaaef3d3e99ee9f8deebd1e
```

The downloaded archive digest therefore matches GitHub's artifact digest exactly.

## Payload inventory and hashes

The artifact archive contains these three files at archive root:

| File | Bytes | SHA-256 |
|---|---:|---|
| `SwitchyExpressVerticalSlice.exe` | `102,982,144` | `1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244` |
| `SwitchyExpressVerticalSlice.pck` | `3,041,212` | `fff3b0d10b384601ac2350eb0c759d3a314b2677b50ee46e02d8a26dc097d639` |
| `SHA256SUMS.txt` | `226` | `9a862dbe8122f5a50fe149c3e6bb5c049e4f6a0268cc052f9d8ee3fcd97219f9` |

`SHA256SUMS.txt` records the build-time paths:

```text
1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244  builds/windows/SwitchyExpressVerticalSlice.exe
fff3b0d10b384601ac2350eb0c759d3a314b2677b50ee46e02d8a26dc097d639  builds/windows/SwitchyExpressVerticalSlice.pck
```

## Artifact packaging path finding

GitHub Actions artifact upload flattens the selected files to the archive root, while the generated checksum file preserves the original build-time relative paths under `builds/windows/`.

Therefore a direct `sha256sum -c SHA256SUMS.txt` from the extracted archive root reports missing paths. That is a packaging-path mismatch, not a payload-hash mismatch.

To validate the payload without changing bytes, the two root payload files were copied into the original relative directory structure and the existing manifest was checked unchanged:

```text
builds/windows/SwitchyExpressVerticalSlice.exe: OK
builds/windows/SwitchyExpressVerticalSlice.pck: OK
```

Verdict for payload integrity: `PASS`.

## Executable format inspection

Fresh file inspection identifies the executable as:

```text
PE32+ executable for MS Windows 5.02 (GUI), x86-64, 12 sections
```

This proves the artifact contains a non-empty x86-64 Windows GUI executable plus its external Godot PCK. It does not prove that the executable launches successfully on a physical Windows machine.

## Runtime evidence ceiling

The current ChatGPT validation runtime does not expose the user's Windows checkout at:

`C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle`

and neither `wine` nor `wine64` is installed. The runtime also cannot provide a physical Windows desktop/input/audio session. Consequently:

- Windows executable launch: `NOT_RUN`
- Windows visual smoke: `NOT_RUN`
- Windows audio smoke: `NOT_RUN`
- Windows mouse/keyboard physical input: `NOT_RUN`
- local Godot F5: `RETEST_REQUIRED`
- local BLUE one-sided station reproduction: `RETEST_REQUIRED`
- practical three-arrow readability / click-target feel: `RETEST_REQUIRED`
- Android device smoke: `NOT_RUN`
- connected HiGodot authoring session: `NOT_RUN`
- five-person comprehension: `NOT_RUN`
- production cutover: `BLOCKED`

No physical/manual gate is promoted by this audit.

## Current-main execution limitation

The container cannot mount the user's Windows checkout. A direct container network fetch of the repository source also fails because the container runtime has no working GitHub DNS/network path. The connected GitHub interface remains authoritative for repository reads and Actions evidence, but the available GitHub actions interface in this session does not expose a workflow-dispatch operation.

Both current workflows retain manual dispatch contracts:

- `.github/workflows/windows-demo-export.yml` — `workflow_dispatch`, full headless tests, Windows debug export, payload hash generation and artifact upload.
- `.github/workflows/android-validation-apk.yml` — `workflow_dispatch`, pinned Godot/Android toolchain, complete headless suite, APK export, SHA/manifest/provenance evidence; its own summary deliberately keeps device/human gates `NOT_RUN`.

This audit therefore does not fabricate a current-main dispatch or device execution that was not run.

## Next physical validation sequence

The next authority remains execution on the user's merged local main and physical targets:

1. `Fetch origin` / `Pull origin` until local `main` matches current GitHub main.
2. Reopen Godot 4.7.1 and use Project Play (`F5`).
3. Recheck BLUE one-sided station parity against the stale historical local failure.
4. Recheck `ROUTE_END` result copy and final-delivery SUCCESS priority.
5. Recheck all three switch arrows, direct selection, incoming-direction U-turn, occupied lock, and practical pointer/touch target readability.
6. Launch the verified Windows artifact on physical Windows and check visual/audio/input behavior.
7. Build/install the canonical Android validation APK on a landscape device and run the device smoke.
8. Run human comprehension/readability validation only after device/runtime evidence exists.

Until those observations exist, the correct ceiling is:

`ARTIFACT_INTEGRITY_PASS · WINDOWS_RUNTIME_NOT_RUN · CUTOVER_BLOCKED`
