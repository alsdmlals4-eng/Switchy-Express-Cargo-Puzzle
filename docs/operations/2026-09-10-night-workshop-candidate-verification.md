# Night workshop candidate preparation receipt

Scope: candidate art/Aseprite preparation only. Date2026-09-10 KST.
Approved design PR #282 merged at `6b96868d2de890a85b043aa52abcbabb9fc4fce0`; all four reported checks succeeded and merged main was fetched/read back. Its tree equals the approved PR head. The retired task branch was deleted locally/remotely after this check; PR/merge commits preserve recovery.

Current continuation branch: `codex/night-workshop-asset-preparation-20260910`, based on that merged main. Root dirty import/UID changes remain untouched. The separate local-main checkout under `C:/Users/user/AppData/Local/Temp/sxlrn-0831` reports widespread missing tracked files; no pull/reset/restore was attempted there. Current isolated task and GitHub main are distinct from that unresolved local checkout.

## Results

- Project operating contract: PASS; existing machine-primary policy tests8/8 PASS; current-authority migration tests7/7 PASS; diff hygiene PASS.
- Cleanup attempt for the task-owned Aseprite staging directory was rejected by execution policy before running. No staging file was deleted. The directory `C:/Users/user/.local/share/aseprite-local/candidates/switchy-night-workshop-20260910-r1` remains; selected source/export files are also preserved in this candidate package. No alternative deletion mechanism was attempted.

- Candidate extraction/alpha/metadata validator: PASS. Four distinct448×448 frames,60ms each,240ms total; fixed x bounds56..392; intended lift/settle y positions; untrimmed export1798×448 with2px padding.
- Original visible cargo pixels preserved exactly through Aseprite extraction and translation. Original rail center pixels preserved; only verified alpha<=1 exterior padding replaced with alpha0.
- Selected PNGs are RGBA with actual transparent pixels and alpha0 corners; no RGB checkerboard is accepted.
- Final train source: `exec-8a1ceb44-ae09-42f9-9e66-9b0de5976fba.png`, fresh directly-overhead generation. The failed side-view and two baked-checkerboard edits are excluded.
- Aseprite actual create/import/frame-duration/export/info tools succeeded. Editable rail and cargo source files are preserved with output PNG/JSON.
- Visual inspection: exported cargo sequence and generated rail/train/station inspected. Mild internal painted variation remains between cargo frames. Image generation produced1254px square originals rather than requested dimensions, so actual dimensions govern extraction.
- Five self-review loops and corrections: candidate README. This is not independent human review.
- Rail tile extraction/endpoint/tangent/rotation proof: NOT_VERIFIED. A connected picture alone does not satisfy it.
- Gameplay code, engine scene, current production manifest: unchanged. Godot import/regression/runtime for new candidates: NOT_RUN. Final pixel approval, UX, release: NOT_RUN.

## SHA-256

| File in evidence/design/night-workshop-assets-20260910 | SHA-256 |
|---|---|
| cargo-lift-ready.json | d785a83361f1f23b905175699cbbaf3bc40fd1dba8c80808c569fb7758bb5138 |
| cargo-lift-ready.png | 6d365fe9b8c6a1f03fd141aba753ce23817d6f34074af0651caac4c74db7f445 |
| cargo-lift.aseprite | 03836acd2a49b78c1b1b529e1d3e0c3ffd0ec254b6aa127b493d2ad72d07ad35 |
| cargo-source.png | b04509ca0498f7a40d15625c4cb183b5f5ba04f16ecb08eae53771ede4c3114a |
| rail-master.aseprite | 76e30efe3552da6e5cbabf503bde255146caa18a4e79a319043893f59021a0d2 |
| rail-master.png | 93d46d7b72154a04f314c72151e19bc32d5a2aed20e3fe2bc7786a0c89951e84 |
| rail-source.png | 2f97ccd59ec12a1afcf4f9ff761beab4dd30c3ece9aad5eceb17574de5641b13 |
| station-blue.png | eceb082d07b94ee0f65afdfa71d8b24004ae80513df7b2f4e000f735e4657827 |
| train.png | 00f40947e63a183c223d3276c9ccbc14c33226df369727bbf228d5afe1b253f2 |

## Learning and limits

Repeated failures were explicit: requested dimensions are not guaranteed; editing an image can return a baked checkerboard; independently painted frames wobble; isolated alpha residue can survive regeneration. Response: read actual pixels, retain source, align with Aseprite and keep machine assertions separate from visual approval. The candidate-specific validator is project-local. Base promotion remains a proposal until the complete production/runtime method is verified.
