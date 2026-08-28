# Notion current-workspace migration · 2026-08-28

Status: `COMPLETE_FOR_CURRENT_STRUCTURE · GITHUB_ONLY_ACTIVE_WORKSPACE`

## Purpose and scope

The user retired Notion as an active workspace and then required that its **current** Switchy Express structure and work products not be lost. This migration preserves current, project-specific information in GitHub-owned documents. It does not delete Notion or copy rolling historical logs, superseded candidate records, expired preview derivatives, or the foreign-project Direction page.

GitHub is the sole active owner after this migration. Notion can be re-read only for a future explicit audit or recovery request.

## Source read receipt

The following sources were fetched on 2026-08-28 KST for this one-time migration. Their source URLs/IDs are retained for audit provenance only.

| Former Notion structure | Source ID | Disposition |
| --- | --- | --- |
| Switchy Express · Home | `3c41b237-eb1c-8103-9537-ede6dfc5f07e` | Current summary structure migrated; dated rolling log excluded. |
| 01 · Direction · Switchy Express · CURRENT | `3c91b237-eb1c-8197-bf13-debb96d444c8` | Current promise, rules, visual lock and evidence boundary migrated. |
| 02 · Puzzle Systems · First Session | `3c51b237-eb1c-81fc-9c39-eca6a5cbdc8e` | System and first-session structure migrated. |
| 03 · UI · 퍼즐 Flow Map | `3c01b237-eb1c-81a0-8bae-dee2470e0576` | Flow, responsiveness, and accessibility contract migrated. |
| 03 · Visual · UX · Assets | `3c51b237-eb1c-81fa-8d47-d043dae17e11` | Current visual grammar, runtime asset identities and provenance mapping migrated. |
| 04 · Production · Validation | `3c51b237-eb1c-8183-9ec4-ea913a27b697` | Current implementation/evidence boundary and open validation gates migrated. |
| ASSET LIBRARY · Master | `collection://4c49f406-67a2-4524-97b9-f8f1aa730f16` | Four Switchy benchmark records read; their decisions are preserved in the GDD benchmark table. No live database workflow is retained. |

The former Home/Direction/Visual/Production pages claimed `main@f316ee1…` and an image-generation pre-approval gate. Fresh GitHub was later (`origin/main@c20a0b5…`) and the user superseded that gate: candidate generation and machine review may proceed before the user chooses only promotion/revise/reject. Those stale source claims were **not** copied into current canon.

## Current structure replacement

```text
GitHub repository
├── README.md                                  # entry summary and current authority
├── 기획서/00_프로젝트_허브/
│   ├── START_HERE.md                           # fast current-entry map
│   ├── CURRENT_CONFIRMED_DECISIONS.md          # approved decision registry
│   ├── ACTIVE_CONTEXT.md                       # accepted frontier / evidence ceiling
│   ├── FINITE_DELIVERY_PUZZLE_BASELINE.md      # product meaning and protected scope
│   ├── ROADMAP.md                              # ordered work
│   └── DEVELOPMENT_GATES.md                    # production and validation gates
├── 기획서/40_표현/
│   ├── VISUAL_DIRECTION.md                     # visual lock
│   └── PROJECT_CORE_SCENE_VISUAL_BOARD.md      # screen/scene grammar
├── docs/decisions/                             # decision-level contracts
├── docs/design/PROJECT_AI_PRODUCTION_SPEC.md   # integrated Master GDD / AI spec
├── docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md  # asset identity, consumer, rights
└── docs/migrations/                            # this one-time migration ledger
```

## Content and destination readback

