# Android Device Smoke Canonical Freshness Repair Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 활성 프로젝트 진입점·문서 Registry·프로젝트 Skill을 finite 제품 정본과 Android Device Smoke Gate에 맞추고, 동일 APK 해시를 강제하는 실기기 실행 Runbook과 fail-closed 증거 Template을 제공한다.

**Architecture:** 제품 코드나 APK를 수정하지 않고 Markdown·JSON·Python 계약 계층만 변경한다. 먼저 focused Python contract를 RED로 고정한 뒤 Runbook, 허브 정본, 문서 Registry, Skill routing을 순서대로 복구하고 `PROJECT_BASE_ADAPTER.json`의 project registry hash를 재계산한다. 마지막으로 전체 Project Contract·Godot 회귀·참조 최신성·제품 파일 불변성을 검증한다.

**Tech Stack:** Markdown, JSON, Python 3.12 `unittest`, GitHub Actions, Godot 4.7.1 headless tests.

## Global Constraints

- Implementation baseline: `b2ecc7220f4cad546814bcce43e998a45fff5281`.
- Product authority: `GMB-002 · SX-DEC-027~036`.
- Execution approval: `EV-USER-023` on `2026-08-05T23:23:00+09:00`.
- Current audit/evidence: `SX-AUD-019 · EV-FP-APK-001`.
- Canonical export source: `536911449018a3caf3511bc64e7bf1a66edf2016`.
- Validation APK SHA-256: `eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea`.
- Validation package: `com.alsdmlals4.switchyexpress.validation`.
- Android Device Smoke, Five-person Comprehension, and Production Cutover remain `NOT_RUN / BLOCKED` until actual evidence exists.
- Do not change `project.godot`, `game/**`, `.github/workflows/android-validation-apk.yml`, APK bytes, gameplay rules, saves, assets, or Google Sheet contents.
- Preserve VS03/fuel/BOOST/capacity-eight documents as historical evidence; remove only active authority and routing.
- Do not assign `SX-AUD-020` or claim Android PASS before a complete physical-device run is reviewed.
- Correct Sheet is `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`; wrong `19Ff...` Sheet remains untouched.
- Every implementation task follows RED → GREEN → full relevant regression → commit.

---

## File Structure

**Create**

- `tests/python/test_android_smoke_canonical_freshness_contract.py` — focused contract for active canon, routing, runbook, evidence, and adapter hash.
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md` — executable physical-device matrix and Gate rules.
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md` — blank, privacy-safe, fail-closed result record.
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_READINESS_CLOSURE.md` — implementation-only closure; explicitly not Android PASS.

**Modify**

- `.github/workflows/project-contract.yml` — run the focused contract on every PR/push.
- `기획서/00_프로젝트_허브/START_HERE.md` — current product and Gate entrypoint.
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md` — current same-APK device work.
- `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md` — finite Gate chain and manual blockers.
- `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md` — current responsibility routes and historical labels.
- `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json` — current/historical status correction and new runbook routes.
- `skills/switchy-express-design/SKILL.md` — finite product authority and validation routing.
- `skills/SKILL_REGISTRY.json` — finite triggers/outputs.
- `skills/PROJECT_BASE_ADAPTER.json` — recomputed project registry SHA-256 only.
- `기획서/00_프로젝트_허브/CHANGELOG.md` — readiness repair entry without Android PASS.

---

### Task 1: Add the focused canonical-freshness RED contract

**Files:**
- Create: `tests/python/test_android_smoke_canonical_freshness_contract.py`
- Modify: `.github/workflows/project-contract.yml`

**Interfaces:**
- Consumes: current repository files at the implementation branch head.
- Produces: a standalone Python command that fails on stale active authority and passes only after Tasks 2–5.

- [ ] **Step 1: Create the failing test**

Create the file with this implementation:

