# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 연결된 철도망을 달리는 화물열차에서 필요한 화물을 선택 적재하고, 분기기를 미리 전환해 알맞은 스테이션을 방문하며, 마지막에 실은 화물부터 연속 하역해 연료와 점수를 이어가는 모바일 가로형 무한 생존 퍼즐입니다.

## 핵심 재미

> 앞으로 필요한 하역 순서를 역산해 화물을 골라 싣고, 목적 역까지의 경로를 미리 준비하며, 무게와 연료 압박을 감수해 큰 LIFO 하역 그룹을 성공시키는 계획형 생존 퍼즐.

```text
LIFO 적재 순서 계획
→ 노선 선행 결정
→ 큰 그룹을 위한 위험·생존 판단
→ BOOST·배송 속도의 전술적 시간 관리
→ 결과 학습·재도전
→ 기록·꾸미기·맵 발견·UGC
```

## 현재 상태

- 단계: `VERTICAL_SLICE_IN_PROGRESS · VS03_01_HEADLESS_PASSED`
- VS-01 철도 기반: `IMPLEMENTED · PASSED`
- VS-02 기차·화물·역·LIFO: `IMPLEMENTED · PASSED`
- VS03-01 run lifecycle/economy/difficulty: `MERGED_AND_VERIFIED`
- VS03-01 구현 merge: PR #37 · `43972d3d23e931af3dbc81ab9b1c7d942fffb201`
- VS03-01 closure: PR #38 · `9360eff0a97f48f2234fcaf35425f80e94fac445`
- 자동 검증: Godot headless `16 cases · 7110 assertions · 0 failures`
- GMB-001: `CLOSED · SX-DEC-017~026`
- Decision merge: PR #29 · `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496`
- Definition of Ready: `SX-AUD-005 · PASS · SYNCED`
- 핵심 재미 정렬: `SX-AUD-007 · EV-USER-017~018 · CANONICAL_MERGE_PENDING`
- Codex: `READY_FOR_BUILD · VS03-02_ONLY`
- 다음 구현 package: `VS03-02 · compact token / TrainFootprint / DeliveryLoop occupancy provider`
- 제품 Scene runtime·Android·사람 검증: `NOT_RUN`
- 공식 100+ 맵 `F58`: `NOT_MET`
- 목표 플랫폼: Android / Google Play, 가로형

## 최초 읽기 순서

```text
AGENTS.md
→ 기획서/00_프로젝트_허브/START_HERE.md
→ 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
→ 기획서/10_경험/CORE_FUN_SYSTEM_HIERARCHY.md
→ 기획서/50_제작_검증/VS03_PACKAGE_STATUS.md
→ 기획서/50_제작_검증/CORE_FUN_ALIGNMENT_AUDIT.md
→ 기획서/50_제작_검증/CORE_FUN_ALIGNMENT_APPROVAL_ADDENDUM.md
→ docs/superpowers/specs/2026-08-03-playable-core-before-meta-sequencing-design.md
→ docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md
→ current package plan
→ 기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
→ docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
→ 기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
```

`VS03_PACKAGE_STATUS.md`가 현재 package 상태를 소유하고, `2026-08-03-vs03-core-first-resegmentation.md`가 승인된 미래 순서를 소유합니다.

## 승인된 실행 구조

```text
VS03-01 run lifecycle/economy/difficulty · DONE
→ VS03-02 compact token/TrainFootprint/DeliveryLoop occupancy · CURRENT
→ VS03-03 target3 maps/session/restart/selection
→ VS03-R1 difficulty authority alignment
→ VS03-05A minimal playable core surface
→ VS03-04 Profile/records/cosmetics/unlocks/rewards
→ VS03-05B result/collection/map browser
→ VS03-06 contextual onboarding
→ VS03-07 end-to-end integration/evidence handoff
```

- `VS03-R1`은 30초 속도 경계와 45초 연료 경계를 하나의 authoritative difficulty schedule에 정렬하는 안전 교정입니다.
- `VS03-05A`는 Profile보다 먼저 board·train·compact token·switch·LOAD/BOOST·최소 HUD·camera/run gate를 구현해 핵심 재미를 검증합니다.
- `VS03-04`가 Profile transaction과 장기 진행을 구현한 뒤, `VS03-05B`가 result·collection·map browser를 연결합니다.

공통 hotspot package는 병렬로 진행하지 않으며, 각 package는 이전 package merge·정본 동기화 뒤 시작합니다. 현재 실행 권위는 `VS03-02` 하나뿐입니다.

## 핵심 시스템과 보조 시스템

핵심 시스템:

- 선택 적재와 capacity 8 LIFO CargoStack
- 자동 운행과 선행 분기 결정
- 색상별 station과 연속 그룹 하역
- `Combo == unload_group_size`
- 시간·화물·연료 생존 경제
- BOOST 속도/연료/LOAD 기회비용
- compact token과 rear=LIFO-top 가독성

보조 시스템:

- onboarding·Help·camera·HUD·difficulty signal
- result insight·same-map restart·map discovery/reselection
- records·cosmetics·currency·Profile
- target3/target100 content pipeline
- telemetry·device/human evidence
- Production online UGC·moderation·community signals

보조 시스템은 핵심 적재·경로·위험 판단을 강화해야 하며 대체하면 안 됩니다.

## 운영 원칙

- GitHub Markdown·JSON이 상세 책임 원본입니다.
- Google Sheets는 사용자용 GDD 작업면이며 GitHub 정본을 대체하지 않습니다.
- ChatGPT는 기획·구조·데이터 설계·Issue·Codex Goal·벤치마킹·적대적 검토를 담당합니다.
- Codex는 승인된 현재 package만 구현합니다.
- 중요한 Grill Me에는 가까운 벤치마크·인접 사례·현업 기본안·제작 비용·실패 위험·검증 방법을 포함합니다.
- 벤치마크는 기능 복사 목록이 아니라 무엇을 배우고 무엇을 채택하지 않을지 설명해야 합니다.
- 실행하지 않은 runtime·Android·사람·온라인 테스트를 PASS로 보고하지 않습니다.
- 안전한 구현 교정은 승인된 플레이어 의미를 보존하면 새 Decision을 만들지 않습니다.
- wrong `19Ff...` Sheet는 수정하지 않습니다.
