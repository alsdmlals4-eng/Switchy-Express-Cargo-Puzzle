# SX-AUD-045 — v4.5 r2 Work-Instruction GitHub Canon Replacement

Date: `2026-08-11 KST`
Status: `IN_PROGRESS · PRE_PR · DOCS/CANON_ONLY · NO_BUILD`

## Audit Question

사용자가 제공한 `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`를 현재 프로젝트의 GitHub 작업지시문 정본으로 교체·등록하면서, 원문 바이트·현재 Phase A Gate·제품 Decision·Base pin·physical/human evidence ceiling을 왜곡 없이 보존할 수 있는가?

## Audit-start authority

```yaml
project_repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
project_main_after_noop_recovery: e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6
project_open_prs_at_work_start: 0
base_main_observed: 315c66eea9614c284b9c11c4d522141065dfa4b0
base_open_prs_at_work_start: 0
project_base_pin: v9.4.3
configured_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
product_decision_span: SX-DEC-027~055
phase_a_state: READY_FOR_USER_PLANNING_COMPLETE_GATE
user_planning_complete_gate: NOT_GRANTED
phase_b: NOT_RUN
build_authority: BLOCKED
sx_dec_055_implementation: NOT_STARTED
runtime_integrated: false
physical_device_human: NOT_RUN
```

## User approval scope

```text
USER_APPROVED_RECOMMENDED_CONTINUATION_AND_GITHUB_CANON_REPLACEMENT_2026-08-11
```

허용:

- r2 원문을 GitHub current work-instruction canon으로 등록;
- 필요한 current routing/freshness 문서 교정;
- Sheet same-audit 동기화;
- docs-only PR 생성·exact-head 검증·승인 범위 내 자동 병합·post-merge readback.

허용하지 않음:

- 사용자 `기획 완료` Gate 자동 승인;
- Phase B 자동 실행;
- PowerShell/Codex/Godot BUILD;
- 새 제품 Decision/gameplay/domain rule;
- Base repin;
- physical/device/human PASS 승격.

## Source payload identity

```text
source: attached PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md
revision: 2026-08-11-r2
encoding: UTF-8
bytes: 77734
LF count: 2849
SHA-256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
Git blob SHA-1: de7c6f818a4c96d2a02edea5eaff33bb1c39e8da
```

No tracked `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION*` predecessor was found in the repository at audit start. After merge, earlier chat/upload v4.4/initial-v4.5 copies are historical external evidence; r2 is the GitHub current canon.

## Canon representation

Selected: `CONTENT_ADDRESSED_MULTIPART_VERBATIM_CANON`.

Root locator:

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`

The manifest registers exact ordered segments under `docs/work-instructions/v4.5_r2/`. Binary concatenation with no inserted separators reconstructs the source payload byte-for-byte.

Pre-PR verified segment identities:

```text
part01  13494 bytes · git 140a1bf3087e4136f22a289d83980e33c232822b
part02  13492 bytes · git 4c5697286fc86a7bb82e158c1ae2f04f6a4d2155
part03  13486 bytes · git 2fbcc2742ed16a00ec516d2a113849137402077a
part04  13463 bytes · git 038c570807473ce4514e4827b1b3d326fa347cde
part04-eof-lf 1 byte · git 8b137891791fe96927ad78e64b0aad7bded08bdc
part05  13485 bytes · git e080c88d6d12c18a89de1a1251eaf8eaa2ba624d
part06  10313 bytes · git 642add5f573c90f5911aec0b021c10d486f3d5fb
concat 77734 bytes / 2849 LF / SHA-256 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
```

## Transport findings

### F153 · VERIFIED/FIXED — unsafe single-call payload transport rejected

The available GitHub connector does not expose a local-file streaming parameter for contents writes. An attempted large manual base64 transport produced an **unlinked** blob whose SHA did not equal the expected full-source Git blob. It was rejected before any branch/tree reference and has no canonical effect.

Disposition: use smaller independently addressable segments and verify every segment identity before PR.

### F154 · VERIFIED/FIXED — part-4 EOF LF detected before PR

The first part-4 branch file matched the source except for the final LF. Its observed Git blob `038c5708...` exactly equals the locally calculated source-part-with-final-LF-removed identity. Instead of rewriting a verified 13KB segment, a separate 1-byte LF segment (`8b137891...`) is registered in the manifest. The final concatenation matches the original full SHA.

### F155 · MUST_FIX — START_HERE stale direct resume route

At audit start `START_HERE.md` still advertised `HANDOFF_CLOSED / WAIT_FOR_EXPLICIT_RESUME` and `resume → Task 1 / Step 1.1 RED`, which conflicts with the already-merged Phase A READY state and r2 absolute sequence.

Disposition: reconcile START_HERE to `READY_FOR_USER_PLANNING_COMPLETE_GATE → explicit "기획 완료" → Phase B → BUILD only after PASS`.

### F156 · FIXED — no current GitHub instruction-canon discovery

AGENTS had no r2 work-instruction entry. Disposition: add the root manifest as the current project execution Thin Adapter while keeping product owners separate.

## Accidental main noop recovery

During tool discovery, a `__noop__` file was accidentally created directly on main:

```text
create: 1e439d049cd069ce23c104dda89921dd1c1f878c
```

Work stopped immediately. The exact file was fetched and deleted without reset/force/history rewrite:

```text
recovery/current-main-at-branch-start: e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6
```

Fresh compare from pre-incident `78b8f09a930fdef040b2017fceb427864a15f51b` to recovery `e2e075ff...` reports `files: []`.

Disposition: `ACCIDENTAL_NOOP_CREATE_DELETE · NET_TREE_DELTA_ZERO · HISTORY_PRESERVED`.

## Protected state

```text
SX-DEC-027~055: unchanged
SX-DEC-055 implementation: NOT_STARTED
runtime_integrated: false
Phase A: READY_FOR_USER_PLANNING_COMPLETE_GATE
user "기획 완료": NOT_GRANTED
Phase B: NOT_RUN
BUILD: BLOCKED
acceptance build: UNASSIGNED
Windows physical: NOT_RUN
Android device: NOT_RUN
connected physical editor: NOT_RUN
human comprehension: NOT_RUN
production cutover: BLOCKED_DEFERRED
Base pin: v9.4.3
```

## PR / exact-head evidence

```yaml
planning_pr: NOT_CREATED
exact_head: UNASSIGNED
changed_files: NOT_RUN
project_contract: NOT_RUN
GUT: NOT_RUN
Godot: NOT_RUN
Thin: NOT_RUN
review_threads: NOT_RUN
reviews: NOT_RUN
mergeability: NOT_RUN
merge: NOT_RUN
post_merge_main: NOT_RUN
```

No PASS may be promoted above until fresh exact-head evidence exists.

## Pre-PR verdict

`IN_PROGRESS · PRODUCT_CONFLICT_NONE · DOCS/CANON_ONLY · R2_PAYLOAD_RECONSTRUCTION_VERIFIED · START_HERE/ROUTING_REPAIR_IN_PROGRESS · NO_BUILD`.