```python
from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CANONICAL_APK_SHA256 = (
    "eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea"
)


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def section(text: str, heading: str, next_heading: str) -> str:
    return text.split(heading, 1)[1].split(next_heading, 1)[0]


class TestAndroidSmokeCanonicalFreshness(unittest.TestCase):
    def test_active_hub_points_to_android_smoke(self) -> None:
        start = read("기획서/00_프로젝트_허브/START_HERE.md")
        active = read("기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md")
        gates = read("기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md")
        for text in (start, active, gates):
            self.assertIn("CANONICAL MAIN APK EXPORT", text)
            self.assertIn("ANDROID DEVICE SMOKE", text)
            self.assertIn("FIVE-PERSON COMPREHENSION", text)
            self.assertIn("PRODUCTION CUTOVER", text)
        self.assertNotIn("FINITE_PUZZLE_DEFINITION_OF_READY", start)
        self.assertNotIn("current_authorized_package: VS03-03", active)
        self.assertNotIn("current authority is VS03-03 only", gates)
        self.assertNotIn("VS03-03 READY_FOR_BUILD", gates)

    def test_documentation_routes_have_one_current_device_authority(self) -> None:
        registry = json.loads(
            read("기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json")
        )
        by_id = {item["id"]: item for item in registry["documents"]}
        self.assertEqual(
            "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md",
            by_id["SX-ANDROID-SMOKE-RUNBOOK"]["source"],
        )
        self.assertEqual("CURRENT", by_id["SX-ANDROID-SMOKE-RUNBOOK"]["status"])
        self.assertEqual(
            "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md",
            by_id["SX-ANDROID-SMOKE-EVIDENCE-TEMPLATE"]["source"],
        )
        for legacy_id in (
            "SX-CURRENT-VS-PLAN",
            "SX-FIRST-SESSION-ONBOARDING",
            "SX-FIRST-SESSION-ONBOARDING-PLAN",
        ):
            self.assertIn(by_id[legacy_id]["status"], {"HISTORICAL", "SUPERSEDED"})
        doc_map = read("기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md")
        self.assertIn("ANDROID_DEVICE_SMOKE_RUNBOOK.md", doc_map)
        self.assertIn("ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md", doc_map)

    def test_project_skill_current_authority_is_finite(self) -> None:
        skill = read("skills/switchy-express-design/SKILL.md")
        current = section(
            skill,
            "## Current Product Authority",
            "## Legacy Implementation Boundary",
        )
        for token in (
            "unlimited LIFO",
            "persistent branch",
            "finite-time completion",
            "ANDROID DEVICE SMOKE",
        ):
            self.assertIn(token, current)
        for stale in (
            "fuel zero",
            "player BOOST",
            "capacity-eight",
            "cargo slowdown",
            "VS03-03",
        ):
            self.assertNotIn(stale, current)
        self.assertIn("LEGACY_IMPLEMENTATION", skill)

    def test_runbook_and_template_are_same_hash_and_fail_closed(self) -> None:
        runbook = read("기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md")
        template = read(
            "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md"
        )
        for text in (runbook, template):
            self.assertIn(CANONICAL_APK_SHA256, text)
            self.assertIn("com.alsdmlals4.switchyexpress.validation", text)
        for index in range(1, 21):
            self.assertIn(f"AND-{index:02d}", runbook)
        for status in ("PASS", "FAIL", "BLOCKED", "NOT_RUN"):
            self.assertIn(status, runbook)
        for field in (
            "device_alias:",
            "device_model:",
            "android_version:",
            "resolution_density:",
            "recording_references:",
            "screenshot_references:",
            "crash_anr_log_reference:",
            "overall_gate: NOT_RUN",
        ):
            self.assertIn(field, template)
        self.assertNotIn("overall_gate: PASS", template)

    def test_project_registry_hash_is_propagated(self) -> None:
        adapter = json.loads(read("skills/PROJECT_BASE_ADAPTER.json"))
        actual = hashlib.sha256((ROOT / "skills/SKILL_REGISTRY.json").read_bytes()).hexdigest()
        self.assertEqual(actual, adapter["skill_registry"]["project"]["sha256"])


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Wire the focused test into Project Contract**

Insert after `Validate Base v9.4 AI operations adoption`:

```yaml
      - name: Validate Android smoke canonical freshness
        run: python tests/python/test_android_smoke_canonical_freshness_contract.py -v
```

- [ ] **Step 3: Run the focused test and verify RED**

Run:

```bash
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
```

Expected: FAIL because the Runbook/Template do not exist and active files still expose finite-DoR/VS03 authority. Existing unrelated tests must not be edited to manufacture RED.

- [ ] **Step 4: Run unaffected contracts**

```bash
python tools/validate_project_contract.py
python -m unittest tests.test_base_v94_ai_operations_adoption -v
python tests/python/test_platform_release_asset_rights_contract.py -v
```

Expected: PASS. The only intended RED is the new focused test.

- [ ] **Step 5: Commit RED**

```bash
git add tests/python/test_android_smoke_canonical_freshness_contract.py .github/workflows/project-contract.yml
git commit -m "test: define Android smoke canonical freshness contract"
```

---

### Task 2: Add the physical-device Runbook and fail-closed evidence Template

**Files:**
- Create: `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- Create: `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`

