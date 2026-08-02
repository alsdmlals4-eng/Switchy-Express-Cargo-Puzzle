# Core Fun Alignment and Benchmark Audit

```yaml
audit_id: SX-AUD-007
evidence_id: EV-USER-017
scope: core fun · core/support systems · benchmark · PR #37/#38 · current main
state: REVIEWED_WITH_FOLLOWUPS
product_rule_change: NONE
current_package_authority: VS03-02_ONLY
```

## 1. 감사 목적

현재 승인된 시스템이 프로젝트의 핵심 재미를 실제로 강화하는지, 보조 시스템이 핵심을 가리거나 구현 순서가 핵심 검증을 늦추는지 확인한다.

또한 PR #37과 #38 이후 코드·정본·Issue·Sheet 상태를 대조하고, 앞으로 Grill Me와 주요 기획 작업에 외부 벤치마크와 현업 비교를 의무 입력으로 추가한다.

## 2. 한 문장 핵심 재미

> 자동으로 달리는 열차에서 **앞으로 필요한 하역 순서를 역산해 화물을 골라 싣고**, 분기기를 미리 바꾸며, 무게와 연료 압박을 감수해 **큰 LIFO 하역 그룹을 성공시키는 계획형 생존 퍼즐**.

핵심은 단순 철도 운행이나 빠른 탭이 아니다.

```text
적재 순서 계획
→ 노선 선행 결정
→ 위험을 감수한 운반
→ 뒤쪽부터 의도한 그룹 하역
→ 큰 Combo와 생존 연장
```

## 3. 시스템 위계

### 3.1 핵심 시스템

핵심 재미가 제거되거나 다른 장르로 변하는 시스템이다.

1. **선택 적재와 capacity 8 LIFO CargoStack**
   - 무엇을 지금 싣고 무엇을 넘길지 결정한다.
   - 마지막에 실은 화물이 첫 하역 대상이 된다.

2. **자동 운행과 선행 분기 결정**
   - 열차는 멈춰 기다리지 않으며 플레이어는 경로를 미리 읽고 전환한다.
   - preview parity와 segment target lock이 계획의 신뢰성을 보장한다.

3. **색상별 station과 연속 그룹 하역**
   - stack top의 연속 동일 타입만 하역한다.
   - `Combo == unload_group_size`가 적재 순서의 결과를 직접 보상한다.

4. **생존 경제**
   - 시간 경과 속도·연료 압력, 화물 감속, 배송 연료 회복, fuel-zero 종료.
   - 더 싣고 큰 그룹을 노릴지 지금 안전하게 배달할지 만든다.

5. **BOOST 위험 교환**
   - 이동 시간을 줄이지만 연료를 더 쓴다.
   - 계획 실패를 무조건 복구하는 버튼이 아니라 제한된 전술 선택이어야 한다.

6. **compact token / rear=LIFO-top 가독성**
   - 내부 스택을 플레이어가 즉시 읽을 수 있게 만든다.
   - 표현 시스템이지만 LIFO 판단이 보이지 않으면 핵심 재미가 작동하지 않으므로 core readability system으로 취급한다.

### 3.2 보조 시스템

핵심 재미를 학습·반복·확장하지만 그 자체가 한 판의 주된 판단은 아니다.

- 상황형 첫-run onboarding과 Help
- PREP camera·FULL_MAP_READY·active full-map camera
- HUD·Unload Order·rear item·difficulty signal
- evidence-based result insight와 same-map restart
- official map discovery·reselection·minimum target3 catalog
- global/per-map personal records
- cosmetic collection·unlock·bounded cosmetic currency
- Profile single-writer transaction·save recovery
- telemetry·economy simulation·playtest evidence
- Production target100 official catalog
- Production online UGC·publication·moderation·community signals

보조 시스템은 핵심 판단을 강화해야 하며, 점수·재화·목록·콘텐츠 양으로 핵심 재미를 대체하면 안 된다.

## 4. 핵심 재미 우선순위

```text
1. LIFO 적재 순서 계획
2. 목적 역까지의 노선 선행 결정
3. 큰 그룹을 위한 위험·생존 판단
4. BOOST와 배송 속도의 전술적 시간 관리
5. 결과 학습·재도전
6. 기록·꾸미기·맵 발견·UGC
```

적대적 기준:

