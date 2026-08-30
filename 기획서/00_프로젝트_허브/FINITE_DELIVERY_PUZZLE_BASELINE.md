# Switchy Express 유한 배송 퍼즐 제품 기준선

상태: `CURRENT_CANON · GMB-002 · AMENDED_BY_SX-DEC-060 · RUNTIME_MERGED_MAIN_VERIFIED`

이 문서는 현재 출시 전 Vertical Slice의 제품 의미만 소유한다. 과거 점수·경제·랭킹·확장 캠페인·절차 생성·특수 선로·무한 생존 설계는 historical/provenance 문서에 남을 수 있으나 이 기준선의 현재 범위가 아니다.

## 1. 제품 한 문장

> 플레이어가 짧은 선로망으로 화물 조우 순서를 설계하고, Manual/Auto 적재로 unlimited LIFO TOP을 만든 뒤, 자동 운행 중 분기를 조작해 역의 상·하·좌·우 인접 서비스 셀에서 모든 화물을 배송하는 유한 퍼즐.

## 2. Player Promise와 핵심 재미

```text
선로를 설계한다
→ 화물을 만나는 순서가 정해진다
→ 적재할 것과 남길 것을 고른다
→ LIFO TOP이 다음 배송 가능 여부를 결정한다
→ 운행 중 분기 선택으로 계획을 실행한다
→ 성공 또는 사실 기반 실패 원인을 보고 같은 노선을 재시도하거나 편집한다
```

차별점은 **노선 설계가 곧 화물 스택 순서 설계**라는 점이다. 단순 최단거리, 전역 연결망, 반사신경 조작, 수송량 최적화는 현재 재미의 중심이 아니다.

## 3. 플레이 루프

### BUILD

- 직선·곡선·분기·교차를 실제 보드 셀에 자유 배치하고, 철거하면 비용은 전액 환급한다.
- 역은 off-track service object다. 역 footprint에는 플레이어 선로를 놓을 수 없다.
- start-reachable RUN component만 검사한다. 필수 화물과 각 역의 cardinal service cell 하나 이상이 reachable이어야 한다.
- 필수 목적과 무관한 disconnected rail island는 RUN을 막지 않는다.

### RUN

- 열차는 자동으로 이동한다. 운행 중 선로 편집은 할 수 없다.
- Cargo는 train이 화물과 **같은 cell**을 지날 때만 Manual/Auto로 적재된다.
- 기본은 Manual이며 Auto는 명시적 ON/OFF 선택이다. 적재하지 않은 화물은 지도에 남아 재방문할 수 있다.
- cargo stack은 용량 제한 없는 LIFO다. Stack HUD가 정확한 순서·수량·`TOP`을 소유하고, 월드 토큰은 짧고 세로적인 표시만 쓴다.
- 플레이어는 운행 중 분기를 직접 선택한다. 열차가 점유한 분기는 잠기고, 선택 상태는 바꿀 때까지 유지된다.

### DELIVERY / RESULT

- Station service는 `abs(train_x - station_x) + abs(train_y - station_y) == 1`일 때만 발생한다.
- 즉 상·우·하·좌 정확히 1칸만 유효하며, diagonal과 station footprint는 배송 접촉이 아니다.
- 서비스 셀 진입 시 station과 같은 cargo가 TOP에서 연속할 때만 contiguous matching TOP group을 하역한다.
- 모든 필수 화물을 배송하면 성공한다. 제한 시간 경과 또는 `ROUTE_END`는 실패다.
- Result는 runtime truth인 outcome, remaining map cargo, stack 상태만 설명한다. Retry는 같은 layout의 fresh runtime을 만들고, Edit은 BUILD로 돌아간다.

## 4. First Session

```text
T1 · Track Connection
→ T2 · Cargo exact-cell + Station cardinal-adjacent service
→ T3 · LIFO/TOP reverse planning
→ T4 · selective non-load + revisit
→ T5 · Auto ON safe / OFF decision
→ T6 · direct switch execution
→ VS_DEMO_01 capstone
→ Result / Retry / Edit
```

- 새 tutorial stage를 추가하지 않는다.
- T2의 핵심 문장은 다음과 같다.

```text
Cargo: 화물 칸을 직접 통과해 적재
Station: 역의 상·하·좌·우 1칸을 통과해 배송
Diagonal / station footprint: 배송 안 됨
```

- `ko / en / ja / zh-Hans`가 현재 locale 범위이며 `zh-Hant`는 deferred다.

## 5. 지원 시스템과 금지 범위

| 현재 지원 시스템 | 핵심 재미를 위한 역할 |
| --- | --- |
| preflight | 실행 불가능한 노선을 시작 전에 이해시키되, 해답을 제시하지 않는다. |
| Stack HUD | LIFO TOP과 다음 배송 판단을 읽게 한다. |
| route control overlay | live switch commitment과 occupied lock을 읽게 한다. |
| first-session director/copy | 새로운 규칙 하나씩만 노출하고 튜토리얼 전용 규칙을 만들지 않는다. |
| result recovery | 실패를 factual retry/edit 동기로 바꾼다. |