**Interfaces:**
- Consumes: canonical APK SHA/package and existing AND-01~20 acceptance semantics.
- Produces: a user-executable physical-device protocol and a blank result record that cannot be mistaken for PASS.

- [ ] **Step 1: Create the Runbook header and preflight contract**

Use this exact authority block:

```markdown
# Android Device Smoke Runbook

```yaml
runbook_state: READY_FOR_EXECUTION
execution_state: NOT_RUN
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
orientation: landscape
required_device: PHYSICAL_ANDROID_DEVICE
five_person_comprehension: BLOCKED_BY_ANDROID
production_cutover: BLOCKED
```
```

Preflight must require full APK hash comparison, package identity, device alias/model/Android version/resolution/density, landscape, touch input, notification/account redaction, and reject emulator-only evidence.

- [ ] **Step 2: Add the complete AND-01~20 matrix**

Use these IDs and success meanings:

```text
AND-01 install
AND-02 first_boot
AND-03 cold_reboot
AND-04 selector_proof
AND-05 selector_stack_8
AND-06 selector_stack_16
AND-07 selector_stack_32
AND-08 selector_back
AND-09 build_place_rotate_replace_remove_clear
AND-10 preflight_feedback
AND-11 build_run_result_retry_edit
AND-12 load_hold
AND-13 auto_load_toggle
AND-14 branch_direct_tap
AND-15 occupied_switch_lock
AND-16 pause_resume_movement_and_unload
AND-17 same_layout_fresh_runtime_retry
AND-18 top_readability_8_16_32
AND-19 landscape_safe_area_touch_targets
AND-20 stability_repeat_crash_anr_frame
```

Every row must have columns `ID | Procedure | PASS criterion | Status | Evidence/Observation`, with initial `NOT_RUN` status.

- [ ] **Step 3: Add fail-closed Gate rules**

Include exactly:

```text
PASS: AND-01~20 all PASS on one physical Android device with the canonical full APK SHA-256 and linked evidence.
FAIL: at least one executable required item fails.
BLOCKED: hash/package/device/evidence prerequisites prevent a valid run.
NOT_RUN: execution is possible but one or more required items were not performed.
```

Also state that a new APK invalidates device/human inheritance, Android PASS does not imply HUMAN or cutover PASS, and Sheet sync is forbidden before reviewed evidence closure.

- [ ] **Step 4: Create the evidence Template**

Use this exact initial record:

```markdown
# Android Device Smoke Evidence Template

> Template only. This file is not execution evidence and must remain `NOT_RUN` until completed from a physical-device session.

```yaml
record_state: TEMPLATE_NOT_EXECUTED
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
device_alias:
device_model:
android_version:
resolution_density:
orientation: landscape
input_method: touch
executed_at:
tester_alias:
item_results:
  AND-01: NOT_RUN
  AND-02: NOT_RUN
  AND-03: NOT_RUN
  AND-04: NOT_RUN
  AND-05: NOT_RUN
  AND-06: NOT_RUN
  AND-07: NOT_RUN
  AND-08: NOT_RUN
  AND-09: NOT_RUN
  AND-10: NOT_RUN
  AND-11: NOT_RUN
  AND-12: NOT_RUN
  AND-13: NOT_RUN
  AND-14: NOT_RUN
  AND-15: NOT_RUN
  AND-16: NOT_RUN
  AND-17: NOT_RUN
  AND-18: NOT_RUN
  AND-19: NOT_RUN
  AND-20: NOT_RUN
recording_references:
screenshot_references:
crash_anr_log_reference:
observations:
overall_gate: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
```
```

Add a privacy checklist forbidding names, phone numbers, notifications, account identifiers, device serial/IMEI, and unrelated screen content.

- [ ] **Step 5: Run the focused test**

```bash
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
```

Expected: runbook/template assertions PASS; active hub/routing assertions remain RED.

- [ ] **Step 6: Commit**

```bash
git add 기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md 기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md
git commit -m "docs: add Android device smoke runbook"
```

---

### Task 3: Repair the active project hub and Gate chain

**Files:**
- Modify: `기획서/00_프로젝트_허브/START_HERE.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`

