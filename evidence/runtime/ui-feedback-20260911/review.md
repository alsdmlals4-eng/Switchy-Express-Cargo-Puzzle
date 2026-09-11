# UI feedback and Blueprint verification

Source base: 0708eb5306c235ec1ce251d6329c7ebfa6f2620f.
Consumer source: the commit containing this receipt; no new bitmap promotion.
Godot 4.7.1: regression.log ends 121 cases / 0 failed / 14,497 assertions, exit 0.
Python tests/python discovery: 261 tests, 1 skipped, exit 0. Project contract PASS.

Live session: codex-core-preserved-replan-20260910@2922. RB01 programmatic UI and authored
witness with manually stepped clock: receipt.json. Manifest fixture: manifest-receipt.json.
1280x720 framebuffer; HUD logical coordinates 1920x1080. Screens are real renders, not mockups.
After QA the game was stopped and relaunched normally, helper live, current_run_errors empty.

PDF: output/pdf/SWITCHY_EXPRESS_HUMAN_BLUEPRINT_20260911_REVIEW.pdf, 51 pages.
SHA-256: 79c5c9d300acdf0b4113ef2937b8e71ea663d95a2d339e08a8c4e3b30539f2b1.
All 51 pages rendered with Poppler and inspected in nine six-page contact sheets; final
caption-only page 1 correction rendered and inspected separately. No clipped tables/text found.
Source/map/image hashes: evidence/design/blueprint-20260911/publication.json.
Document render reviewed, not complete art readiness or final user approval.

Anomalies retained: one invalid inline QA eval required a project-only restart; reusable
tab-indented fixture replaced it. One concurrently run headless process exited -1073741819
without a test summary; serial logged rerun passed. Root cause remains unconfirmed; not a test PASS.
No shader, provider or shared installation changes were used to conceal this observation.

Pending: genuine-alpha red/yellow/disposal stations and cargo; new rail master port/rotation
validation; final pixel approval and full replacement runtime. Free local background-removal
permission requested, not inferred. No full-product, user-experience or release PASS.