- 빠른 탭이나 BOOST 사용이 1~3을 이기면 방향 이탈이다.
- 단색 화물만 골라 싣는 전략이 항상 최적이면 LIFO 퍼즐이 붕괴한다.
- 메타 보상이 실제 적재·노선 판단보다 강한 재도전 이유가 되면 핵심 검증이 왜곡된다.
- 난이도 증가는 입력 정밀도보다 **의미 있는 판단 빈도와 기회비용**을 높여야 한다.

## 5. 외부 벤치마크

조사일: `2026-08-03`

| 벤치마크 | 공식적으로 확인되는 중심 | Switchy에 가져올 점 | 가져오지 않을 점 |
|---|---|---|---|
| Mini Metro | 확장되는 수요, 네트워크 설계, 결국 발생하는 실패, 짧은 Normal과 별도 Endless | 압력이 커져도 원인과 네트워크 상태가 읽혀야 함. 실패가 다음 설계 학습으로 이어져야 함 | 노선 건설 자체를 핵심으로 확대하지 않음 |
| Conduct THIS! | 단순 탭 입력, 분기 전환, 빠른 철도 액션 퍼즐, quickplay | 모바일에서 입력 수를 적게 유지하고 즉각적인 경로 피드백 제공 | 충돌 회피·반사신경을 Switchy의 주된 재미로 만들지 않음 |
| Railbound | 객차 연결과 분기·장벽을 이용한 명확한 authored rail puzzle | 화차 순서와 경로 결과의 시각적 인과관계를 명확히 함 | 정답형 고정 레벨 구조로 무한 생존을 대체하지 않음 |
| Train Valley 2 | goods 운송, 목표형 레벨, editor와 Workshop | 공식 콘텐츠와 사용자 콘텐츠를 분리하고 검증된 창작 생태계를 후속 확장 | VS 핵심 검증 전에 tycoon·산업·UGC 규모를 확장하지 않음 |
| Rail Route | 신호·분기·네트워크 확장·자동화 중심의 깊은 dispatch simulation | 복잡한 경로 상태를 권위 있는 모델로 관리하는 원칙 | 모바일 핵심에 신호·자동화·건설 관리 복잡도를 그대로 도입하지 않음 |

공식 참고:

- Mini Metro — Nintendo official product page: https://www.nintendo.com/us/store/products/mini-metro-switch/
- Conduct THIS! — Northplay official page: https://conductthis.com/this
- Railbound — Steam product page: https://store.steampowered.com/app/1967510/Railbound/
- Train Valley 2 — official page: https://store.train-valley.com/
- Rail Route — Steam product page: https://store.steampowered.com/app/1124180/Rail_Route/

### 벤치마크 결론

Switchy의 차별점은 `철도`만으로는 부족하다.

```text
Conduct THIS!의 실시간 분기 압박
+ Mini Metro의 점진적 생존 압력
+ Railbound의 화차·경로 인과 가독성
+ 고유한 선택 적재 LIFO 그룹 계획
```

위 조합에서 **LIFO 그룹 계획**이 가장 앞에 남아야 한다.

## 6. PR #37 / #38 적대적 검토

### 잘 맞는 부분

- PR #37은 `Combo == unload_result.count`를 코드·테스트에서 고정했다.
- cargo slowdown이 fuel drain을 할인하지 않아 무거운 운반의 위험이 유지된다.
- BOOST의 속도·추가 연료 비용·LOAD 배제가 분리됐다.
- cell event, run clock, difficulty event, fuel-zero 순서를 명시적으로 테스트했다.
- 실제 DeliveryLoop·CargoStack·Station 결합을 검증했다.
- PR #38은 package status와 구현 감사를 추가하고 VS03-02만 다음 권위로 승격했다.

### 발견된 누락·충돌

#### SX-AUD-007-F86 · CURRENT_CONSUMER_STATUS_DRIFT · P1

PR #38이 `START_HERE`, Active Context, Gates, Roadmap, Goal 등은 갱신했지만 다음 현재 소비자는 이전 상태를 유지한다.

- `README.md`: `9 cases / 6915 assertions`, VS03-01 only, product NOT_STARTED
- `CURRENT_CONFIRMED_DECISIONS.md`: implementation authority VS03-01, VS03-01 NOT_STARTED
- `CORE_GAMEPLAY.md`: BOOST 경제·게임오버·결과가 미구현이며 다음 Gate가 SX-DEC-017이라고 기록
- `CORE_SYSTEMS.md`: Combo와 생존 경제가 NOT_STARTED
- `VERTICAL_SLICE_CONTRACT.md`: `CODEX_NOT_READY`, GMB product code 미승인 상태
- project Skill: VS03-01 READY, product NOT_STARTED