다음은 현재 Slice에서 금지 또는 별도 승인 대상이다.

```text
endless survival / fuel / recovery / player BOOST
cargo capacity 8 / cargo-count slowdown / pickup respawn / switch auto-reset
score / combo formula / currency / save economy / leaderboards
new progression, Yard Labs, Daily/Weekly generator, solver/optimal route reveal
arbitrary station radius, diagonal service, station-footprint service, per-station service shape
```

`SX-DEC-056A`, `SX-DEC-057`, `SX-DEC-058`은 planning-only 또는 implementation unauthorized이고, `SX-DEC-056B`은 authoritative score/combo runtime이 없어 blocked다.

## 6. Visual / asset boundary

- 현재 visual grammar는 `SX-DEC-061/062/063`: warm toy-scale miniature railway world + rectangular interaction geometry + dark navy/charcoal control deck다.
- SX-DEC-063은 rectangular grid와 input mapping을 바꾸지 않고, actual consumer 안에서만 controlled 2.5D miniature-diorama material/depth를 정렬한다.
- T2 `shell_lesson_hero_v02.png`와 Issue #227은 보호한다.
- production image는 exact Godot node/key/path consumer가 있을 때만 만든다. 후보는 생성·기계 검토할 수 있지만, Git-tracked project asset으로 promotion하거나 runtime에 연결하려면 사용자 최종 disposition과 별도 implementation contract가 필요하다.
- `SX-VIS-063-CANDIDATE-001` terrain review source는 사용자 승인 뒤 `art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png`로 승격되었고, v2 non-rail 9개 및 v04 rail 4개와 함께 실제 `ProductBoardRenderer` consumer에 연결됐다. 이 구현·자동 검증 사실은 Human/Player Experience evidence가 아니다.

## 7. 구현과 증거 상태

```yaml
sx_dec_060_runtime: MERGED_MAIN_VERIFIED · PR_188 · schema_v3/cardinal_service/reachable_preflight
sx_dec_060_automated_regression: PASS · 111_CASES_13461_ASSERTIONS · CI_7_GREEN
sx_dec_062_runtime_composition: MERGED_MAIN_VERIFIED · PR_237 · EXISTING_ASSET_ONLY
sx_dec_063: CORE_BOARD_V02_V04_MERGED_MAIN_VERIFIED · PR_255_MAIN_2CF7BB5 · PRODUCT_BOARD_RENDERER_V2_CONSUMERS_CONNECTED · REMOTE_RUNTIME_BYTE_CI_7_GREEN_PR_255_F00DE19
sx_dec_065_validation_policy: USER_APPROVED · MACHINE_PRIMARY_FINAL_USER_REVIEW
post_sx_dec_060_candidate: SX60-POC-ACCEPT-005 · PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · SX_DEC_063_CORE_BOARD_V04_AND_SX_DEC_064_ACTIVE_ROUTE_LIGHTING_INCLUDED
windows_physical_post_060: FINAL_USER_REVIEW_ONLY · NOT_RUN
audio_perceptual_post_060: FINAL_USER_REVIEW_ONLY · NOT_RUN
android_device_post_060: NOT_REQUIRED_FOR_MACHINE_PRIMARY_ACCEPTANCE · NOT_RUN
five_person_comprehension_post_060: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
player_experience_post_060: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
final_user_review: FINAL_USER_REVIEW · NOT_RUN · EXACT_CANDIDATE_REQUIRED
production_cutover: BLOCKED_DEFERRED
```

Automated tests, package integrity, asset hashes, or generated-image inspection never prove physical usability, audio perception, device compatibility, comprehension, or player enjoyment. Under `SX-DEC-065`, however, those machine owners are the primary acceptance route; `FIVE_PERSON_COMPREHENSION_NOT_REQUIRED` and `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED` leave final user inspection as a separately recorded `FINAL_USER_REVIEW`.

## 8. Current owner map

| Concern | GitHub current owner |
| --- | --- |
| decisions / current frontier | `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`, `ACTIVE_CONTEXT.md` |
| exact station/preflight rule | `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md` |
| first-session implementation | `game/first_session/**`, `game/demo/**`, first-session content owners |
| visual direction / scene grammar | `기획서/40_표현/VISUAL_DIRECTION.md`, `PROJECT_CORE_SCENE_VISUAL_BOARD.md`, `docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md` |
| asset provenance / rights | `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`, asset manifest |
| production evidence / remaining gates | `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`, `ROADMAP.md`, acceptance evidence |

## 9. Historical boundary

Historical Notion pages and older GitHub planning material are audit/provenance sources only after the 2026-08-28 GitHub-only workspace decision. The current-structure migration map is `docs/migrations/2026-08-28-notion-current-workspace-migration.md`.
