# Route Book 01 · 유사 장르 12개 게임 벤치마킹 및 역공학

**Date:** 2026-08-30 KST
**Decision linkage:** `SX-DEC-066 · Curated Route Book 01`
**Status:** `RESEARCHED · IMPLEMENTATION_NOT_STARTED`
**Method:** 개발사·퍼블리셔의 공식 사이트/위키 또는 해당 제품의 공개 스토어 설명만을 대상으로 한 공개 정보 역공학

## 이 조사가 답하는 질문

첫 세션 `T1→T6→VS_DEMO_01`과 이미 고정된 finite delivery 규칙을 바꾸지 않고, 여섯 개의 선택형 고정 스테이지를 제공하는 것이 철도·경로 퍼즐 장르의 강점은 살리되 Switchy Express의 범위를 침범하지 않는가를 검증한다.

이 문서는 공개된 제품 설명에서 추론한 설계 비교다. 비교 제품을 직접 플레이해 완주하거나 UX/사용자 검수를 수행했다는 주장, Route Book의 runtime 검증, 또는 타 제품의 문구·자산·레벨 구조를 복제한다는 허가는 아니다.

## 비교 기준선

현재 Switchy Express의 변경 불가 기준은 다음과 같다.

- `FiniteMapDefinition v3`의 수제 유한 맵, free rail build와 full refund.
- 화물은 같은 셀에서 Manual/Auto 접촉으로 적재하고, 역은 정확히 한 칸 상·하·좌·우에서만 서비스한다. 대각선과 역 발자국은 실패다.
- 무제한 LIFO, 같은 색·형태·텍스트의 TOP 묶음만 하역, 직접 분기 선택과 점유 중 lock.
- Start에서 도달 가능한 RUN 컴포넌트 preflight, 시간 실패, 사실 기반 Result의 Retry/Edit.
- 첫 세션과 `VS_DEMO_01`은 그대로 보존한다. 점수·별·보상·경제·저장·잠금·생성·에디터·UGC·네트워크·새 코어 규칙은 제외한다.
- 검증은 machine-primary이며 최종 사용자 검수는 별도 최종 게이트다. 다인 이해도 또는 플레이 경험 조사는 acceptance gate가 아니다.

## 12개 비교 제품과 역공학 결과

