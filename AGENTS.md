# Switchy Express 공용 AI 작업 규칙

이 저장소는 `alsdmlals4-eng/Base` v9.4.3 운영 계약을 적용한 Godot 모바일 게임 프로젝트다.

## 우선순위

1. 사용자의 최신 지시
2. 현재 환경의 system/developer/security 제약
3. 이 `AGENTS.md`
4. 현재 작업지시문 정본 `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
5. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
6. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
7. 등록된 분야 책임 원본
8. 실제 코드·데이터·Scene·Resource·자산·테스트
9. 프로젝트에 고정된 Base v9.4.3 기준
10. Base remote current `main`의 비교·학습 근거
11. 외부 사례·과거 대화·추정

## 현재 작업지시문 정본 — v4.5 r2

```yaml
work_instruction_canon: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md
contract_version: 4.5
revision: 2026-08-11-r2
source_sha256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
audit: SX-AUD-045
representation: CONTENT_ADDRESSED_MULTIPART_VERBATIM_CANON
```

- 루트 manifest와 등록된 `docs/work-instructions/v4.5_r2/` segment의 binary concatenation이 사용자 제공 r2 원문 정본이다.
- 이 작업지시문은 프로젝트 **실행 Thin Adapter**이며 제품 gameplay/domain 정본을 대체하지 않는다.
- 매 작업 시작 시 Base current `main`, 프로젝트 default branch/open PR/latest, configured Google Sheet를 다시 읽는다.
- 현재 Phase A 기획 증거는 `READY_FOR_USER_PLANNING_COMPLETE_GATE`다.
- 사용자가 명시적으로 `기획 완료`를 선언하기 전에는 Phase B를 시작하지 않는다.
- Phase B PASS 전에는 PowerShell/Codex/Godot BUILD를 시작하지 않는다.
- `권장안대로 승인`, `연속작업 진행`, 과거 DoR/구현 승인만으로 `기획 완료` Gate를 자동 충족시키지 않는다.

## 역할 분리

- ChatGPT: 핵심 재미, 콘텐츠·맵·규칙 기획, 벤치마킹, 아트·UX 방향, Google Sheets GDD, GitHub 정본·Issue, 적대적 검토, Codex 전달 명세
- Codex: 사용자 `기획 완료` 선언과 Phase B 최종 검수 PASS 이후, 승인된 Definition of Ready 범위에서 실제 Godot/GDScript 코드·테스트 변경
- 사용자가 명시하지 않은 게임 규칙·세계관·과금·콘텐츠를 임의로 확정하지 않는다.
- 현재 대화에서 합의된 제품 규칙과 구현 상세를 혼동하지 않는다.

## 엔진·플랫폼

- Engine: Godot `4.7.1-stable`
- Language: GDScript
- Primary platform: Android / Google Play
- Orientation: landscape
- Godot 용어를 사용하며 Unity/C#/Prefab/MonoBehaviour 프레이밍을 사용하지 않는다.

## 현재 제품 기준선 — GMB-002

- 수작업 유한 배송 퍼즐
- 건설 불가 구역을 제외한 자유 선로 건설
- 선로별 건설비와 전액 환급 가능한 건설 단계
- 모든 역·화물의 구조적 도달 가능성 완료 후 운행 시작
- 자동 운행 + 수동 적재 기본 + 자동 적재 토글 + 분기 직접 탭
- 화물칸 수량 제한 없음
- 마지막에 실은 화물부터 하역하는 LIFO
- TOP에서 같은 종류가 연속되는 그룹만 자동 하역
- Combo는 일시 가속과 점수 보너스
- 제한 시간 종료 시 미배송 화물이 있으면 실패
- 마지막 하역 완료 시 즉시 성공
- 신속·절약·점수 별과 속도·가격·점수 리더보드
- 1~10 튜토리얼, 11+ 테마 챕터, 일일·주간 고정 시드 도전
- 성능 없는 꾸미기 보상만 허용

코어 변경은 `USER_DECISION_REQUIRED`다.

## 현재 정본

- 작업지시문: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
- 제품 기준선: `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- 대체 등록부: `기획서/00_프로젝트_허브/CANON_REPLACEMENT_REGISTER.md`
- 현재 결정: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- 핵심 경험: `기획서/10_경험/CORE_GAMEPLAY.md`
- 시스템 규칙: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
- 아트·UI: `기획서/40_표현/VISUAL_DIRECTION.md`
- 제작·검증: `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- 사용자 GDD: `https://docs.google.com/spreadsheets/d/1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo/edit`