조치: 이 PR에서 현재 상태만 동기화한다. 역사 감사 문서의 과거 상태는 변경하지 않는다.

#### SX-AUD-007-F87 · DIFFICULTY_AUTHORITY_SPLIT · P1

승인 계약은 DifficultyDirector가 escalation schedule/commit을 단독 소유한다고 명시한다.

현재 구현은:

```text
RunBalance.base_speed(elapsed)      → 30초 간격 변화
RunBalance.base_fuel_drain(elapsed) → 45초 간격 변화
DifficultyDirector                 → 30초 간격 commit
```

따라서 45초·135초 등의 fuel-pressure 변화는 DifficultyDirector commit/forecast 없이 발생한다. `authoritative prewarning`가 실제 모든 의미 있는 pressure change를 대표하지 못할 수 있다.

권장 후속:

- `VS03-01F` test-first corrective package를 VS03-05 presentation 전에 완료한다.
- DifficultyDirector가 current pressure snapshot과 다음 실제 balance boundary를 소유하거나, 모든 speed/fuel boundary를 하나의 authoritative schedule로 합친다.
- "balance 값이 바뀌었는데 forecast/commit이 없는 시각 0" 자동 테스트를 추가한다.

제품 의미를 바꾸는 새 Decision은 필요하지 않다. 승인된 authority 계약을 구현에 맞추는 수정이다.

#### SX-AUD-007-F88 · CORE_FUN_HIERARCHY_UNSTATED · P1

기존 문서는 시스템을 상세히 정의하지만 `LIFO 계획 > route > risk/tempo > meta` 우선순위를 명시하지 않는다. 이로 인해 speed bonus, BOOST, map count, records, cosmetics가 각각 국소적으로 최적화되면서 핵심 재미를 가릴 위험이 있다.

조치: Core Gameplay와 project Skill에 위계를 명시한다.

#### SX-AUD-007-F89 · MONOCOLOR_STACK_DEGENERACY · P1 EVIDENCE GAP

LOAD가 완전 선택형이므로 플레이어가 같은 색만 골라 싣고 즉시 같은 역으로 배달하는 방식이 대부분의 상황에서 우월하면 mixed-stack LIFO 고민이 사라진다.

필수 측정:

- loaded stack 중 2색 이상 비율
- delivery 직전 stack entropy 또는 distinct-type count
- mono-color delivery 비율
- blocked/mismatched cargo를 의도적으로 보유한 시간
- Combo 1/2/3/4/5+ 분포
- 점수 중 group-size base / speed / heavy bonus 비중

판정 목표는 특정 수치를 즉시 확정하는 것이 아니라, 일반 플레이에서 mixed stack과 미래 하역 순서 계획이 실제로 발생하는지 확인하는 것이다.

#### SX-AUD-007-F90 · LANDSCAPE_ONE_HAND_REACH_CONFLICT · P1 UX

현재 타깃 표현의 `한 손 중심 가로형 플레이`는 15×10 전체 맵의 분기 탭과 별도 LOAD/BOOST를 물리적으로 한 손으로 조작한다는 뜻으로 읽힐 수 있다.

권장 정의:

```text
single-pointer friendly
+ simultaneous chord input 불필요
+ 양손으로 기기를 잡아도 한 번에 한 입력만 요구
```

실기기에서 full-map switch reach와 LOAD/BOOST 배치를 별도로 검증한다.

#### SX-AUD-007-F91 · META_BEFORE_PLAYABLE_SURFACE · P1 EXECUTION RISK

현재 순서는 target3 이후 Profile/records/cosmetics를 먼저 만들고 product Scene/HUD를 뒤에 둔다. 구조적 의존성은 이해되지만, 실제 플레이 가능한 core surface 확인이 늦어져 핵심 재미가 약한 상태에서 meta를 먼저 완성할 위험이 있다.

권장안:

- VS03-02와 VS03-03 이후 `minimal playable core surface`를 먼저 증명하거나,
- VS03-05를 `05A core play surface`와 `05B result/browser presentation`으로 분리해 05A를 Profile보다 앞당긴다.

이 변경은 package ownership 재검토가 필요하므로 이 PR에서는 확정하지 않고 사용자 검토 대상으로 남긴다.

#### SX-AUD-007-F92 · COMPACT_TOKEN_READABILITY · P1 EVIDENCE GAP