**Interfaces:**
- Consumes: current decisions, SX-AUD-019, and the new Runbook.
- Produces: one consistent current status and next action for every cold start.

- [ ] **Step 1: Replace the START_HERE status table**

The table must contain:

```markdown
| 현재 결정 | GMB-002 · SX-DEC-027~036 |
| 현재 감사 | SX-AUD-019 · EV-FP-APK-001 |
| 자동 코어 | PASS |
| 검증 준비 | PASS |
| Canonical APK Export | PASS |
| 현재 Gate | ANDROID DEVICE SMOKE · NOT_RUN |
| 다음 Gate | FIVE-PERSON COMPREHENSION · BLOCKED_BY_ANDROID |
| 기본 진입점 | LEGACY |
| Production Cutover | BLOCKED |
```

The first-read order must route to finite baseline, current decisions, SX-AUD-019, Android Runbook, Vertical Slice contract, and roadmap. Remove finite DoR as the current next Gate.

- [ ] **Step 2: Replace ACTIVE_CONTEXT current status and next work**

Use this authority block:

```yaml
project: Switchy Express: Cargo Puzzle
product_authority: GMB-002 · SX-DEC-027~036
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
automated_core: PASS
validation_preparation: PASS
canonical_main_apk_export: PASS
android_device_smoke: NOT_RUN · CURRENT
five_person_comprehension: NOT_RUN · BLOCKED_BY_ANDROID
default_entrypoint: LEGACY_RUNTIME_DEFAULT
production_cutover: BLOCKED
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
```

Current work must be `verify hash → execute AND-01~20 → evidence review`; mark old VS03 package order `HISTORICAL_REPLACED`, not current.

- [ ] **Step 3: Rewrite DEVELOPMENT_GATES around the current chain**

Preserve concise historical implementation evidence, but the active chain must be:

```text
G0 PROJECT_IDENTIFIED: PASS
G1 FINITE_PRODUCT_AUTHORITY: PASS
G2 AUTOMATED_CORE: PASS
G3 VALIDATION_PREPARATION: PASS
G4 CANONICAL_APK_EXPORT: PASS
G5 ANDROID_DEVICE_SMOKE: NOT_RUN · CURRENT
G6 FIVE_PERSON_COMPREHENSION: NOT_RUN · BLOCKED_BY_G5
G7 PRODUCTION_CUTOVER_REVIEW: BLOCKED_BY_G5_G6
```

Include the full canonical APK hash and state that target100, online UGC, final art, platform submission, and release compliance are separate later Gates.

- [ ] **Step 4: Run the focused test**

```bash
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
```

Expected: hub/Gate assertions PASS; Registry/Skill assertions remain RED.

- [ ] **Step 5: Commit**

```bash
git add 기획서/00_프로젝트_허브/START_HERE.md 기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md 기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md
git commit -m "docs: advance project hub to Android smoke"
```

---

### Task 4: Repair documentation responsibility routes

**Files:**
- Modify: `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md`
- Modify: `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`

**Interfaces:**
- Consumes: Runbook/Template paths and current finite authority.
- Produces: exactly one current source per current question; old VS03 sources remain historical.

- [ ] **Step 1: Update DOCUMENTATION_MAP.md**

Add current rows:

```markdown
| Android 실기기 Smoke를 어떻게 실행하는가 | `../../50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md` |
| Android 실기기 결과는 어디에 기록하는가 | `../../50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md` |
| 정식 APK export 근거는 무엇인가 | `../../50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md` |
```

Label old VS03 current-plan, compact capacity-eight, BOOST onboarding, and Codex VS03 routes `HISTORICAL · current authority 아님`. Update the core-systems question to finite track/cargo/LIFO/time rules rather than fuel/BOOST.

- [ ] **Step 2: Update DESIGN_DOCUMENT_REGISTRY.json**

Add:

```json
{"id":"SX-ANDROID-SMOKE-RUNBOOK","question":"Android 실기기 Smoke를 어떻게 실행하는가","source":"기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md","format":"markdown","publication_policy":"source_only","status":"CURRENT"},
{"id":"SX-ANDROID-SMOKE-EVIDENCE-TEMPLATE","question":"Android 실기기 Smoke 결과를 어떤 형식으로 기록하는가","source":"기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md","format":"markdown","publication_policy":"source_only","status":"CURRENT"},
{"id":"SX-APK-AUDIT-019","question":"정식 Android Validation APK export 증거는 무엇인가","source":"기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md","format":"markdown","publication_policy":"source_only","status":"CURRENT"}
```