## 구형 구현 처리

현재 main의 다음 구현은 역사 증거이자 부분 재사용 후보지만 새 제품 완료 증거가 아니다.

- RailGraph·자동 이동·분기·CargoStack·LIFO
- compact token/TrainFootprint
- map/session/restart/selection

다음 구현은 새 제품 기준에서 `LEGACY_IMPLEMENTATION`이다.

- endless survival
- fuel drain/recovery/fuel-zero end
- player BOOST input
- cargo capacity 8
- cargo-count slowdown
- timed speed/fuel pressure escalation
- pickup respawn
- switch auto-reset after passing

현재 승인된 SX-DEC-055 DoR이 존재하더라도 **명시적 사용자 `기획 완료` Gate와 Phase B PASS 전에는 제품 BUILD를 이어가지 않는다.**

## 상태 표기

- `[대체됨]`: 새 정본이 같은 책임을 인수함
- `[보류]`: 현재 범위 밖이며 재검토 가능
- `[폐기]`: 새 제품 방향과 충돌해 구현 대상으로 사용하지 않음
- `[역사 증거]`: 당시 구현·테스트 사실만 보존

## 금지

- 승인 없이 코어 변경
- old endless 구현을 새 finite puzzle 구현 완료로 보고
- FIFO 하역으로 되돌리기
- 색상만으로 화물과 역을 구분
- 운행 중 선로 건설·철거 허용
- 추천 설계도를 랭킹 최적해로 제공
- 성능 강화 꾸미기·과금 추가
- 실행하지 않은 테스트를 통과로 보고
- 사용자 승인 없이 광고·가챠·에너지·PvP·길드 추가
- `기획 완료` 또는 Phase B PASS 없이 PowerShell/Codex/Godot BUILD 시작

## Base v9.4.3 운영 계약

```yaml
base_version: 9.4.3
base_payload_commit: 7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8
base_trusted_evidence_commit: da33a350d61b8adc52df97fccc7001708a933370
base_pin_finalization_commit: 0b7c94f38d959efc0fc9442274c60b2e268a3c97
base_registry_sha256: 693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59
```

- 위 pin은 프로젝트 채택 release다. Base remote current `main`은 매 작업마다 비교·학습용으로 다시 읽되 자동 repin하지 않는다.
- `[모델 추천]`은 실제 설정을 자동 변경하지 않으며 사용자가 checkpoint에서 변경한다.
- L1 이상 지시문은 `route → first-prompt → contract → clarify`를 거치고 exact approval reference가 있으면 재사용한다.
- 기획 충돌은 Grill Me 사용자 승인을 요구한다.
- 가역적 상세 수치는 이유·조정 조건·검증 한계를 기록한 `TEST_VALUE`로 진행할 수 있다.
- Grill Me 승인 배치는 최대 10건이며 고위험·정본 충돌·구현 차단·세션 종료 시 조기 checkpoint를 허용한다.
- LIFO·화물/역 색상+모양·저장 호환성·랭킹 ruleset identity는 `HARD_CONSTRAINT`다.
- UI 모션은 퍼즐 결과·점수·적재·하역·저장의 권위가 아니다.

## 플랫폼 출시·에셋 권리

출시·외부 자산·AI·외주·참조 기반 독립 제작 작업은 다음 프로젝트 증거를 읽는다.

- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`

Android·Google Play가 우선이다. 콘텐츠 등급과 target audience를 분리하고 Families, 광고 SDK, 데이터·개인정보, ads/IAP와 cosmetic currency를 함께 검토한다. 원본을 조금 수정하거나 AI로 변환했다는 이유만으로 독립 자산으로 보지 않고 `reference_brief`, `forbidden_expression`, 별도 `final_asset_record`, 유사성 검토를 요구한다.

필수 권리·계약·약관 버전·플랫폼 답변·build/store/questionnaire 일치가 미확인이면 `RELEASE_BLOCKED_UNVERIFIED`다. 사용자 승인 없는 광고·가챠·에너지·성능 과금 금지와 Phase B PASS 전 제품 BUILD 금지를 변경하지 않는다.