| 비교 제품 | 공식 공개 loop / 시스템 | Switchy에 적용할 교훈 | 결론 |
| --- | --- | --- | --- |
| [Train Valley 2](https://store.train-valley.com/) | Company Mode의 다수 레벨, 철도 퍼즐과 물류·기관차 업그레이드·Workshop 결합 | 작은 수제 맵 묶음은 유효하지만 타이쿤·업그레이드·화물 경제·Workshop은 별도 게임층이다. | **ADAPT** 수제 스테이지 묶음 / **REJECT** 경제·업그레이드·UGC |
| [Rail Route](https://wiki.railroute.eu/) | 건설·운영·자동화·Timetable·Rush Hour·Endless와 맵 에디터를 포괄 | 경로 상태와 직접 조작의 가독성은 참고하되, 무한 운영과 자동화 시스템은 유한 퍼즐의 의도를 흐린다. | **ADAPT** 상태 가시성 / **REJECT** timetable·automation·editor·확장 |
| [Station to Station](https://store.steampowered.com/app/2272400/Station_to_Station/) | 역을 놓고 연결해 세계를 성장시키는 편안한 voxel 철도 퍼즐, 점수·보너스·바이옴·에디터 포함 | 결과가 실제 보드의 생동감으로 이어지는 miniature-diorama 감성은 현존 presentation에서만 보강할 수 있다. | **ADAPT** 차분한 보드 피드백 / **REJECT** 성장·점수·biome·editor |
| [Mini Metro](https://minimetro.radialgames.com/) | 제한된 노선과 빠르게 성장하는 도시, 대기열/과부하, normal·endless·extreme | 정보는 단순하고 중복되게 보여야 하지만, 동적 성장·무한 압박·업그레이드는 이 프로젝트의 수제 유한 맵과 맞지 않는다. | **ADAPT** 명료한 상태 표현 / **REJECT** random growth·endless·upgrade |
| [Railgrade](https://railgrade.com/) | 생산입력과 다단 네트워크로 자원을 운송하며 투자·업그레이드하는 산업 운영 | 출발지에서 목적지까지의 원인이 보이는 흐름은 유지하되, 생산 체인·경제·다층 확장은 추가 규칙이 된다. | **ADOPT** 출발-도착 인과성 / **REJECT** 생산·투자·다층 경제 |
| [Unrailed!](https://unrailed-game.com/) | 협동 실시간 채굴·제작·선로 연장, 절차 생성과 영구 업그레이드 | 시간이 존재해도 survival/roguelite 압박으로 바꾸지 말아야 한다는 경계 사례다. | **REJECT** 협동·채굴·절차 생성·roguelite·영구 성장 |
| [Teeny Tiny Trains](https://store.steampowered.com/app/2825600/Teeny_Tiny_Trains/) | 짧은 수제 brain teaser, 선로 배치·분기·splitter·bridge, toy-diorama 톤 | 한 스테이지에 하나의 명명 가능한 판단을 두고 보드 규모를 작게 유지하는 방식이 적합하다. | **ADOPT** 단일 핵심 판단·수제 diorama / **REJECT** editor·수집·꾸미기 |
| [Railway Islands](https://www.qubyteinteractive.com/games/Railway-Islands/) | 안전한 경로를 만들고 모든 자원을 전달하는 미니멀 철도 퍼즐 | 목표와 실패 조건을 숨기지 않고, 완료가 실제 delivery로 관측돼야 한다. | **ADOPT** 투명한 delivery 목표와 witness |
| [Trainyard](https://trainyard.ca/) | 색상 매칭 선로 퍼즐, 난이도 곡선, 다수 해법, 색각 보조 | 해답을 강요하지 않는 테스트 가능한 다해법과 색 외 정보 중복은 적합하다. | **ADOPT** 다해법 허용·color+shape+text / **REJECT** 색 혼합·공유 해답 |
| [Railbound](https://afterburn.games/press/sheet.php?p=railbound) | 기차를 목적지로 이끄는 240개 이상 track-bending 퍼즐, 한 레벨의 한 기계적 상호작용에 집중 | 여섯 장을 모두 직접 선택하게 하고 각 장의 중심 판단을 명시하는 방식이 적합하다. | **ADOPT** 선택형 authored puzzle / **REJECT** rail bending·global unlock |
| [Tracks](https://store.steampowered.com/app/657240/Tracks/) | 장난감 기차 sandbox, 도시 꾸미기, 1인칭 주행, 다양한 물체와 여러 열차 | 친근한 모형 철도 감성만 현재 승인된 E+D Hybrid 자산으로 유지한다. | **ADAPT** 촉각적 diorama 정서 / **REJECT** sandbox·꾸미기·1인칭·다중 열차 |
| [Rail Island](https://www.railisland.com/) | 자유 지형·도로·다리·터널·차량·동적 도시, 튜토리얼과 저장/공개 island | BUILD 뒤 RUN에서 선택 결과를 관찰하는 감각만 유지하고, 자유형 세계 제작은 도입하지 않는다. | **ADAPT** build→observe 피드백 / **REJECT** terrain·city growth·save/publish |

## 반복적으로 확인된 설계 패턴

### 1. authored map은 유지하고, progression system은 분리한다

Train Valley 2, Teeny Tiny Trains, Railway Islands, Trainyard, Railbound는 크기와 목적은 달라도 사람이 만든 퍼즐 단위가 독립적인 판단을 가질 때 강점을 보인다. 반면 Rail Route, Station to Station, Unrailed!, Tracks, Rail Island는 네트워크 확장·샌드박스·성장·생성형 세계를 별도 핵심 loop로 사용한다.

따라서 Route Book은 **고정된 여섯 장을 처음부터 모두 선택 가능하게 하는 수제 콘텐츠 표면**으로만 채택한다. 잠금 해제, 별, 랭크, 저장된 진척, 랜덤 맵, 레벨 에디터는 거부한다. 이 선택은 콘텐츠가 부족해서 만든 progression wrapper가 아니라, 기존 유한 규칙을 더 깊게 연습할 수 있는 선택지다.

### 2. 시간은 사실 기반 실패 조건으로만 남긴다

Mini Metro와 Unrailed!는 시간 압박을 핵심 운영/생존 loop로 확장한다. Switchy에는 이미 시간 실패가 있지만, Route Book의 목적은 역 인접 서비스·LIFO·재방문·Auto 창·분기 lock을 정확히 판별하는 것이다.

따라서 기존 시간 실패와 Retry/Edit는 재사용하되, 화물 재생성, 자원 채집, fuel, 영구 업그레이드, 웨이브, endless 운영으로 변형하지 않는다.

### 3. 가독성은 시각적 보상보다 판독 가능한 인과성이다

Mini Metro의 정보 단순화, Railway Islands의 명확한 안전/전달 목표, Trainyard의 색각 보조는 공통으로 “무엇이 일어났고 왜 실패했는가”를 먼저 보이게 한다. Station to Station과 Tracks의 diorama 매력은 그 다음 층이다.

Switchy는 이미 `color + shape + text` 중복 표기를 기준선으로 채택했다. Route Book은 새 이미지나 별도 보상 화면을 만들지 않고, 기존 board/HUD/result에서 다음을 명료하게 한다.

- 각 카드의 stage 이름과 단 하나의 핵심 판단
- 현재 맵에서 운송해야 할 화물과 서비스해야 할 역
- 성공 witness와 실패 반례를 machine test로 관측 가능한 상태
- Route Book에서만 보이는 Stage Book / Next Stage와, 기존 Retry / Edit의 구분

### 4. 선택권은 “정답 보기”가 아니라 “다음 퍼즐 선택”으로 준다

Trainyard의 다해법, Railbound의 level skip/선택, 수제 퍼즐 장르의 재시도는 플레이어 선택을 지원한다. 하지만 그 선택은 자동 해법 노출과 다르다.

따라서 여섯 stage card는 직접 선택할 수 있으며 `RECOMMENDED_LAYOUT`은 숨긴다. Build에서 자유롭게 시도하고, Result에서는 같은 레이아웃 Retry 또는 Edit를 사용한다. 순위·perfect route·optimal solver·추천 배치는 추가하지 않는다.

## 다섯 번의 적대적 검토 기록

| Loop | 공격한 위험 | 확인 및 수정 결과 |
| --- | --- | --- |
| 1. 소비처·범위 | Route Book이 T1–T6 또는 `VS_DEMO_01`을 사실상 새 튜토리얼/대체 경로로 만들 위험 | 결정과 계획을 다시 대조했다. 별도 Title → Stage Book 진입만 허용하고, 기존 Title Start와 standalone demo는 기존 경로를 유지하는 scene-flow regression을 요구한다. |
| 2. 출처·권리 | 공개 스토어를 개발사 1차 자료라고 과장하거나, 비교 게임의 텍스트·자산·레벨을 그대로 가져올 위험 | 출처의 표현을 “공식 사이트/위키 또는 공개 스토어 설명”으로 좁혔다. 모든 art/audio/copy/map은 참조 대상이 아니며, 현재 프로젝트의 기존 consumer와 고유 수제 맵만 사용한다. |
| 3. 구현 가능성 | 외부 사례를 이유로 새 시스템이 숨어 들어오거나 실제 Godot seam이 없을 위험 | `FiniteMapLoader`, `FiniteBuildSession`, `FiniteRunSessionFactory`, `ProductFiniteSlice`, `FirstSessionStagePolicy`, `DemoFlowController`의 기존 소비 경계를 계획과 다시 대조했다. 새 plugin, schema, asset slot, service 의존성은 없다. |
| 4. 판독성·UX drift | miniature-diorama 분위기를 이유로 정보가 흐려지거나, 점수/보상 UI가 생길 위험 | 카드에는 이름과 한 가지 판단만, board/HUD에는 기존 color+shape+text 중복만 사용한다. 신규 이미지·보상 화면·추천 해법을 명시적으로 배제했다. |
| 5. 증거 과장 | 장르 비교를 runtime, package, physical, 사용자 검수 또는 acceptance PASS로 오인할 위험 | 문서 상태를 `RESEARCHED · IMPLEMENTATION_NOT_STARTED`로 유지하고, 공개 정보 조사와 제품 검증을 분리했다. 변경 바이트가 생긴 뒤에만 새 machine regression/candidate 절차를 시작한다. |

다섯 loop에서 확인된 범위·출처 표현·소비처·판독성·증거 경계의 문제를 이 문서와 연결된 결정/계획의 명시적 금지 조건으로 교정했다. 남은 증거는 실제 Route Book Godot 구현 이후에만 생성할 수 있다.

## Switchy Express 적용 판정

### ADOPT

- `RB01`~`RB06`을 제목 화면의 Stage Book에서 모두 직접 선택할 수 있게 한다.
- 각 스테이지는 한 가지 이름 붙은 중심 판단과 최소 하나의 성공 witness/실패 반례를 가진다.
- 기존 finite map/briefing/BUILD/RUN/result 소비처를 재사용한다.
- 첫 세션과 독립된 선택형 추가 콘텐츠로 두며, multiple valid solution을 허용한다.
- 목표·화물·역 정보는 color+shape+text 중복 식별과 factual result 경계를 유지한다.

### ADAPT

- Station to Station·Teeny Tiny Trains·Tracks의 miniature-diorama 정서는 기존 E+D Hybrid / Neo-Arcade 제품 자산과 board-first presentation 안에서만 활용한다. 새 bitmap·audio·VFX는 만들지 않는다.
- Rail Route의 조작 상태 가시성과 Mini Metro의 단순한 정보 계층은 현존 route-control/HUD 문법을 더 흐리지 않는 방향으로만 적용한다.
- Rail Island의 build→observe 순서는 현재 Build/Run 흐름으로 한정한다.

### REJECT

- tycoon, 생산 체인, 투자, 화폐, 업그레이드, 점수, 별, 랭크, 보상, 잠금 해제, 저장 진척
- dynamic city growth, endless/survival, roguelite, 자원 채굴/제작, 화물 재생성
- procedural maps, level editor, UGC, sandbox, 소셜 해답 공유, 공개 island, 네트워크 기능
- 다중 열차, 자유 지형/도로/다리/터널 시스템, 1인칭 주행, 새 코어 역/화물/선로 규칙
- machine-primary 정책을 대체하는 다인 이해도 또는 플레이 경험 검증 gate

## 구현 계획에 주는 직접 영향

이 조사 결과는 이미 작성된 여섯 ID와 맵별 판단을 바꾸지 않는다. 구현 순서에는 아래의 명시적 보호를 추가한다.

1. `RouteBookDefinition` 검증은 정확히 여섯 ID·직접 선택·비영속·`RECOMMENDED_LAYOUT` 부재를 실패 우선으로 검사한다.
2. `RouteBookDirector`는 잠금/별/저장/추천 해법 상태를 소유하지 않는다.
3. 각 맵 fixture는 해당 stage의 중심 판단을 지키는 성공 witness와 실패 반례를 모두 제공한다.
4. scene-flow test는 기존 Title Start가 계속 T1을, standalone demo가 계속 `VS_DEMO_01`을 여는지 확인한다.
5. 변경된 제품 바이트에 대해서만 새 machine regression·CI/package·candidate 절차를 시작하며, 기존 Candidate 005의 증거를 Route Book에 전이하지 않는다.

## 조사 한계와 다음 증거

공개 정보에서 12개 제품의 loop와 범위 경계를 비교했지만, 타 게임의 실제 조작 감각이나 이용자 반응을 판정하지 않았다. 또한 이 조사는 Route Book 구현의 runtime, package, physical, audio, device, final-user 검증을 대체하지 않는다.

조사 범위는 충분히 닫혔다. 수제 철도 퍼즐, 운영/자동화, 도시 성장, 산업 물류, 협동 survival, toy-diorama, 미니멀 delivery, 색상 퍼즐, sandbox, 자유 지형 모델을 모두 포함했고, 이후의 유효한 증거는 추가 장르 소개가 아니라 실제 Switchy Godot consumer 경계의 RED→GREEN 구현과 machine 검증이다.

## 출처 원장

모든 항목은 2026-08-30에 확인한 공개 개발사/퍼블리셔 사이트, 공식 위키 또는 제품 스토어 페이지다. Railgrade 공식 페이지는 이 환경에서 직접 열람 시간이 초과했고, Railbound press kit은 검색으로 확인했으나 본문 직접 열람이 제한됐다. 두 항목은 이 접근 한계를 전제로, 이미 확인된 제품 범주·루프 외의 세부 사실을 근거로 사용하지 않는다.

1. [Train Valley 공식 제품 사이트](https://store.train-valley.com/)
2. [Rail Route 공식 위키](https://wiki.railroute.eu/)
3. [Station to Station Steam 제품 페이지](https://store.steampowered.com/app/2272400/Station_to_Station/)
4. [Mini Metro 공식 사이트](https://minimetro.radialgames.com/)
5. [Railgrade 공식 사이트](https://railgrade.com/)
6. [Unrailed! 공식 사이트](https://unrailed-game.com/)
7. [Teeny Tiny Trains Steam 제품 페이지](https://store.steampowered.com/app/2825600/Teeny_Tiny_Trains/)
8. [Railway Islands 퍼블리셔 공식 페이지](https://www.qubyteinteractive.com/games/Railway-Islands/)
9. [Trainyard 개발사 공식 사이트](https://trainyard.ca/)
10. [Railbound 개발사 press kit](https://afterburn.games/press/sheet.php?p=railbound)
11. [Tracks Steam 제품 페이지](https://store.steampowered.com/app/657240/Tracks/)
12. [Rail Island 공식 사이트](https://www.railisland.com/)
