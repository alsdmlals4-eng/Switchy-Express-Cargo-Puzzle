# Switchy Express — 남은 작업과 설계·구현 명세 검토안

> 2026-09-14 · `USER_APPROVED_EXECUTION_SCOPE` · 아래 최초 조사 시점의 구현 상태는 역사 기록.
> 사용자 후속 승인: “좋아 권장안대로 작업진행해”. M1 → C1 → C2를 실행한다.
> 승인 기록은 CURRENT_CONFIRMED_DECISIONS, 진행·증거는 ACTIVE_CONTEXT가 소유한다.
> 이 문서는 승인된 후속 작업의 경계와 인수 조건을 소유한다. 현재 Roadmap과 기존 PR의 소유권을 대체하지 않는다. 신규 스테이지의 좌표·해법 제작 전에는 그 부분을 완전한 제작 인계서로 사용하지 않는다.

## 1. 기준과 결론

- 프로젝트 확인 기준: `349825132f90e5363ff7fc702bb699432ba5c5fa` (PR #308 merged main).
- Base 관찰 기준: `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`. 프로젝트 compatibility `v9.4.3` 유지. 최신 Base를 이유로 pin/provider를 바꾸지 않는다.
- 현재 실행 권위: `AGENTS.md` → v4.8 Switchy adapter → `CURRENT_CONFIRMED_DECISIONS.md` / `ACTIVE_CONTEXT.md` → 분야 원본과 실제 consumer.
- 최초 요청은 명세 준비였고 후속 승인은 M1→C1→C2 실행이다. 신규 이미지 제작·공개 출시·관련 없는 열린 PR 변경은 포함하지 않는다.
- 결론: 승인된 기본 게임 범위에서 새로 확인된 미구현 필수 기능은 없다. 아래 목록은 **확인된 운영 정리**, **권장 콘텐츠 개선**, **조건부 진단**, **출시·최종 검수**를 구분한다. 개선 가능성을 기존 구현 미완료로 부풀리지 않는다.

현재 제품은 T1–T6 → VS_DEMO_01, 선택형 Route Book 01/02의 12개 스테이지, BUILD/RUN/Result/Retry/Edit 흐름을 갖는다. 현재 패키지 `Downloads/Switchy_Playable_20260913_PR305`와 이후 PR #308 증거를 읽었으며, 이번 조사에서 게임 검증을 재실행한 것은 아니다.

### 보호할 규칙

유한 수작업 배송 퍼즐, 자유 선로 건설·비용·전액 환불, 자동 열차 이동, 기본 수동 LOAD와 Auto 토글, 무제한 LIFO, 연속된 동일 TOP 그룹 하역, 상하좌우 정확히 한 칸 역 서비스, 화물 정확한 셀 접촉, 시작점 연결망 preflight, 점유 중 분기 잠금, 시간 실패/ROUTE_END/전체 배송 성공, 같은 배치의 새 runtime Retry 및 Edit를 유지한다.

탑뷰 승인 자산과 연결형 선로를 재사용한다. 네 언어 `ko/en/ja/zh-Hans`를 유지한다. 저장·해금·점수/PB·마스터리·Daily/Weekly·무한 모드·연료·BOOST·적재량 제한을 이번 후속 기본안에 추가하지 않는다. 5인 이해도 검수와 플레이 경험 연구는 요구하지 않으며, 기계 검증과 최종 사용자 검수는 구분한다.

## 2. 우선순위와 착수 조건

| ID | 작업 | 분류 / 준비 상태 | 완료 산출물 | 착수 조건 |
| --- | --- | --- | --- | --- |
| M1 | 현재 진입 문서·증거 경계 정리 | 확인된 정리 / 수정 명세 준비 | 정확한 현재 위치와 역사 구분 | 문서 정리 작업으로 실행 |
| C1 | RB08 비용–시간 선택 개선 | 권장 콘텐츠 변경 / 제약·인수 명세 준비 | 서로 우열이 갈리는 두 유효 해법 | 맵 변경 채택 후 좌표·해법 제작 및 검증 |
| C2 | Route Book 03의 6개 퍼즐 | 확장 승인 / L1 설계 + 구현 경계 준비 | 추가 6맵, 4언어, 18스테이지 검증 | 보호 초안과 분리하여 좌표·해법 구체화 |
| V1 | 배포 EXE 검증 공백 평가 | 검증 개선 / 기술 조사 명세 준비 | 실제 EXE 입력 검증 가능성 판정 | 현재 도구로 조작 가능성 먼저 확인 |
| D1 | native 오디오 종료 진단 | 조건부 / 재현 계약 준비 | 재현 증거 또는 제한된 비재현 결과 | 크래시/잔존 경고가 재발할 때 |
| D2 | Pilot 복원 간헐 실패 진단 | 조건부 / 관측 명세 준비 | 최초 실패 원인과 복원 검증 | 동일 실패가 재발할 때 |
| R1 | Android/Google Play 출시 준비 | 출시 별도 / 점검 명세 준비 | 권리·기기·정책 증거 묶음 | 실제 출시 범위·계정 조건 확정 |
| U1 | 최종 사용자 검수 | 구현 아님 / 시나리오 준비 | 정확한 빌드의 수용/수정 기록 | 사용자가 최종 검수를 진행할 때 |

권장 순서:

```text
M1 현재 상태 정리
  → C1 기존 퍼즐의 선택 깊이 강화
  → C2 기존 초안 정합성 확인 → 맵/해법 제작 → 런타임 통합
  → 해당 변경 바이트의 자동·실행·패키지 검증
  → U1 최종 사용자 검수

D1 / D2: 재발할 때만 별도 진단
R1: 출시 결정에 맞춰 진행하며 게임 기계 검증과 별도 판정
V1: 짧은 가능성 조사 뒤 유효한 검증 방식만 채택
```

## 3. 조사·비교와 채택 이유

조사일은 2026-09-14이다. 외부 사례는 제작 방식의 근거이지 본 게임 재미·판매량·최적해의 증거가 아니다.

| 1차 출처 | 관찰 | 판정 | 프로젝트 적용 |
| --- | --- | --- | --- |
| [Train Valley 2 개발사 스토어](https://store.train-valley.com/) | 수작업 Company Mode와 별도의 사용자 제작 콘텐츠 경로 | ADAPT / 일부 REJECT | 작은 수작업 묶음의 완결성을 채택. 편집기·UGC·경영 성장 시스템은 추가하지 않음 |
| [Railbound 개발사 2.0 업데이트](https://afterburn.itch.io/railbound/devlog/481366/update-20-launches-on-february-3rd) | 지역·퍼즐 묶음 형태의 콘텐츠 확장 | ADAPT | 새 규칙을 계속 늘리는 대신 기존 LOAD/LIFO/분기/감속/폐기 조합으로 6문제 설계. 원본 맵·그림·정답은 복제하지 않음 |
| [Godot Export 문서](https://docs.godotengine.org/en/latest/tutorials/export/exporting_projects.html) | export preset과 패키지 산출을 별도 관리 | ADOPT | 원본 체크아웃, exported PCK, template EXE 증거를 서로 구분 |
| [Google Play 앱 검토 준비](https://support.google.com/googleplay/android-developer/answer/9859455?hl=en_EN) | 앱 콘텐츠·대상·접근·정책 자료 필요 | ADOPT, 출시 때 재확인 | Windows 내부 검증을 스토어 승인으로 표기하지 않음 |
| [Google Play 데이터 보안](https://support.google.com/googleplay/android-developer/answer/10787469) | 데이터 처리에 대한 신고 책임 | ADOPT | 실제 SDK/네트워크/저장 동작 조사 후 신고. 사용하지 않는다고 추정하여 양식 작성하지 않음 |

선택지 비교: **A 기존 12개만 정리**는 가장 작은 회귀 범위이나 콘텐츠 증가가 없다. **B 즉시 6개 확장**은 콘텐츠 가치가 크지만 기존 초안 충돌과 미제작 맵을 먼저 해결해야 한다. **C 기존 맵 깊이 개선 후 6개 확장**을 권장한다. C는 C1에서 비용–시간 검증 방법을 먼저 확보하고 C2에 재사용할 수 있다. C1이 배치를 지나치게 복잡하게 만들면 감속 체험 문제로 유지하고 C2의 선택 문제에 그 목표를 옮긴다.

### SWOT와 구체적인 보완

| 구분 | 현재 근거 | 강화·완화 방법 | 확인 지표 / 한계 |
| --- | --- | --- | --- |
| 강점 | 역순 적재와 재방문을 선로 설계·운행 조작으로 연결 | C2에서 공간 읽기→적재 순서→선택적 LOAD→복합 운행 순으로 조합 | 각 맵 고유 양성/음성 해법. 기계 통과가 재미 보증은 아님 |
| 약점 | RB08 제작자 해법 비교에서 우회가 비용·시간 모두 불리 | C1에서 기존 속도 규칙을 유지한 맵 배치 조정 | 비용 낮은 해법과 시간 짧은 해법이 서로 달라야 함 |
| 기회 | 기존 룰과 탑뷰 자산으로 새 수작업 문제 제작 가능 | C2에서 추가 이미지 0개를 기본값으로 6개 묶음 | 기존 12개 회귀 + 신규 6개 실제 SUCCESS. 숫자만 채운 유사 맵은 탈락 |
| 위협 | 낡은 실행 문서·초안 Decision 충돌·증거 혼용 | M1 정리, PR #281 보호, V1/R1/U1 분리 | 현재 실행 포인터 오류 0, 승인 전 확장 구현 0, 미실행 PASS 0 |

독창성의 목표는 새 기믹의 개수가 아니라 **공간 경로, 역순 적재, 접촉 순간의 LOAD 판단을 동시에 설계하는 퍼즐**이다. ‘최초’나 경쟁작 대비 우월함은 주장하지 않는다.

## 4. M1 — 진입 문서와 현재 증거 정리

**현재 상태/이유:** `START_HERE.md`의 오래된 패키지 안내와 `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`의 PR #295 중심 상태가 최신 Active Context보다 뒤처져 있다. AGENTS에 열거된 `기획서/50_제작_검증/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PLAN.md`는 현재 작업 트리 파일 탐색에서 발견되지 않았다. 이 사실은 출시 기능 누락이 아니라 참조 점검 대상이다.

**수정 범위:** 위 진입점과 `AGENTS.md`의 해당 참조만 최신 책임 원본으로 연결한다. 플랫폼 내용은 `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`, 권리는 `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`, 증거는 `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`가 소유한다. 파일 존재를 맞추려고 새 빈 계획서를 만들지 않는다. 과거 날짜·실패·패키지 기록은 역사로 남긴다.

**실행 계약:** 최신 main을 다시 확인 → tracked tree에서 경로 확인 → 현재/역사 문구만 수정 → Active Context와 Roadmap의 다음 안전 작업 포인터 정합성 확인. 승인된 C1/C2를 구현 완료로 표시하지 않는다.

**인수 조건:** 현재 진입 링크가 실재하고 현재 패키지·실행 증거의 범위가 일치한다. 과거 native 원인 수정과 별도 미해결 진단을 구분한다. `python tools/validate_project_contract.py`와 `git diff --check` 통과. 게임/data/art/engine pin 변경 0. 회귀 시 문서 변경만 되돌린다.

## 5. C1 — RB08 비용–시간 트레이드오프

### 승인 후 제작 인계 — 2026-09-14

`CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF`: 승인 기록과 이 명세의 GitHub
merged main readback 뒤 아래 map/test/copy 변경을 실행한다.
원래 조사 결과와 제약은 아래에 보존한다.

- map_revision 2; board 11×7, start [1,3], incoming [0,3], 115초, buildable [1,1]…[9,5] 유지.
- BLUE [3,3] 유지, RED 화물 [8,3], RED 역 [8,1], BLUE 역 [9,5].
- caution [[3,3],[4,3],[5,3],[6,3],[7,3]]: 화물 접촉 1칸 + 선택 우회 가능한 4칸.
- 기존 blocked/decor [8,1]은 역과 충돌하므로 [9,1]로 함께 이동. 나머지 유지.
- 직행: start → [2,3] → [3,3] → [4,3] → [5,3] → [6,3] → [7,3] → [8,3]
  → [8,2] → [9,2] → [9,3] → [9,4].
- 우회: start → [2,3] → [3,3] → [3,4] → [4,4] → [5,4] → [6,4] → [7,4]
  → [8,4] → [8,3] → [8,2] → [9,2] → [9,3] → [9,4].
- 두 경로는 BLUE→RED 적재, RED→BLUE 하역. 직행 11조각/1100, 우회 13조각/1300 예상.
  비용·시간 예상은 actual runner 결과로 판정하며 최적해를 주장하지 않는다.
- fixture는 RB08 전용으로 분리하여 기존 RB02를 바꾸지 않는다. 화면 미리보기의 caution
  2칸 기대를 5칸으로 교정하고 네 언어의 단수 '다른 감속 칸'을 구간 표현으로 바꾼다.
- 실행 순서: 비용·시간 RED 확인 → map/fixture/copy/preview-test 변경 → 기존
  `tests/runtime/route_book_witness_runner.gd` GREEN → 전체 `tests/run_tests.gd`
  → 실제 창과 changed-byte export 검증 → 독립 검토/CI/merge/readback.
- 현재 RED 실행: 기존 map에서 12개 SUCCESS는 유지되지만 우회 0.25초 절약 조건 실패,
  runner exit1. 이 결과는 해당 개선이 아직 없음을 검증하며 제품 크래시가 아니다.

사전 전체 범위 검토: (1) 역 footprint와 장식 충돌은 위 [9,1] 이동으로 교정;
(2) 공통 화물을 피하지 않는 두 경로, 전역 수치 유지 확인;
(3) RB02 fixture 공유 변경 위험은 RB08 전용 분리로 교정;
(4) 미리보기/4언어 단수 표현까지 변경 범위 포함;
(5) 기존 패키지 증거 승계 금지, 새 바이트의 실제 실행과 내보내기 요구.
이는 사전 설계 검토이며 구현 후 다섯 전체 회귀 검토를 대체하지 않는다.

### 경험·규칙

플레이어가 “돈을 아끼고 감속 구간을 통과할지, 선로를 더 깔고 빨리 갈지”를 선택하게 한다. 이것은 현재 구현의 필수 버그 수정이 아니라 콘텐츠 개선 제안이다.

현재 제작자 해법 기록은 직행 비용 1100 / 약 6.517초, 우회 비용 1300 / 약 7.108초이다. 두 해법 모두 성공하므로 우회 가능성은 있으나 이 비교에서 비용–시간 교환은 성립하지 않는다. 모든 가능한 해법의 최적성 분석은 아니다.

**변경:** `data/maps/route_book/rb08_caution_cut.json`의 buildable/blocked/caution 배치와 관련 장식 셀을 조정한다. **유지:** schema_v3, 카드/화물 의미, 기존 속도 2.0, caution 배율 0.55, 전역 비용, 115초 제한을 기본 경계로 유지한다. 전역 속도나 다른 맵을 조정하여 이 맵의 선택을 인위적으로 맞추지 않는다.

### 소비처와 데이터·검증 설계

- 실제 감속 소비처: `game/finite/run/finite_run_controller.gd`의 현재 출발 셀 caution 판정. 신규 속도 모드/API를 만들지 않는다.
- 해법 원본: `tests/fixtures/route_book/route_book_witnesses.gd`의 RB08 `pieces()`와 `rb08_caution_detour()`.
- 검증 원본: `tests/route_book/test_route_book_machine_witnesses.gd`의 `_run_manual()` 결과 `phase`, `build_cost`, `elapsed_seconds`, `visited_cells`, `pickups`, `unloads`.
- 맵 수정 뒤 기존 renderer/import 흐름으로 소비한다. 신규 bitmap/atlas/애니메이션 0개. 장식이 화물·역·선로를 가리지 않도록 변경 셀을 점검한다.

**RED 계약:** 두 기존 해법의 성공을 확인한 뒤 `direct.build_cost < detour.build_cost`와 `direct.elapsed_seconds >= detour.elapsed_seconds + 0.25`를 함께 검사한다. 현재 기록 기준 두 번째 조건이 실패해야 한다. 0.25초는 의미 없는 부동소수점 차이를 피하기 위한 `RECOMMENDED_DEFAULT`이며 승인된 밸런스 상수가 아니다.

**데이터 제작:** 정상 적재 BLUE→RED, 하역 RED→BLUE를 보존하는 두 연결 경로를 먼저 작성한다. 선택 가능한 추가 caution 통과 수와 우회 길이를 조정하고 실제 runtime으로 재측정한다. 강제로 지나야 하는 화물 셀을 회피하는 가짜 우회는 탈락한다. 기존 음성 해법의 화물 누락 실패를 유지한다.

**인수 조건:** 두 해법 SUCCESS, 실제 비용 차이 최소 유효 선로 1개분, 시간 역전 최소 0.25초, 금지 셀 침범 0, 누락 화물 음성 실패, 나머지 11맵 회귀 없음. 실제 화면에서 두 경로의 선로 연결·감속 피드백 확인. 정답 경로를 제품 UI에 표시하지 않는다.

**실패/축소/되돌림:** 조건을 만족시키려다 맵이 불필요하게 복잡해지면 기존 RB08를 유지하고 목표를 ‘감속 체험/선택 우회’로 설명한다. map와 해당 fixture/test delta를 함께 되돌린다. 새 좌표와 통과 해법은 아직 제작되지 않았으므로 상태는 `DESIGN_CONSTRAINTS_PREPARED`, `ASSET_READY/IMPLEMENTED`가 아니다.

## 6. C2 — Route Book 03, 6개 수작업 퍼즐

### 선행 정합성 게이트

기존 Draft [PR #281](https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle/pull/281), head `abf0550cf28c3cb320e26067e11106693d5bdc1d`는 READ_ONLY다. 그 초안의 `SX-DEC-070`은 현재 main의 다른 결정에 사용되고, 자산·검증 기준도 오래됐다. **그 PR을 수정/병합/흡수하지 않는다.** 이번 별도 콘텐츠 승인은 Decisions의 September14 기록으로 추적한다. 보호 PR의 ID를 재사용하지 않고 현재 main에서 범위·참조·증거를 준비한다.

### 플레이 흐름과 경계

```text
Title → Route Book 선택 → 03 선택 → RB13…RB18 직접 선택
  → 기존 BUILD → preflight → RUN → SUCCESS / FAILURE
  → 같은 맵 Retry / Edit / 같은 Book 목록 / Title
```

Title의 기본 Start는 여전히 T1이다. 신규 책은 선택형이며 잠금·보상·영구 진행 저장이 없다. 취소/뒤로 가기는 기존 목록으로, Retry는 선택 맵 배치를 유지한 새 runtime으로, Edit는 기존 규칙에 따라 건설로 돌아간다. 완료 상태나 이전 책의 stage context가 다른 책에 남지 않아야 한다.

### 스테이지 계약 — 이름과 ID는 제안

| ID / 제안 파일 | 주요 판단과 제작 제약 | 양성 해법 | 반드시 실패하거나 차단할 음성 해법 |
| --- | --- | --- | --- |
| RB13_FOUR_SIDES / `rb13_four_sides.json` | 역 서비스 면을 먼저 읽는 공간 문제. 대각선 착시를 피할 명료한 탑뷰 | 실제 cardinal service를 지나는 완주 | 대각선만 접근하거나 역 footprint를 선로로 쓰려 함 |
| RB14_MANIFEST_MIRROR / `rb14_manifest_mirror.json` | 3화물·2종류의 역순 적재. 동일 TOP 그룹 하역을 활용 | 적재 순서를 역 방문 순서와 맞춤 | 먼저 보이는 순서대로 적재하여 다른 종류 TOP가 하역을 막음 |
| RB15_MANUAL_GAP / `rb15_manual_gap.json` | 첫 접촉은 건너뛰고 재방문에서 적재 | 수동 LOAD 시점을 구분하여 완주 | Auto를 계속 켜서 잘못된 화물을 먼저 적재 |
| RB16_CAUTION_LEDGER / `rb16_caution_ledger.json` | 점유 전 분기와 기존 caution 구간의 조합 | 올바른 분기를 미리 선택하여 완주 | 잘못된 분기 진입 후 점유 잠금을 무시하려는 조작 |
| RB17_CLEARANCE_YARD / `rb17_clearance_yard.json` | 폐기 화물 2개와 일반 배송의 TOP 순서 | 일반 배송 후 연속 폐기 TOP 그룹 처리 | 적재 순서가 잘못되어 일반/폐기 하역이 막힘 |
| RB18_SWITCHBOARD_NIGHT / `rb18_switchboard_night.json` | Auto 선택, 점유 잠금, caution, LIFO, 그룹 폐기의 종합 | 각 조작과 하역 순서가 연결된 완주 | 분기 또는 Auto 타이밍 한 가지를 바꾸어 실패 재현 |

모든 제안 맵 경로는 `data/maps/route_book/` 아래다. 각 맵은 별도 grid/start/incoming/buildable/blocked/station/cargo/disposal/caution/time 데이터와 실제 해법을 갖춰야 한다. 위 표는 그 값을 대신하지 않는다. 각 문제의 정답을 UI에 노출하지 않으며, 플레이어 문구는 목표와 관찰 정보만 제공한다.

### 실제 수정 위치와 인터페이스

| 책임 | 기존 수정 / 제안 생성 경로 | 계약 |
| --- | --- | --- |
| 책 탐색 | `game/route_book/route_book_catalog.gd` | `book_ids()`, `definition_path(book_id)`, `copy_path(book_id)`, `display_key(book_id)` 유지. 세 번째 등록만 추가 |
| 데이터 검증 | `game/route_book/route_book_definition.gd` | schema1 및 `STAGE_IDS_BY_BOOK`의 엄격한 6개 목록 확장. 알 수 없는 ID/path, 중복/누락/순서 오류는 거부 |
| 책 데이터 | 새 `data/route_book/route_book_03.json` | 기존 책 schema 사용. `RECOMMENDED_LAYOUT` 금지 유지 |
| 공용 선택 문구 | 새 `data/localization/route_book_selector_v1.json` | 현재 02가 소유한 공용 selector key만 이전. 기존 번역값 보존, 일반적인 현지화 시스템 리팩터링 금지 |
| 새 책 문구 | 새 `data/localization/route_book_03_v1.json` | 4언어 제목/목표/목록 문구. 키 누락 시 기존 검증 경계에서 fail-closed |
| 화면 연결 | `game/demo/demo_flow_controller.gd` | `_route_book_selector_copy`의 02 파일 의존만 공용 파일로 교체. catalog 기반 3책 목록 연결 |
| 맵 | 위 표의 6개 새 JSON | 기존 `FiniteMapDefinition`/Loader와 runtime을 재사용. 신규 필드/새 엔진 규칙 없음 |
| 해법과 증거 | `tests/fixtures/route_book/route_book_witnesses.gd`, `tests/route_book/` | 신규 6개 양성 및 6개 이상 구체적 음성 해법 |
| 실제 완료/패키지 | `tests/runtime/route_book_completion_window_runner.gd` | 현재 12개 고정 기대치를 승인된 18개 정확 ID 집합으로 확장. 단순 catalog 자기비교로 누락을 통과시키지 않음 |

기존 `route_book_director.gd`는 우선 재사용한다. 추가 파일을 만들기 전에 최신 main에 이미 생겼는지 확인한다. 테스트 fixture는 출하 자산으로 포함하지 않는다. export된 JSON/자산 소비 검사는 `tests/python/test_exported_route_book_consumer.py`와 기존 패키지 실행 경로를 확장한다.

필수 copy 소비 계약: 각 신규 stage에 `context_key`를 등록하고 여섯 context 문자열을
4언어로 제공한다. 책03 copy에는 `SX_RB_PROGRESS`, `SX_RB_BEGIN`,
`SX_RB_NEXT_STAGE` 등 기존 Director/Briefing/Result가 사용하는 공통 동작 키를
현재 consumer 기준으로 모두 제공한다. 공용 selector copy는 catalog display_key가
요청하는 RB01/RB02/RB03 label 및 목록/뒤로 키를 모두 소유한다.
완료 runner의 index 기반 book 선택을 정확한 stage→book 매핑으로 바꾸고,
RB13–RB18 각각의 실제 입력 driver와 음성 경로를 추가한다. 숫자 12→18만 바꾸거나
RB13+를 기존 Book02에 넣는 방식은 실패다.

### 제작·검증 순서와 인수 조건

1. 초안 정합성 게이트 통과. 기존 12개 맵·문구·동작 baseline을 기록한다.
2. 책03 부재/잘못된 ID/누락 번역을 잡는 RED를 작성하고 실패 원인을 확인한다.
3. RB13부터 각 맵 좌표와 입력 해법을 함께 제작한다. 한 맵의 양성·음성이 성립한 뒤 다음 맵으로 이동한다. 이 단계 산출물이 있어야 상세 제작 명세가 완성된다.
4. 세 번째 책 등록과 공용 문구만 연결한다. 각 stage 진입/취소/Retry/Edit/책 이동의 context를 확인한다.
5. `test_route_book_catalog.gd`, `test_route_book_definition.gd`, `test_route_book_maps.gd`, `test_route_book_machine_witnesses.gd`, `tests/demo/test_route_book_context.gd`, `test_route_book_flow.gd`, `test_route_book_responsive_layout.gd`, `test_route_book_result_truth.gd`의 회귀를 검증한다. 책03 copy 검사는 새 테스트 파일로 추가한다.
6. 실제 Main/Product 경로 18 SUCCESS, 신규 음성 해법 실패, 4언어 960×540/1280×720 목록·목표·Result 가독성 및 스크롤, 패키지 실제 JSON 소비를 확인한다.
7. 5회 전체 범위 적대 검토 → 유효 지적 수정 → 전체 회귀 → exact-head 필수 CI → 일반 병합 → postmerge readback. 이 문서 작성 자체가 이 제품 증거를 충족하지 않는다.

**자산/모션:** 신규 bitmap 0개를 기본값으로 한다. 기존 승인 역·화물·폐기장·caution·장식·연결 선로·이벤트 효과를 사용한다. 필요한 새 슬롯이 실제로 발견될 때만 별도 brief와 승인 흐름을 연다. ‘새 책이므로 새 이미지가 반드시 필요’하다고 가정하지 않는다.

**롤백:** 책03 등록·맵·문구·해법·테스트를 하나의 범위로 되돌린다. 책01/02와 T1 진입 유지, 저장 migration 없음. 6개를 만족시키지 못한 상태에서 일부만 정식 03으로 노출하지 않는다.

## 7. V1 — 실제 배포 EXE 증거의 공백

현재 구분: template EXE 시작/창 증거와 editor가 exported PCK를 마운트한 12개 SUCCESS 증거는 별개다. **template EXE로 전체 12개를 입력 조작한 검증은 NOT_RUN**이다.

먼저 현재 연결 도구가 실제 Windows 게임 창에 입력을 보낼 수 있는지 확인한다. 불가능하면 `CAPABILITY_UNAVAILABLE`로 기록하고 코드에 테스트 훅을 심거나 자동 완료 경로를 추가하지 않는다. 가능하면 동일 EXE/PCK hash를 고정하고 Title→책→맵→BUILD→RUN→Result→Retry/Edit 순서의 실제 입력과 화면을 수집한다. 시작 성공과 전체 플레이 성공을 별도 결과로 저장한다.

예상 소비처는 배포 EXE와 외부 검증 도구이며 제품 규칙/씬 변경은 기본 0개다. 완료 산출물은 도구·OS·GPU·렌더러·해시·입력 시나리오·결과·실패 캡처를 묶은 검증 기록이다. 자동 조작 가능성이 확인되기 전에는 완전한 실행 스크립트 제공 가능 상태로 주장하지 않는다.

## 8. D1 / D2 — 재발 시에만 실행하는 진단 명세

### D1 오디오 종료

`evidence/runtime/native-generator-lifetime-20260913/READBACK.md`는 generator 원본 수명을 playback metadata로 유지하는 수정과 후속 제한 관측을 구분한다. 약한 참조가 추가 프레임 뒤 사라진 기록이 있어 종료 경고만으로 영구 누수를 단정하지 않는다.

- 소비처: `game/demo/audio/demo_audio_director.gd`; 재현기 `tests/runtime/audio_generator_lifetime_runner.gd`, `tests/runtime/native_exit_isolation_runner.gd`.
- 재현 입력: 동일 씬 진입/이탈/종료 순서, 반복 횟수, 오디오 on/off를 진단 조건으로 분리. 제품 기본 소리를 끄지 않는다.
- 관측값: source/playback WeakRef 생존 수와 frame, exit code, stdout/stderr, 크래시 stack. 기존 제한 drain 관측과 같은 상한을 명시한다.
- RED는 동일 순서에서 실제 재현한 수명 위반/크래시다. 단순 경고를 숨기는 필터나 임의 sleep은 수정이 아니다.
- 인수: 원래 재현 조건 통과, 관련 전환 회귀, 새 영구 보유 없음. 재현하지 못하면 조사 결과만 남기고 production patch를 만들지 않는다.

### D2 Pilot 복원

Windows byte contract 수정 후 별도 Linux 일시 실패는 변경 없는 재시도에서 통과한 기록이다. 현재 제품 실패로 재분류하지 않는다.

- 소비처: `tools/godot-live-editor-pilot/pilot_plugin/plugin.gd`의 `_restore_original_scene`, 관련 `plugin_exact_restore.gd`.
- 재발 시 수집: undo 전후 history ID/action/version, scene root instance/path, node 목록, disk hash, 파일 스캔 상태와 시간. 최초 실패 로그를 성공 재시도로 덮지 않는다.
- 수정 조건: 특정 순서/상태에서 원인 재현. pinned vendor 교체, 복원 hash 검사 제거, 무한 재시도는 금지한다.
- 인수: 원래 exact-restore 조건 및 Windows/Linux 관련 검증을 각각 통과. 이것은 게임 UX/완성도 추가 기능이 아니다.

## 9. R1 — 출시 명세와 남은 결정

현재 플랫폼 프로필은 **Android / Google Play가 1차 출시 후보**, Steam/STOVE는 현 범위 밖이다. Windows 검수 패키지가 있다고 Windows 상점 출시가 승인된 것은 아니다.

| 작업 | 실제 책임 원본 / 입력 | 인수 조건 |
| --- | --- | --- |
| 출하 자산 권리 인벤토리 | `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md` + 실제 export consumer | 이미지/폰트/음원/플러그인별 source, license, 수정·배포·표기 조건, hash, consumer를 연결. UNKNOWN/누락은 출시 차단 |
| Android 실행 검증 | `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md` + 현재 export preset | 선택 기기/OS에서 설치·시작·터치·작은 화면·뒤로/중단복귀·오디오·긴 실행·실패복구 증거. 실행하지 않은 기기는 NOT_RUN |
| 제출 준비 | `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md` | 제출 시점의 target API, signing, 대상 연령, 광고/IAP 유무, privacy/data safety, 계정별 사전 테스트 요건을 실제 상태와 대조 |
| 공개 자료 | 실제 채택 빌드 및 승인 자산 | 기능·화면·권리와 일치하는 설명/스크린샷. 내부 테스트 화면을 최종 제품으로 오인시키지 않음 |

이번 준비에는 공개 제출·계정 보안/서명 변경·비용 지출이 포함되지 않는다. 모든 asset rights가 미확인이라고 단정하지도, 일부 원장으로 전체 허용을 주장하지도 않는다. 먼저 실제 출하 인벤토리의 coverage를 계산한다. 정책 수치는 제출 시점 공식 문서로 재확인한다. 사용자 기계 검증 선호는 스토어의 적용 가능한 테스트/정책 의무를 면제하지 않는다.

## 10. U1 — 최종 사용자 검수 시나리오

이는 신규 시스템이 아니라 현재 바이트의 수용 기록이다. 5명 모집이나 플레이 연구를 요청하지 않는다.

1. Title과 기본 Start/T1, T2의 화물 접촉·cardinal 배송을 확인한다.
2. T6와 capstone에서 분기 잠금, Auto, TOP 정보가 읽히는지 확인한다.
3. RB08, RB10, RB12에서 감속/폐기/복합 운행 연출과 탑뷰의 일관성을 본다.
4. SUCCESS/FAILURE 이후 Retry와 Edit, Pause/복귀, 다른 책 이동을 확인한다.
5. 소리 크기·반복음·선로 연결·선택 표시·정보 가림에 대한 `ACCEPT / CHANGE_REQUEST`를 실제 장면과 함께 남긴다.

검수 기록은 source SHA, EXE/PCK SHA-256, 언어/화면/장치, 검수한 항목과 하지 않은 항목을 포함한다. 이후 C1/C2로 제품 바이트가 바뀌면 영향을 받는 이전 검수는 자동 승계하지 않는다.

## 11. 자동화·정리·승격 판단

- 자동화 우선: C1의 측정 가능한 해법 비교, C2의 정확 ID 집합·음성 해법·실제 완료 경로. 성공 숫자만 늘리지 않는다.
- 문서 오류 재발 방지: 기존 contract validator 범위를 먼저 확인하고, 현재 진입점의 잘못된 링크가 재발한다면 좁은 링크 검사를 기존 검사에 추가한다. 문서 전체에 새로운 대시보드/독립 정본을 만들지 않는다.
- 삭제: 사용 종료가 확인된 작업 전용 파일만 원래 경로·hash·이유·복구 방법과 함께 사용자 삭제 대기 폴더로 이동한다. 미확인 원본, dirty worktree, 다른 PR, 승인 provenance는 유지한다. 이번 작성에서 파일 이동/삭제 없음.
- Base 승격: 이번 발견은 우선 프로젝트 기록이다. 복수 프로젝트 재현·공용 consumer·검증 근거가 확보되기 전 Base 규칙/스킬을 직접 수정하지 않는다. 특히 RB08 수치는 프로젝트 고유이므로 공용 승격 대상이 아니다.

## 12. 이번 준비의 검증 범위와 미완성 경계

이 문서는 파일·코드·증거를 읽고 작성한 검토안이다. 프로젝트 계약 검사를 실행했지만 제품 테스트와 native 실행은 이번 작성에서 수행하지 않았다. 기존 증거 수치 129 cases / 16133 assertions, Python 309 passed / 1 skipped, exported PCK 12 SUCCESS는 **기존 readback 기록**이며 새 실행 결과가 아니다.

열린 PR #174/#254/#281은 변경하지 않는다. 이전 dirty import/settings 작업을 보존한다. C1/C2 실행 승인은 후속 사용자 지시와 Decisions에 기록됐다. 문서의 저장/게시만으로 main 병합, 게임 구현, Human/Device/Rights/Release PASS가 되는 것은 아니다.

남은 상세 설계 산출물은 C1의 실제 변경 좌표·두 해법, C2의 6개 실제 맵·입력 해법·음성 해법·번역 데이터, V1의 입력 도구 가능성, R1의 계정/기기/실제 권리 coverage다. 이 값들을 만들어 확인하기 전에는 해당 항목을 ‘최종 구현 명세 완료’로 표시하지 않는다. 우선 다음 구현 단위는 M1이며, 다음 제품 설계 단위는 C1이다.
