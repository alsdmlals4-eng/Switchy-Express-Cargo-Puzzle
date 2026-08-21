# First Session Localization Copy Matrix V1

```yaml
owner_decision: SX-DEC-059
status: COPY_RUNTIME_IMPLEMENTED · FOUR_LOCALES_VALIDATED
source_language: ko
planned_languages: [ko, en, ja, zh-Hans]
exact_zh_locale: zh-Hans
zh_hant: DEFER_UNTIL_RELEASE_TARGET_REQUIRES
text_in_png: FORBIDDEN
```

## 원칙

- 플레이로 먼저 가르치고 문구는 행동/의미를 보조한다.
- modal rules page를 첫 세션 필수 경로로 만들지 않는다.
- 한 시점에 tutorial cue 1개만 노출한다.
- objective는 2줄 이내, contextual cue는 1줄 이내를 목표로 한다.
- 정답 경로/정답 분기/최적 적재 순서를 직접 말하지 않는다.
- 번역은 literal word-for-word가 아니라 동일 행동 의미와 정보량을 유지한다.
- 첫 release-near Slice의 중국어 locale은 현재 문안과 일치하는 `zh-Hans`로 고정한다.
- `zh-Hant`는 출시 대상 지역/스토어 localization profile이 요구할 때 별도 추가하며 현재 지원으로 과장하지 않는다.

## Core copy

| Key | Context | KO | EN | JA | ZH-Hans |
|---|---|---|---|---|---|
| `SX_FS_START` | Title CTA | 첫 배송 시작 | Start First Delivery | 最初の配送を始める | 开始首次配送 |
| `SX_T1_TITLE` | Lesson title | 선로 연결 | Connect the Route | 線路をつなぐ | 连接轨道 |
| `SX_T1_OBJECTIVE` | Lesson objective | 표시된 지점이 모두 이어지도록 선로를 연결하세요. | Connect the route so every marked point is reachable. | すべての目印がつながるように線路を敷いてください。 | 铺设轨道，让所有标记点都能连通。 |
| `SX_T1_READY` | Preflight pass | 노선이 연결되었습니다. 이제 운행해 봅시다. | Route connected. Now run the train. | 線路がつながりました。列車を走らせましょう。 | 线路已连通。现在让列车出发。 |
| `SX_T2_TITLE` | Lesson title | 화물을 역으로 | Deliver the Cargo | 貨物を駅へ | 将货物送到车站 |
| `SX_T2_OBJECTIVE` | Objective | 화물을 싣고 같은 표시의 역까지 운반하세요. | Pick up the cargo and carry it to the matching station. | 貨物を積み、同じ目印の駅まで運んでください。 | 装载货物，并运到相同标记的车站。 |
| `SX_T2_LOAD_CUE` | Just-in-time action | **적재**를 누른 채 화물을 지나가세요. | Hold **Load** as you pass the cargo. | 貨物を通るとき **積載** を押し続けてください。 | 经过货物时按住 **装载**。 |
| `SX_T2_UNLOAD_NOTE` | First unload confirmation | TOP이 역과 같으면 자동으로 내립니다. | Cargo unloads automatically when the TOP matches the station. | TOPが駅と一致すると自動で荷下ろしします。 | TOP与车站匹配时会自动卸货。 |
| `SX_T3_TITLE` | Lesson title | 마지막 화물부터 | Last In, First Out | 最後に積んだ貨物から | 后装先卸 |
| `SX_T3_OBJECTIVE` | Objective | 먼저 내릴 화물이 TOP에 오도록 적재 순서를 계획하세요. | Plan the load order so the cargo you need first is on TOP. | 先に降ろす貨物がTOPになるよう積載順を考えてください。 | 规划装载顺序，让先要卸下的货物位于TOP。 |
| `SX_T3_TOP_RULE` | Contextual rule | 마지막에 실은 화물이 **TOP**입니다. | The last cargo loaded becomes **TOP**. | 最後に積んだ貨物が **TOP** です。 | 最后装载的货物位于 **TOP**。 |
| `SX_T4_TITLE` | Lesson title | 지금 안 싣는 선택 | Skip Now, Load Later | 今は積まない選択 | 现在先不装 |
| `SX_T4_OBJECTIVE` | Objective | 모든 화물을 처음 만났을 때 실을 필요는 없습니다. | You do not have to load every cargo the first time you meet it. | すべての貨物を最初に出会ったとき積む必要はありません。 | 第一次遇到货物时，不必全部装载。 |
| `SX_T4_SKIP_CUE` | Hint tier 1 | 지금 싣지 않는 것도 계획입니다. | Choosing not to load now is also part of the plan. | 今は積まないことも作戦です。 | 现在不装载也是计划的一部分。 |
| `SX_T4_REVISIT_CUE` | Hint tier 2 | 지나친 화물은 다시 돌아와 실을 수 있습니다. | Cargo you skip stays there for a later visit. | 見送った貨物は後で戻って積めます。 | 跳过的货物会留在原地，之后可以回来装载。 |
| `SX_T5_TITLE` | Lesson title | 자동 적재 전환 | Switch Auto Load | 自動積載を切り替える | 切换自动装载 |
| `SX_T5_OBJECTIVE` | Objective | 모두 실어도 안전한 구간에서는 자동 적재를 활용하세요. | Use Auto Load where picking up everything is safe. | 全部積んでも問題ない区間では自動積載を使いましょう。 | 在全部装载也安全的路段使用自动装载。 |
| `SX_T5_AUTO_ON` | State cue | 자동 적재 켬 · 지나가는 화물을 모두 싣습니다. | Auto Load ON · all contacted cargo will be loaded. | 自動積載 ON · 接触した貨物をすべて積みます。 | 自动装载开启 · 会装载经过的所有货物。 |
| `SX_T5_AUTO_OFF_HINT` | Decision cue | 선택이 필요한 구간에서는 자동 적재를 끌 수 있습니다. | Turn Auto Load off when you need to choose what to pick up. | 選んで積みたい区間では自動積載をOFFにできます。 | 需要选择货物时可以关闭自动装载。 |
| `SX_T6_TITLE` | Lesson title | 분기로 경로 선택 | Choose with Switches | 分岐で進路を選ぶ | 用道岔选择路线 |
| `SX_T6_OBJECTIVE` | Objective | 열차가 오기 전에 분기를 바꿔 배송 경로를 선택하세요. | Set the switch before the train arrives to choose the delivery route. | 列車が来る前に分岐を切り替え、配送経路を選んでください。 | 列车到达前切换道岔，选择配送路线。 |
| `SX_T6_PRESET_CUE` | Contextual cue | 열차가 오기 전에 분기 방향을 미리 바꿀 수 있습니다. | You can set the switch before the train arrives. | 列車が来る前に分岐を切り替えられます。 | 列车到达前就可以切换道岔。 |
| `SX_T6_LOCK_CUE` | Occupied state | 열차가 분기 위에 있는 동안에는 변경할 수 없습니다. | The switch is locked while the train is on it. | 列車が分岐上にいる間は切り替えられません。 | 列车位于道岔上时无法切换。 |
| `SX_CAPSTONE_TITLE` | Capstone | 종합 배송 | Full Delivery | 総合配送 | 综合配送 |
| `SX_CAPSTONE_OBJECTIVE` | Objective | 선로·적재·TOP·분기를 이용해 모든 화물을 배송하세요. | Use routes, loading, TOP, and switches to deliver every cargo. | 線路・積載・TOP・分岐を使ってすべての貨物を配送してください。 | 运用轨道、装载、TOP和道岔完成全部配送。 |