8개 token을 2.18 cell 안에 압축하면서 active camera는 fixed full map이다. 작은 Android 화면에서 색+모양을 개별 식별하지 못하면 LIFO core가 내부적으로 맞아도 플레이어에게는 보이지 않는다.

VS03-02에서 반드시 확인:

- 0/1/4/8 token 식별
- rear token 즉시 판별
- curve/switch에서 order 보존
- HUD unload order와 world token parity
- 140% localization과 safe-area 동시 상태
- 최소 지원 해상도에서 shape 식별 크기

#### SX-AUD-007-F93 · GRILLME_BENCHMARK_INPUT_MISSING · P2 PROCESS

기존 Grill Me 형식은 내부 장단점과 권장안을 제공하지만 외부 비교가 의무 입력이 아니다.

조치: project Skill에 Benchmark-backed Grill Me 규칙을 추가한다.

## 7. 수치 적대적 검토

현재 `TEST_VALUE`에서 Combo base score의 화물 1개당 값은 다음처럼 증가한다.

```text
Combo1: 100 / cargo
Combo2: 130 / cargo
Combo3: 180 / cargo
Combo4: 240 / cargo
Combo5+: 300 / cargo
```

따라서 큰 LIFO 그룹을 직접 보상하는 방향은 적합하다.

다만 speed 1.25×와 heavy 1.15×가 동시에 적용되면 최대 1.4375×이므로, core 판단보다 시간 보너스가 앞서는지 실제 플레이에서 분리 측정해야 한다.

권장 guardrail:

- 플레이어가 설명하는 성공 원인이 `빠르게 눌렀다`가 아니라 `순서를 만들고 경로를 준비했다`여야 한다.
- speed bonus는 large-group 선택을 역전시키지 않아야 한다.
- BOOST 상시 사용이 생존·점수 모두의 지배 전략이면 안 된다.
- heavy bonus를 받기 위해 무관한 화물을 계속 들고 다니는 exploit이 지배적이면 안 된다.

수치 변경은 `TEST_VALUE` 재보정이며 위 의미를 유지하는 한 새 Decision이 아니다.

## 8. 앞으로의 Benchmark-backed Grill Me 규칙

중요 player-facing 선택 또는 구현 순서 변경을 질문할 때 다음을 포함한다.

1. **가까운 벤치마크 1개 이상**
   - 같은 장르·입력·플랫폼·세션 구조.
2. **인접 벤치마크 1개 이상**
   - 다른 장르지만 같은 문제를 잘 푼 사례.
3. **비교 축**
   - 핵심 목표, 조작 밀도, 인지 부하, 실패 방식, 세션 길이, 반복 동기, 접근성, meta/monetization 영향.
4. **복사 금지 설명**
   - 무엇을 참고하고 무엇을 프로젝트 정체성 때문에 채택하지 않는지.
5. **옵션별 현업 관점**
   - 업계에서 흔한 기본안, Switchy 적합성, 제작 비용, 주요 실패 위험.
6. **권장안**
   - 핵심 재미 위계와 현재 증거에 가장 맞는 안.
7. **적대적 반론**
   - 권장안이 실패할 가장 강한 이유.
8. **검증 방법**
   - 자동 테스트, simulation, device test, human test 중 어떤 증거로 닫을지.

단순 유명 게임 나열이나 feature checklist는 벤치마킹으로 인정하지 않는다.

## 9. 최종 판정

### 방향 판정

`KEEP_AND_SHARPEN`.

- 철도 분기, 선택 적재, LIFO 그룹 하역, 생존 압력의 결합은 차별성이 있다.
- core를 버리거나 새로운 대형 시스템을 추가할 이유는 없다.
- 가장 중요한 개선은 **LIFO 계획을 최상위 재미로 명문화하고 실제 플레이에서 혼합 스택·선행 경로 계획이 발생하는지 증명하는 것**이다.

### 즉시 조치

- current consumer status drift 수정
- project Skill에 benchmark-backed Grill Me 규칙 추가
- VS03-02 acceptance에 compact readability·mixed-stack evidence hook 유지
- Difficulty authority split을 별도 corrective package 후보로 등록

### 사용자 검토가 필요한 실행 구조 제안

- minimal playable core surface를 Profile/meta보다 앞당길지 여부

이 항목은 제품 규칙 Decision이 아니라 package sequencing 선택이지만, 공통 hotspot과 검증 시점에 영향을 주므로 별도 검토 후 반영한다.