Change these IDs from `CURRENT` to `HISTORICAL` or `SUPERSEDED`:

```text
SX-CURRENT-VS-PLAN
SX-COMPACT-WAGON-TOKENS
SX-FIRST-SESSION-ONBOARDING
SX-FIRST-SESSION-ONBOARDING-PLAN
SX-TOTAL-PLANNING-AUDIT
```

Keep source paths intact; do not delete historical files.

- [ ] **Step 3: Parse JSON and run focused test**

```bash
python -m json.tool 기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json >/dev/null
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
```

Expected: documentation route assertions PASS; Skill/adapter assertions remain RED.

- [ ] **Step 4: Commit**

```bash
git add 기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md 기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json
git commit -m "docs: route current Android validation authority"
```

---

### Task 5: Repair project Skill routing and propagate the Registry hash

**Files:**
- Modify: `skills/switchy-express-design/SKILL.md`
- Modify: `skills/SKILL_REGISTRY.json`
- Modify: `skills/PROJECT_BASE_ADAPTER.json`

**Interfaces:**
- Consumes: finite product authority and Android validation Gate.
- Produces: automatic routing that cannot reactivate superseded endless/VS03 authority, plus a matching adapter SHA.

- [ ] **Step 1: Replace the Skill read order and current authority**

The active read order must start with:

```text
START_HERE.md
CURRENT_CONFIRMED_DECISIONS.md
FINITE_DELIVERY_PUZZLE_BASELINE.md
ACTIVE_CONTEXT.md
ANDROID_DEVICE_SMOKE_RUNBOOK.md
SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md
VERTICAL_SLICE_CONTRACT.md
actual finite code and tests
```

Create these exact section headings:

```markdown
## Current Product Authority
## Legacy Implementation Boundary
```

`Current Product Authority` must contain:

```text
track construction
→ cargo encounter order
→ manual/automatic loading
→ unlimited LIFO
→ route and persistent branch execution
→ TOP contiguous-group unloading
→ finite-time completion
→ time/cost/score redesign
```

It must also route `ANDROID DEVICE SMOKE`, canonical APK hash checks, five-person comprehension, finite UI/readability, and same-layout retry validation.

`Legacy Implementation Boundary` must classify endless survival, fuel/fuel-zero, player BOOST, capacity eight, cargo slowdown, pickup respawn, switch auto-reset, and old VS03 order as `LEGACY_IMPLEMENTATION · HISTORICAL_EVIDENCE`.

- [ ] **Step 2: Update the project Registry entry**

Use these positive triggers:

```json
[
  "finite delivery puzzle",
  "track construction",
  "cargo encounter order",
  "manual load",
  "auto-load",
  "unlimited LIFO",
  "persistent branch",
  "TOP unloading",
  "finite timer",
  "same-layout retry",
  "Android device smoke",
  "validation APK",
  "five-person comprehension",
  "visual readability",
  "canonical APK hash"
]
```

Use these outputs:

```json
[
  "finite product design or review",
  "Android device smoke runbook or evidence review",
  "five-person comprehension preparation or evidence review"
]
```

Do not remove Base routes or add a new broad Skill.

- [ ] **Step 3: Recompute and write the adapter hash**

Run:

```bash
python - <<'PY'
import hashlib
import json
from pathlib import Path
registry = Path('skills/SKILL_REGISTRY.json')
adapter_path = Path('skills/PROJECT_BASE_ADAPTER.json')
adapter = json.loads(adapter_path.read_text(encoding='utf-8'))
adapter['skill_registry']['project']['sha256'] = hashlib.sha256(registry.read_bytes()).hexdigest()
adapter_path.write_text(json.dumps(adapter, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
PY
```

Do not alter the Base registry hash, Base release pin, protected paths, Sheet configuration, or routing IDs.

- [ ] **Step 4: Run focused and adapter tests**

```bash
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
python -m unittest tests.test_base_v94_ai_operations_adoption -v
```