## Result copy

| Key | KO | EN | JA | ZH-Hans |
|---|---|---|---|---|
| `SX_RESULT_SUCCESS` | 배송 완료 | Delivery Complete | 配送完了 | 配送完成 |
| `SX_RESULT_ROUTE_END` | 노선이 끝났습니다. | The route ended. | 線路が途切れました。 | 路线已到尽头。 |
| `SX_RESULT_TIME_EXPIRED` | 시간이 끝났습니다. | Time expired. | 時間切れです。 | 时间已到。 |
| `SX_RESULT_MAP_CARGO` | 맵에 남은 화물: {count} | Cargo left on map: {count} | マップに残った貨物: {count} | 地图剩余货物：{count} |
| `SX_RESULT_STACK_CARGO` | 열차에 실린 화물: {count} | Cargo on train: {count} | 列車上の貨物: {count} | 列车上的货物：{count} |
| `SX_RESULT_RETRY` | 같은 노선 다시 실행 | Retry Same Route | 同じ線路で再実行 | 按相同线路重试 |
| `SX_RESULT_EDIT` | 노선 수정 | Edit Route | 線路を修正 | 修改线路 |
| `SX_RESULT_OTHER_SOLUTION` | 다른 방법으로도 풀 수 있습니다. | There may be another way to solve it. | 別の解き方もあります。 | 还可以尝试其他解法。 |

## Hint policy

### Tier 0 · No hint

기본 상태. Objective와 실제 semantic feedback만 제공.

### Tier 1 · Principle hint

문제를 푸는 원리만 말하고 위치/정답은 말하지 않는다.

예:
- T3 `마지막에 실은 화물이 TOP입니다.`
- T4 `지금 싣지 않는 것도 계획입니다.`

### Tier 2 · Action direction

반복 실패 또는 요청 시 행동 방향을 말한다.

예:
- T4 `지나친 화물은 다시 돌아와 실을 수 있습니다.`
- T6 `열차가 오기 전에 분기 방향을 미리 바꿀 수 있습니다.`

### 금지 Hint

- 정확한 track cell list
- exact load sequence
- exact switch timing/sequence
- optimal route/recommended layout 자동 표시

## Translation QA

BUILD/QA에서 최소 확인:

- key missing fallback이 player-facing raw key로 노출되지 않음.
- bold/control term이 locale별 같은 기능을 지칭.
- ko/en/ja/zh-Hans에서 버튼 label이 touch target을 넘지 않음.
- line wrap으로 cargo/stack/switch 상태를 가리지 않음.
- `TOP`은 네 언어 모두 동일 시스템 용어로 유지하되 첫 등장에 의미 설명.
- `zh-Hant`는 현재 지원으로 표시하지 않으며, 출시 localization profile이 요구할 때 별도 검증 후 추가한다.