| Former structure / current material | GitHub destination | Readback outcome |
| --- | --- | --- |
| Home: product summary, next safe action, evidence ceiling | `README.md`, `START_HERE.md`, `ACTIVE_CONTEXT.md` | Present and GitHub-only. |
| Direction: player promise, finite rule set, protected exclusions | `FINITE_DELIVERY_PUZZLE_BASELINE.md`, `CURRENT_CONFIRMED_DECISIONS.md`, `PROJECT_AI_PRODUCTION_SPEC.md` | Present; historical score/economy/campaign claims removed from the current baseline. |
| Puzzle Systems: BUILD → RUN → delivery/result, T1–T6 → capstone | `FINITE_DELIVERY_PUZZLE_BASELINE.md`, `PROJECT_AI_PRODUCTION_SPEC.md` | Present, including T2 exact-cell/cardinal distinction. |
| Flow Map: title, briefing, BUILD/preflight, RUN/route, result recovery and viewport rules | `PROJECT_AI_PRODUCTION_SPEC.md` sections 11 and 17–19; `PROJECT_CORE_SCENE_VISUAL_BOARD.md` | Present; 960×540 through 2560×1080 and 48px target contract retained. |
| Visual: Board-first Cozy Neo-Arcade, Hybrid Miniature-Diorama extension, Keep/Avoid, reference/evidence limits | `VISUAL_DIRECTION.md`, `PROJECT_CORE_SCENE_VISUAL_BOARD.md`, `SX_DEC_061…`, `SX_DEC_062…`, `SX_DEC_063…`, Master GDD | Present. SX-VIS-063 candidate is explicitly review-only. |
| Runtime visual assets: terrain, T2 hero v02, title hero, success/failure art | existing tracked local files plus `art/product_assets/ed_hybrid_v1/manifest.json` and `ASSET_RIGHTS_AND_PROVENANCE_RECORD.md` | Exact asset checksums below match the former visual records. |
| Production: current package state, automated evidence, physical/device/human ceiling and PR #174 protection | `DEVELOPMENT_GATES.md`, `ROADMAP.md`, `ACTIVE_CONTEXT.md`, acceptance evidence | Present; no PASS inflation. |
| Four current benchmark cards (Railbound, Mini Metro, Train Valley 2, Rail Route) | `PROJECT_AI_PRODUCTION_SPEC.md` benchmark table | Preserved as ADAPT/REJECT decisions; database workflow retired. |

## Asset continuity check

The current production assets listed by the former Visual page already exist as Git-tracked local source. Their hashes were re-read during migration.

| Asset | GitHub path | SHA-256 |
| --- | --- | --- |
| BUILD terrain v01 | `art/product_assets/ed_hybrid_v1/board/board_terrain_playfield_v01.png` | `68c06fba0f351918f9b1a7ecee2925eb58088b54c04ea59fe98a6e5efe1f8c8b` |
| T2 lesson hero v02 | `art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v02.png` | `a270a91e9d7cbc218a654e94bb0fc13d94f256ea52985679260bca2a31c77753` |
| title hero v01 | `art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png` | `ce7fcd3ec380bc8b0840bcf28d56debd0d170bf8ca7681fee208cc8347f2d5dd` |
| success result v02 | `art/product_assets/ed_hybrid_v1/shells/shell_result_success_v02.png` | `2b92c89b91fa1b6e533e2ce0d10d2a9609ba745e81bbec5e9a0eb4745c5aa72a` |
| failure result v02 | `art/product_assets/ed_hybrid_v1/shells/shell_result_failure_v02.png` | `e1513ed08d1e8b175ad15ac9747c58f7f464222be97e4cb548ce53f10bf51c68` |

`SX-VIS-063-CANDIDATE-001` is deliberately excluded from this asset table: it is still outside the repository and not a project asset until the user’s final disposition.

## Explicit exclusions

| Excluded source material | Reason | Current handling |
| --- | --- | --- |
| dated Home/Visual/Production rolling logs and earlier candidates | historical; later current state supersedes them | Existing GitHub evidence/operations records remain audit history. |
| foreign `01 · Direction · Planning` page | confirmed different project | Untouched; recorded as `CONFLICT_FOREIGN_PROJECT`. |
| Notion preview derivatives and expiring attachment URLs | no stable source identity; no runtime consumer or newer direction supersedes them | No active asset is lost; current runtime assets are local and verified above. |
| old score, combo, economy, leaderboard, campaign, special-track and procedural-generation ideas | conflict with the approved current finite Slice | Removed from `FINITE_DELIVERY_PUZZLE_BASELINE.md`; historical records need not be migrated. |
| Notion databases / sync statuses / attachment readback as a workflow | user retired Notion | GitHub file, hash, provenance and remote readback are the active replacement. |

## Completion criteria

- [x] Current Notion hierarchy has a GitHub-only replacement map.
- [x] Current source content has a named GitHub owner or is explicitly excluded with a reason.
- [x] Existing runtime asset identity and checksum continuity were verified.
- [x] Former Notion-only candidate-generation gate was replaced by the user’s current promotion-only decision gate.
- [x] Historical and foreign-project material was not promoted into current canon.
- [x] No Notion write, deletion, archive, or sync was performed.

This record is the permanent migration receipt. Future work reads the listed GitHub owners, not the former Notion pages.