Expected: both PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/switchy-express-design/SKILL.md skills/SKILL_REGISTRY.json skills/PROJECT_BASE_ADAPTER.json
git commit -m "docs: align Switchy skill with finite validation"
```

---

### Task 6: Close readiness, run full regression, and publish the implementation PR

**Files:**
- Create: `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_READINESS_CLOSURE.md`
- Modify: `기획서/00_프로젝트_허브/CHANGELOG.md`
- Review: all changed files from Tasks 1–5

**Interfaces:**
- Consumes: all GREEN contracts and exact diff.
- Produces: `READY_FOR_DEVICE_EXECUTION`, not Android PASS, and a reviewable implementation PR.

- [ ] **Step 1: Create the readiness closure**

Use this status block:

```yaml
closure: ANDROID_DEVICE_SMOKE_CANONICAL_FRESHNESS_REPAIR
approval: EV-USER-023
implementation_baseline: b2ecc7220f4cad546814bcce43e998a45fff5281
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
canonical_apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
canonical_freshness: PASS
runbook: READY_FOR_EXECUTION
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
google_sheet_change: NONE
```

Document the eight active consumers repaired, historical files preserved, RED/GREEN evidence, product files unchanged, and the exact next human action. Do not use `SX-AUD-020` and do not mark device evidence PASS.

- [ ] **Step 2: Add the CHANGELOG entry**

Record:

```text
- Approved EV-USER-023 canonical-freshness repair.
- Repaired active finite/Android Smoke authority and project Skill routing.
- Added physical-device Runbook and NOT_RUN evidence Template.
- Preserved APK bytes, product entrypoint, gameplay, historical VS03 evidence, and Sheet state.
```

- [ ] **Step 3: Run all static contracts**

```bash
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
python tools/validate_project_contract.py
python -m unittest tests.test_base_v94_ai_operations_adoption -v
python tests/python/test_platform_release_asset_rights_contract.py -v
python - <<'PY'
import json
from pathlib import Path
for path in Path('.').rglob('*.json'):
    if '.git' not in path.parts:
        json.loads(path.read_text(encoding='utf-8'))
print('JSON parse: PASS')
PY
git diff --check
```

Expected: all PASS.

- [ ] **Step 4: Run full Godot regression**

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless --path . --script res://tests/run_tests.gd
```

Expected: `65 cases · 10,792 assertions · 0 failures`, unless latest main legitimately added tests; in that case require zero failures and record the exact fresh count.

- [ ] **Step 5: Prove protected product files are unchanged**

```bash
git diff --name-only origin/main...HEAD -- \
  project.godot game .github/workflows/android-validation-apk.yml
```

Expected: no output.

Also compare the canonical strings:

```bash
grep -F 'run/main_scene="res://game/main/main.tscn"' project.godot
grep -F 'run/main_scene.validation_harness="res://tools/validation/finite/finite_validation_launcher.tscn"' project.godot
```

Expected: both present.

- [ ] **Step 6: Run the adversarial freshness scan**

Review only active authority sections and verify:

```text
- no current finite-DoR next Gate
- no current VS03-03 package authority
- no current fuel/BOOST/capacity-eight product invariant
- no duplicate current Android Smoke owner
- historical documents remain present and labeled historical
- evidence Template remains NOT_RUN
- no Android/HUMAN/cutover PASS claim
- no Google Sheet write
```

Any valid finding returns to the owning task; do not patch it only in the closure document.

- [ ] **Step 7: Commit closure**

```bash
git add 기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_READINESS_CLOSURE.md 기획서/00_프로젝트_허브/CHANGELOG.md
git commit -m "docs: close Android smoke readiness repair"
```

- [ ] **Step 8: Push and open a Draft implementation PR**

The PR body must include:

```text
Approval: EV-USER-023
Current Gate: ANDROID DEVICE SMOKE · NOT_RUN
Canonical APK SHA-256: full 64-character hash
RED/GREEN evidence
Project Contract result
Godot result and exact counts
protected product diff: empty
historical evidence preserved
Sheet change: none
next action: physical-device AND-01~20
```

Keep the PR Draft until exact-head checks are successful, unresolved threads are zero, and adversarial recheck has no P0/P1 finding.

---

## Self-Review Results

- Spec coverage: active consumers, adapter hash propagation, Runbook, evidence, privacy, fail-closed rules, historical preservation, PR #74 merged baseline, protected runtime, and later closure are each assigned to a task.
- Placeholder scan: no `TBD`, `TODO`, “implement later”, or unspecified test instruction remains.
- Type/path consistency: Runbook, Template, Skill headings, Registry IDs, hash field, test path, workflow command, and closure path are consistent across tasks.
- Scope split: actual physical-device execution and post-run GitHub/Sheet closure remain a separate future package because this plan cannot create physical-device evidence.
