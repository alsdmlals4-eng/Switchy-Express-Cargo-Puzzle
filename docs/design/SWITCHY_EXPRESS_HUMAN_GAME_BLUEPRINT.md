# Switchy Express · Human Game Blueprint Editorial Source

> **Document ID:** `SX-HGB-001`
> **Pair / revision:** `SX-HGB-001 · r04 · 2026-09-01`
> **Role:** 사람용 경험 검수 PDF를 위한 편집 원본이다. 게임 규칙·데이터·테스트의 정본은 아래 upstream owner가 계속 소유한다.
> **Status:** `r04 machine flow/owner/render validation and final document content, copy, and visual review complete` — 이 문서는 새 게임 기능이나 런타임 구현 권한을 만들지 않는다.

## Purpose and upstream authority

이 원본은 처음 보는 사람이 Switchy Express의 약속, 화면 여정, 반복 판단, 성공·실패 뒤의 다음 행동을 설명할 수 있도록 하는 사람용 PDF의 편집 입력이다. 구현 세부사항을 재정의하지 않고, 다음 정본의 사람용 표현만 구성한다.

- 제품 기준선과 승인 규칙: `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`, `CURRENT_CONFIRMED_DECISIONS.md`
- 현재 상태와 증거 경계: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`, `DEVELOPMENT_GATES.md`
- AI·구현 명세: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- 시각 언어와 실제 자산 소비자: `기획서/40_표현/VISUAL_DIRECTION.md`, `TARGET_BUILD_SCREEN_SURFACE_AND_VISUAL_COVERAGE.md`, `art/product_assets/ed_hybrid_v2/manifest.json`
- Route Book 02/주의 구간/폐기 화물: `docs/decisions/SX_DEC_067_WAYSIDE_HAZARDS_SALVAGE_AND_ROUTE_BOOK_02.md`, `SX_DEC_069_TRANSPARENT_WAYSIDE_AND_SPEED_TRANSITIONS.md`
- 승인된 제목 정체성: `docs/decisions/SX_DEC_068_TITLE_SCREEN_MAIN_SHELL.md`, `SX-TITLE-WORDMARK-001`
- 현행 기준 SHA: `origin/main@0bf5e2150d643210abf127e34880111ee986b29d`

## Editorial and visual boundary

- `실제 런타임 자산`은 현재 프로젝트에서 실제 소비되는 지형·셸·토큰 이미지다.
- `구현 기준선 도식`은 현재 맵과 규칙을 사람이 이해하도록 재배열한 문서 도형이다. 실제 화면 캡처나 사용성 증거가 아니다.
- `SX-HGB-VIS-001~004`는 r02에서 사용자 승인된 **문서 전용 시각 후보**다. PDF에서는 메인·BUILD·RUN·선로/역 언어를 읽게 하지만, 런타임 자산·스프라이트시트·Godot 소비자가 아니다.
- `SX-TITLE-WORDMARK-001`은 `TitleScreen/…/TitleLogo`의 승인된 실제 런타임 입력이며, r04에서는 문서 표지의 기존 자산 입력으로만 재사용한다. 픽셀을 재생성하거나 변경하지 않는다.
- Route Book 02의 v02 노변·주의·폐기장 후보는 런타임에 연결되었지만 `USER_PIXEL_REVIEW_PENDING`이다. r04는 이 상태를 설명할 뿐, 승인·정본 승격·출시 증거로 바꾸지 않는다.
- 시스템 플로우용 `SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002B`는 기존 사용자 승인 planning reference를 재사용한다. 이 역시 실제 런타임 캡처가 아니다.
- Windows 물리 화면·오디오, Android와 최종 사용자 검수는 이 발행본과 별도다. 다인 이해도·플레이 경험 연구는 현재 machine-primary 정책상 acceptance gate가 아니다.
- 기존 `exports/switchy-express-cargo-puzzle_MASTER_PRODUCTION_GDD_20260828.pdf`와 r02/r03 PDF는 이전 기준의 파생 검수본으로 보존한다. r04는 SX-DEC-069 및 Candidate 010의 현재 증거 경계 위에서, 독립 화면·게임플레이 플로우맵과 공간 와이어프레임을 보강한 새 human blueprint이다.

## Publication contract

```yaml
blueprint_pair_id: SX-HGB-001
revision: r04
source_main: 0bf5e2150d643210abf127e34880111ee986b29d
output_pdf: output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260901_r04.pdf
publication_manifest: docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT_PUBLICATION_MANIFEST.json
generator: tools/build_human_game_blueprint.py
content_review: USER_APPROVED_R04_FINAL_CONTENT_REVIEW
flow_branch_review: MACHINE_R04_FLOW_VALIDATION_PASS
scene_continuity_review: MACHINE_R04_OWNER_READBACK_PASS
human_language_review: USER_APPROVED_R04_FINAL_COPY_REVIEW
visual_render_review: MACHINE_R04_RENDER_INSPECTION_PASS
user_visual_review: USER_APPROVED_R04_FINAL_VISUAL_REVIEW
user_final_review: USER_APPROVED_R04_FINAL_CONTENT_COPY_AND_VISUAL_REVIEW
implementation_authority: BLOCKED
```

<!-- BLUEPRINT_DATA:START -->
```json
{
  "project": "Switchy Express: Cargo Puzzle",
  "pair_id": "SX-HGB-001",
  "revision": "r04",
  "date": "2026-09-01",
  "source_main": "0bf5e2150d643210abf127e34880111ee986b29d",
  "user_final_review": "USER_APPROVED_R04_FINAL_CONTENT_COPY_AND_VISUAL_REVIEW",
  "pages": [
    {
      "kind": "cover",
      "title": "Cargo Puzzle\nBlueprint",
      "subtitle": "선로를 놓아 화물의 만남 순서를 만들고,\n움직이는 열차 위에서 TOP을 원하는 역까지 데려가는\n유한형 미니어처 철도 퍼즐.",
      "verbs": ["관찰", "설계", "선택", "실행", "복기"],
      "status": "사람용 블루프린트 · r04 화면 흐름/와이어프레임 보정 · 기계 검증 완료 · 사용자 최종 문서 검수 승인"
    },
    {
      "kind": "vision",
      "eyebrow": "ONE-PAGE VISION",
      "title": "무엇을 약속하는가",
      "claim": "선로의 모양을 고르는 일이 곧 화물의 적재 순서와 마지막 하역 판단을 설계하는 일이 된다.",
      "audience": "작고 명확한 공간 퍼즐에서 ‘내가 미리 읽고 짰다’는 납득을 좋아하는 플레이어.",
      "fantasy": "아늑한 미니어처 철도 세계의 운전·배차 담당자가 되어, 움직임이 시작되기 전에 가장 중요한 순서를 설계한다.",
      "memory": "마지막으로 실은 화물이 TOP에 남아 있고, 열차가 맞는 역의 바로 옆을 지날 때 한 묶음이 깔끔하게 내려가는 순간.",
      "pillars": [
        ["1 · 행로 설계", "선로 배치로 어떤 화물을 언제 만날지 만든다."],
        ["2 · TOP 판단", "적재 순서와 현재 TOP을 보고 ‘지금 싣지 않을’ 선택까지 한다."],
        ["3 · 운행 실행", "Auto와 분기를 상황에 맞게 다루고 결과를 다음 시도로 연결한다."]
      ],
      "not_this": "무한 생존·연료 압박 게임도, 점수 경쟁용 철도 경영도, 자동 정답을 알려 주는 경로 솔버도 아니다."
    },
    {
      "kind": "positioning",
      "eyebrow": "POSITIONING",
      "title": "익숙한 철도 퍼즐 위에 무엇이 다른가",
      "claim": "따뜻하고 읽기 쉬운 보드 위에서, 공간 연결과 LIFO 적재 순서를 하나의 질문으로 묶는다.",
      "rows": [
        ["Railbound", "작은 철도 연결 퍼즐", "한 배치가 전체 흐름을 바꾸는 가독성", "고정된 유한 맵·화물 TOP·운행 중 분기 선택"],
        ["Train Valley", "움직이는 열차와 선로 운영", "계획 뒤에도 한 번의 실행 판단이 남는 긴장", "스케줄·산업·다중 열차 운영은 제외"],
        ["Station to Station", "아늑한 미니어처 철도 세계", "편안한 재질 안에서도 제약을 또렷하게 보이기", "격자·화물·역 서비스 범위는 장식에 가리지 않음"],
        ["Mini Motorways", "단순한 네트워크 표기와 점진 학습", "한 번에 한 규칙을 배우는 첫 세션", "무한 성장·매일 도전·도시 수요 압박은 제외"],
        ["Switchy Express", "행로 = 적재 순서", "TOP을 원하는 역의 인접 칸까지 가져가는 계획", "선로 설계·선택적 적재·직접 분기 실행이 한 계약"]
      ],
      "note": "비교 근거: 각 제품의 공식 스토어·개발사 설명을 2026-09-01에 재확인. 기능·레벨·시각 표현을 복제하지 않는다."
    },
    {
      "kind": "experience",
      "eyebrow": "PLAYER EXPERIENCE",
      "title": "한 회차에서 무엇을 보고·고민하고·기억하는가",
      "claim": "기대에서 시작해, 공간 계획의 긴장과 운행 중 판단을 거쳐 ‘내 계획이 맞았는가’를 복기하는 유한한 여정이다.",
      "steps": [
        ["1", "시작", "이번 퍼즐을 열까?", "기대"],
        ["2", "보드 읽기", "화물과 역은 어디에 있나?", "관찰"],
        ["3", "선로 설계", "무슨 순서로 만날까?", "가설"],
        ["4", "운행 준비", "TOP을 어떻게 만들까?", "긴장"],
        ["5", "적재 선택", "지금 싣는 것이 맞나?", "결단"],
        ["6", "분기 실행", "이 길을 유지할까?", "집중"],
        ["7", "하역 확인", "맞는 TOP이 왔나?", "납득"],
        ["8", "결과", "같은 길을 다시 시험할까?", "복기"],
        ["9", "다음 시도", "무엇을 바꿀까?", "재설계"]
      ],
      "bottom": "핵심 감정 곡선: 기대 → 관찰 → 가설 → 긴장 → 결단 → 집중 → 납득 → 복기 → 재설계"
    },
    {
      "kind": "screen_flow_map",
      "eyebrow": "SCREEN NAVIGATION FLOW MAP",
      "title": "화면은 어디서 왔고, 어떤 조건으로 어디로 가는가",
      "claim": "화살표는 실제 진입·복귀·실패 경계다. 특히 사전검사 실패는 RUN으로 넘어가지 않고 BUILD 안에서 수정된다.",
      "nodes": [
        ["TITLE", "제목", "첫 세션 시작 또는 복귀"],
        ["BOOK", "Route Book", "고정 수제 stage 선택"],
        ["BRIEF", "브리핑", "목표와 이번 판단 읽기"],
        ["BUILD", "BUILD", "선로·화물 조우 순서 설계"],
        ["RUN", "RUN", "TOP·Auto·시간·현재 행로 실행"],
        ["RESULT", "결과", "성공/실패 사실과 회복 선택"]
      ],
      "routes": [
        ["TITLE", "BOOK", "Stage Book"],
        ["TITLE", "BRIEF", "첫 세션"],
        ["BOOK", "BRIEF", "stage 선택"],
        ["BRIEF", "BUILD", "Begin"],
        ["BUILD", "RUN", "사전검사 통과"],
        ["RUN", "RESULT", "성공/시간/ROUTE_END"],
        ["RESULT", "RUN", "Retry: 같은 배치"],
        ["RESULT", "BUILD", "Edit: 행로 수정"]
      ],
      "footer": "Retry는 같은 레이아웃을 새 운행으로 다시 실행하고, Edit는 BUILD로 돌아가 화물 조우 순서 자체를 바꾼다. Pause / Exit는 RUN 지속 또는 제목 복귀의 별도 확인 경로다."
    },
    {
      "kind": "gameplay_flow_map",
      "eyebrow": "GAMEPLAY DECISION FLOW MAP",
      "title": "한 회차에서 판단은 어떤 순서로 이어지는가",
      "claim": "이 지도는 화면 목록이 아니라 설계·검사·운행·회복의 의존 관계를 보여 준다. 색과 장식보다 선로와 TOP의 판단이 먼저다.",
      "stages": [
        ["OBSERVE", "보드 읽기", "화물·역·시작점·막힌 칸을 관찰"],
        ["BUILD", "선로 배치", "만남 순서와 되돌아갈 길 설계"],
        ["CHECK", "사전검사", "필수 화물·역 서비스 칸 도달성 확인"],
        ["RUN", "계획 실행", "적재·보류·Auto·분기·주의 구간 판단"],
        ["RESULT", "결과 복기", "성공 또는 사실 기반 실패를 읽고 다음 선택"]
      ],
      "branches": [
        ["OBSERVE", "BUILD", "계획 시작"],
        ["BUILD", "CHECK", "배치 완료"],
        ["CHECK", "BUILD", "실패 → 수정"],
        ["CHECK", "RUN", "통과 → 운행"],
        ["RUN", "RESULT", "성공/시간/ROUTE_END"]
      ],
      "run_detail": [
        ["화물", "화물 칸 직접 통과", "적재 → TOP 변경"],
        ["역", "상·하·좌·우 인접 통과", "matching TOP 묶음 하역"],
        ["노선", "분기·주의·폐기장", "선택·감속·정상 복귀"]
      ],
      "footer": "화물은 정확한 칸을 지나 적재한다. 역/폐기장은 건물 칸이 아닌 cardinal-adjacent 서비스 칸에서 matching TOP 묶음만 처리한다. 감속·회복은 renderer-local 표현이며 게임 규칙·저장·노선을 바꾸지 않는다."
    },
    {
      "kind": "journey_table",
      "eyebrow": "PLAYER JOURNEY DETAIL",
      "title": "각 화면에서 무엇을 보고 무엇을 결정하는가",
      "claim": "앞의 흐름도는 화면 이름 목록이 아니라, 다음 화면에 남기는 정보와 판단을 보여 주는 지도다.",
      "headers": ["도착", "들어온 곳·목적", "보는 정보", "행동·판단", "다음 도착지"],
      "rows": [
        ["제목", "실행·회차 종료\n시작 또는 복귀", "wordmark·Start·Stage Book", "첫 세션 또는 선택형 책을 고름", "브리핑/Route Book"],
        ["Route Book", "Stage Book\nbook/stage 선택", "이름·한 가지 판단", "고정 수제 스테이지를 고름", "브리핑"],
        ["브리핑", "새 레슨/선택 stage\n목표 이해", "목표·한 규칙·Begin", "무엇을 먼저 볼지 정함", "BUILD"],
        ["BUILD", "브리핑 완료\n행로 설계", "격자·화물·역·건설 가능 칸", "선로와 화물 조우 순서 설계", "사전검사/RUN"],
        ["RUN", "유효한 설계\n계획 실행", "열차·TOP·Auto·분기·속도 상태", "적재·보류·Auto·분기를 선택", "결과 또는 계속"],
        ["결과", "성공 또는 실패\n원인 확인", "완료·남은 화물·스택", "같은 시도/다른 설계/종료 선택", "Retry·Edit·제목·다음"],
        ["Retry", "같은 선로\n가설 재시험", "같은 배치의 새 운행", "입력·분기 판단을 바꿈", "RUN"],
        ["Edit", "다른 답 탐색\n다시 설계", "이전 선로와 보드", "조우 순서 자체를 바꿈", "BUILD"]
      ]
    },
    {
      "kind": "atlas",
      "eyebrow": "KEY SCENE ATLAS",
      "title": "경험의 뼈대를 이루는 장면은 무엇인가",
      "claim": "각 장면은 예쁜 화면이 아니라, 플레이어가 다른 종류의 판단을 하는 위치다.",
      "cards": [
        ["01", "제목", "첫 세션과 선택형 Route Book 중 다음 진입을 결정", "title"],
        ["02", "Route Book", "수제 stage 하나와 그 판단을 선택", "lesson"],
        ["03", "BUILD", "만남 순서를 선로로 설계", "board"],
        ["04", "RUN", "적재·Auto·분기·속도 상태를 실행", "board"],
        ["05", "성공", "완성된 하역과 다음 선택을 확인", "success"],
        ["06", "결과", "실패 사실을 읽고 Retry·Edit·다음을 고름", "failure"]
      ],
      "note": "제목 wordmark는 승인된 실제 런타임 입력이고, r02 생성 문서 후보는 문서 전용 참고다. 카드 조합과 설명은 사람용 문서 도식이며, 완성된 게임 화면이나 사용성 통과를 뜻하지 않는다."
    },
    {
      "kind": "scene_contract",
      "eyebrow": "SCENE CONTRACT",
      "title": "장면마다 무엇을 가져와 무엇을 넘기는가",
      "claim": "앞 장면의 정보가 다음 장면의 선택을 바꿔야, 이 흐름은 스크린샷 모음이 아니라 플레이 경험이 된다.",
      "items": [
        ["제목", "실행·회차 종료", "새 퍼즐/복귀", "시작 또는 계속", "안내"],
        ["안내", "새 레슨", "목표·새 규칙 하나", "첫 행동 이해", "BUILD"],
        ["BUILD", "목표 이해", "보드·화물·역", "조우 순서와 선로", "RUN"],
        ["RUN", "설계된 선로", "TOP·Auto·분기", "지금 적재·지금 전환", "계속/결과"],
        ["성공", "마지막 하역", "완료 사실", "다음 퍼즐/제목", "안내/제목"],
        ["실패", "미완료/ROUTE_END/시간", "남은 화물·스택", "Retry 또는 Edit", "RUN/BUILD"]
      ],
      "footer": "연속성: 설계한 만남 순서 → RUN의 TOP 판단 → 역 인접 하역 결과 → Retry의 입력 수정 또는 Edit의 행로 수정"
    },
    {
      "kind": "shell_wireframe",
      "eyebrow": "SPATIAL WIREFRAME · SHELL",
      "title": "제목·Route Book·브리핑은 무엇을 먼저 보여 주는가",
      "claim": "화면 이름과 버튼 목록을 나열하지 않고, 첫 시선·고정 정보·주 행동·보조 행동의 실제 영역 관계를 그린다.",
      "screens": [
        ["SX-SCR-001", "제목", "wordmark / 세계관", "첫 세션 또는 선택한 Route Book", "Stage Book · Controls · Quit"],
        ["SX-SCR-RB", "Route Book", "선택한 stage의 한 가지 판단", "고정 stage 선택", "Back"],
        ["SX-SCR-003", "브리핑", "목표", "BUILD 시작", "Objective · Rules"]
      ]
    },
    {
      "kind": "board_wireframe",
      "eyebrow": "SPATIAL WIREFRAME · BOARD",
      "title": "BUILD와 RUN은 같은 보드에서 다른 판단을 받는다",
      "claim": "두 상태 모두 보드가 첫 시선이지만, BUILD는 배치·사전검사를, RUN은 TOP·현재 행로·분기 실행을 우선한다.",
      "build": ["SX-SCR-004", "BUILD", "선로 도구", "보드 · buildable / blocked / cargo / station", "사전검사 / RUN"],
      "run": ["SX-SCR-006", "RUN", "Manual / Auto", "보드 · 열차 / 현재 행로 / 주의 구간", "분기 실행"],
      "footer": "보드는 장식이 아니라 판단 표면이다. BUILD 실패 피드백은 보드와 사전검사에 남고, RUN으로 넘어가지 않는다. RUN의 TOP·Auto·Timer·Route control은 보드를 가리지 않는 보조 정보다."
    },
    {
      "kind": "result_wireframe",
      "eyebrow": "SPATIAL WIREFRAME · RECOVERY",
      "title": "결과 화면은 사실을 먼저, 회복 선택을 다음에 보여 준다",
      "claim": "성공과 실패는 서로 다른 감정이지만, 둘 다 원인·남은 상태·다음 행동을 과장 없이 읽을 수 있어야 한다.",
      "screen": ["SX-SCR-010/011", "결과", "성공/실패 사실", "Retry · 같은 배치", "Edit · BUILD로 복귀"],
      "footer": "Retry는 같은 레이아웃의 새 운행으로 입력·분기 판단을 다시 시험한다. Edit는 보드와 이전 선로로 돌아가 조우 순서를 다시 설계한다. 이 구분은 결과 화면의 행동 배치로도 보인다."
    },
    {
      "kind": "run_state",
      "eyebrow": "RUN STATE MAP",
      "title": "운행 중 무엇이 바뀌고 무엇은 바뀌지 않는가",
      "claim": "속도 전환은 renderer-local 표현이고, 화물·노선·저장·게임 규칙의 쓰기 권한을 가지지 않는다.",
      "states": [
        ["BUILD_FAIL", "사전검사 실패", "필수 경로/서비스 누락", "이유와 문제 칸을 읽음", "BUILD"],
        ["RUN_NORMAL", "정상 운행", "사전검사 통과", "TOP·Auto·시간·현재 행로", "분기/화물"],
        ["ROUTE_CHOICE", "분기 선택", "점유 전 도달", "대안 방향과 잠금 가능성", "RUN_NORMAL"],
        ["DECELERATE", "주의 진입", "주의 칸에서 출발", "0.55 속도·amber 제동", "주의 구간 운행"],
        ["ACCELERATE", "정상 복귀", "정상 칸으로 출발", "cyan 회복·연속 주의 반복 없음", "RUN_NORMAL"],
        ["RESULT", "결과", "성공·시간·ROUTE_END", "사실·남은 화물·다음 행동", "Retry/Edit/Title"]
      ],
      "footer": "Reduced motion에서는 감속·회복 모두 정적인 제한된 동등 표현을 사용한다. 폐기 화물은 cardinal-adjacent disposal yard에서 matching TOP 묶음으로만 내려간다."
    },
    {
      "kind": "asset_readiness",
      "eyebrow": "UI & ASSET READINESS",
      "title": "필요한 이미지는 이미 소비처가 있는가",
      "claim": "현재 슬롯을 먼저 재사용하고, 실제 빈 runtime slot이 증명될 때만 다음 후보 한 개를 만든다.",
      "headers": ["표면", "실제 소비처", "상태", "r04 사용", "새 이미지 조치"],
      "rows": [
        ["제목 wordmark", "TitleScreen/…/TitleLogo", "USER_APPROVED_CANONICAL", "표지의 기존 입력", "재사용만"],
        ["셸 분위기", "ProductShellArt", "EXISTING_RUNTIME", "제목·브리핑·결과 문맥", "새 비트맵 없음"],
        ["보드 자산", "ProductBoardRenderer paths", "EXISTING_RUNTIME", "지형·선로·역·화물 계층", "재사용만"],
        ["상태 UI", "Godot UI + procedural draw", "EXISTING_RUNTIME", "TOP·분기·서비스·사전검사", "새 비트맵 없음"],
        ["Route Book 02 v02", "ProductBoardRenderer paths", "GENERATED_CANDIDATE · USER_PIXEL_REVIEW_PENDING", "감속·회복·폐기 문맥", "승격/재생성 금지"],
        ["r02 문서 시안", "PDF only", "USER_APPROVED_DOCUMENT_VISUAL", "문서 언어 참고", "실제 빈 슬롯 검증 후 후보 1개"]
      ],
      "footer": "문서용 시안, 런타임 연결 후보, 승인된 제품 자산은 서로 다른 상태다. 이 PDF만으로 픽셀 승인·정본 등록·runtime proof·사람 검수가 되지 않는다."
    },
    {
      "kind": "lesson_curve",
      "eyebrow": "FIRST SESSION",
      "title": "첫 세션은 무엇을 한 번에 하나씩 가르치는가",
      "claim": "T1부터 T6까지는 규칙을 추가하기보다, 같은 핵심 퍼즐을 다른 관점에서 읽게 하는 여섯 번의 질문이다.",
      "cards": [
        ["T1", "연결", "열차가 달릴 수 있는 선로를 만든다.", "선로는 움직임의 시작점"],
        ["T2", "적재와 역", "화물 칸을 지나 적재하고, 역의 옆 칸에서 내린다.", "화물과 역의 접촉 규칙은 다름"],
        ["T3", "LIFO", "원하는 화물을 마지막에 싣도록 거꾸로 설계한다.", "TOP이 다음 하역을 결정"],
        ["T4", "선택적 적재", "지금 싣지 않고 나중에 다시 오는 길을 고른다.", "모든 화물이 즉시 정답은 아님"],
        ["T5", "Auto", "안전할 때는 자동, 순서가 중요하면 수동을 고른다.", "편의와 통제의 교환"],
        ["T6", "분기", "점유되기 전에 직접 방향을 정한다.", "계획은 운행 중에도 실행됨"],
        ["VS", "종합", "여섯 판단을 한 노선에서 함께 쓴다.", "설계·실행·복기 연결"]
      ]
    },
    {
      "kind": "board_layers",
      "eyebrow": "BOARD INFORMATION",
      "title": "보드에서 무엇이 먼저 읽혀야 하는가",
      "claim": "아늑한 지형은 분위기를 만들고, 격자·선로·화물·역·TOP·분기 상태는 판단을 만든다. 둘의 우선순위가 뒤집히지 않는다.",
      "layers": [
        ["1", "지형", "따뜻한 미니어처 세계", "판단을 방해하지 않는 배경"],
        ["2", "격자와 선로", "건설 가능한 칸과 연결", "행로를 정확히 읽는 기준"],
        ["3", "화물과 역", "색·모양·텍스트의 중복 정보", "무엇을 싣고 어디에 내릴지"],
        ["4", "열차와 TOP", "현재 위치와 마지막 적재", "다음 하역 가능성"],
        ["5", "분기와 잠금", "현재 선택·대안·점유 상태", "지금 바꿀 수 있는지"],
        ["6", "결과 피드백", "성공·실패·남은 사실", "다음 시도의 원인"]
      ],
      "note": "BUILD 문서 후보로 정보 위계를 설명 · 실제 런타임 캡처·구현 지시 아님"
    },
    {
      "kind": "build_board",
      "eyebrow": "BUILD",
      "title": "선로를 놓을 때 어떤 계획을 세우는가",
      "claim": "BUILD의 목표는 가장 긴 길을 만드는 것이 아니라, 필요한 화물을 원하는 순서로 만나고 역의 옆 칸을 지나는 행로를 만드는 것이다.",
      "left": ["시작점에서 닿을 수 있는 선로를 만든다.", "필요한 모든 화물에 갈 수 있어야 한다.", "각 역에는 상·하·좌·우 중 적어도 한 서비스 칸이 있어야 한다.", "관계없는 끊긴 선로 섬은 게임을 막지 않는다."],
      "right": ["선로 하나의 모양", "다음 화물과 만나는 순서", "되돌아갈지 건너뛸지", "분기 전의 준비"],
      "diagram_label": "VS_DEMO_01 기준선 · 15×11 보드의 설명용 구성"
    },
    {
      "kind": "lifo",
      "eyebrow": "CARGO & TOP",
      "title": "왜 화물의 적재 순서가 퍼즐의 핵심인가",
      "claim": "스택의 마지막 화물, 즉 TOP만 먼저 하역할 수 있으므로 ‘어디에 갈까’는 ‘무엇을 마지막에 실을까’와 같은 질문이 된다.",
      "stack": ["먼저 적재 · BLUE", "그다음 적재 · RED", "TOP · BLUE"],
      "questions": ["이 화물을 지금 실으면 TOP이 어떻게 바뀌나?", "맞는 역의 인접 칸을 지날 때 맨 위가 맞나?", "일부러 건너뛰고 나중에 다시 올 길이 필요한가?"],
      "rule": "맞는 종류가 TOP에 연속해서 놓여 있으면 그 묶음만 내려간다. 화물 적재는 같은 칸을 지날 때 일어난다."
    },
    {
      "kind": "station",
      "eyebrow": "CARDINAL SERVICE",
      "title": "역에는 어떻게 배송하는가",
      "claim": "화물은 그 칸을 통과해 싣고, 역은 역 건물 자체가 아니라 바로 옆 한 칸을 통과해 배송한다.",
      "allowed": ["위", "오른쪽", "아래", "왼쪽"],
      "not_allowed": ["대각선", "역 건물 칸", "두 칸 이상 떨어진 위치"],
      "steps": ["1 · 맞는 화물을 TOP에 남긴다.", "2 · 해당 역의 상·하·좌·우 한 칸으로 진입한다.", "3 · 연속된 같은 TOP 묶음이 내려간다."],
      "note": "색만으로 구분하지 않고 색·모양·텍스트로 중복 표시한다."
    },
    {
      "kind": "auto",
      "eyebrow": "MANUAL & AUTO",
      "title": "언제 자동으로 싣고 언제 멈춰 생각하는가",
      "claim": "Auto는 반복 입력을 줄이는 편의 기능이지, 항상 더 좋은 답을 고르는 기능이 아니다.",
      "cards": [
        ["수동 기본", "적재하고 싶은 화물 칸에서만 직접 싣는다.", "순서를 지켜야 할 때"],
        ["Auto ON", "안전한 구간에서는 화물을 자동으로 싣는다.", "이미 어떤 순서여도 괜찮을 때"],
        ["Auto OFF", "다음 화물을 일부러 지나친다.", "TOP을 보존하거나 재방문할 때"]
      ],
      "bottom": "플레이어의 반복 질문: ‘편의를 써도 내 계획이 바뀌지 않는 구간인가?’"
    },
    {
      "kind": "switch",
      "eyebrow": "DIRECT ROUTE CONTROL",
      "title": "움직이는 열차 앞에서 무엇을 바꿀 수 있는가",
      "claim": "분기는 열차가 점유하기 전에 직접 정하고, 점유 뒤에는 선택이 잠긴다. 밝은 선로는 현재 선택의 결과를 보일 뿐 정답을 제안하지 않는다.",
      "states": [
        ["선택 가능", "대안 방향을 직접 고른다.", "어두운 대안도 조작 대상"],
        ["현재 행로", "열차가 실제로 갈 선로만 밝게 보인다.", "방향 표식으로 진행을 읽음"],
        ["점유 잠금", "지나가는 분기는 바꿀 수 없다.", "붉은 잠금 표식은 금지를 뜻함"],
        ["결과", "멈춘 열차 앞의 미래 행로를 그리지 않는다.", "결과를 사실로 읽고 복귀"]
      ],
      "warning": "밝은 행로는 솔버·최적 경로·자동 선택이 아니다. 현재의 직접 선택을 읽기 쉽게 보여 주는 피드백이다."
    },
    {
      "kind": "capstone",
      "eyebrow": "VS_DEMO_01",
      "title": "종합 퍼즐에서 무엇을 함께 쓰는가",
      "claim": "VS_DEMO_01은 새 규칙을 더하는 시험이 아니라, 여섯 가지 이미 배운 판단을 하나의 유한 보드에서 함께 쓰게 한다.",
      "steps": [
        ["1", "경로", "필요한 화물과 역의 인접 칸을 모두 잇는다."],
        ["2", "순서", "나중에 TOP이 될 화물을 거꾸로 생각한다."],
        ["3", "선별", "바로 싣지 않을 화물과 다시 올 길을 정한다."],
        ["4", "운행", "안전한 구간만 Auto에 맡기고, 필요한 곳에서는 수동으로 고른다."],
        ["5", "분기", "점유 전에 방향을 정해 계획을 실행한다."],
        ["6", "복기", "성공·실패 뒤 같은 배치를 다시 시험하거나 행로를 고친다."]
      ],
      "finish": "성공은 필요한 모든 화물을 배송했을 때 즉시 확정된다. 실패는 시간 만료 또는 ROUTE_END로 사실만 알려 준다."
    },
    {
      "kind": "result",
      "eyebrow": "RESULT · RETRY · EDIT",
      "title": "결과 뒤에는 무엇을 배우고 어디로 가는가",
      "claim": "결과 화면은 정답을 대신 말해 주지 않는다. 이미 일어난 사실을 보여 주고, 같은 가설을 다시 시험할지 행로를 다시 설계할지 묻는다.",
      "success": ["모든 필요 화물 배송", "완료 사실 확인", "다음 퍼즐 또는 제목으로 이동"],
      "failure": ["시간 만료 또는 ROUTE_END", "남은 화물과 현재 스택 확인", "Retry 또는 Edit를 선택"],
      "retry": "Retry · 같은 선로에서 새 운행을 시작한다. 적재·Auto·분기 판단을 바꿔 가설을 시험한다.",
      "edit": "Edit · BUILD로 돌아가 선로와 화물 조우 순서 자체를 바꾼다.",
      "note": "결과는 없는 원인·점수·공략을 만들어 내지 않는다."
    },
    {
      "kind": "content",
      "eyebrow": "CONTENT & LEARNING",
      "title": "콘텐츠는 어떤 질문을 넓히는가",
      "claim": "첫 세션의 맵들은 단순히 난이도를 올리는 순서가 아니라, ‘무엇을 계획해야 하는가’를 한 층씩 늘리는 콘텐츠다.",
      "rows": [
        ["T1", "연결", "움직일 수 있는 하나의 길", "선로는 행동의 조건"],
        ["T2", "적재·역", "화물 칸과 역 인접 칸의 차이", "실기 규칙을 구분"],
        ["T3", "LIFO", "원하는 하역을 위해 역순 적재", "TOP을 미리 설계"],
        ["T4", "재방문", "일부 화물을 건너뛰는 길", "‘안 싣기’도 선택"],
        ["T5", "Auto", "편의와 순서 통제", "도구는 상황에 따라 다름"],
        ["T6", "분기", "점유 전 방향 선택", "계획을 운행 중 실행"],
        ["VS", "종합", "연결·TOP·Auto·분기", "한 회차의 자신감"]
      ],
      "footer": "현재 제품은 손으로 만든 유한 퍼즐을 중심으로 한다. 점수·연료·무한 모드·자동 최적해는 이 여정의 일부가 아니다."
    },
    {
      "kind": "visual",
      "eyebrow": "VISUAL & AUDIO LANGUAGE",
      "title": "무엇을 한눈에 기억하게 하는가",
      "claim": "따뜻한 미니어처 철도 세계와 짙은 네이비 조작면의 대비가 ‘편안하지만 정확하게 읽어야 하는 퍼즐’이라는 성격을 만든다.",
      "north_star": ["따뜻한 풀·돌·목재·황동·네이비 기관차", "격자 입력은 사각형을 유지하고, 깊이는 자산 안에서만 표현", "중요 상태는 색만이 아니라 방향·모양·텍스트를 함께 사용", "라임은 유효·현재 행로, 보라색은 안내 집중, 진홍은 금지·위험", "소리는 적재·하역·분기·결과의 원인을 보조하지만 정보를 대체하지 않음"],
      "boundary": "승인된 title wordmark와 기존 보드 언어를 문서 입력으로 재사용한다. Route Book 02 v02 cutout은 픽셀 검토 대기 후보이며, 감속 amber·회복 cyan은 renderer-local 표현이다. 어떤 이미지도 이 PDF만으로 승인·런타임 통합·사람 사용성 통과가 되지 않으며, 실제 게임 텍스트는 이미지가 아닌 구조화된 Godot 텍스트로 남는다."
    },
    {
      "kind": "review",
      "eyebrow": "USER REVIEW",
      "title": "r04 블루프린트에서 무엇을 확인하면 되는가",
      "claim": "이 검수는 새로운 기능을 추가하는 자리가 아니라, 현재 Godot 화면·자산 상태와 사람이 읽는 흐름이 같은지 확인하는 자리다.",
      "questions": [
        "한 문장 약속이 ‘선로 설계 = 화물 TOP 설계’라는 재미를 정확히 말하는가?",
        "제목·Stage Book·브리핑·BUILD·RUN·결과의 진입과 복귀가 실제 흐름과 같은가?",
        "화물 칸을 지나는 적재와 역의 옆 칸을 지나는 배송이 분명히 구분되는가?",
        "LIFO·선택적 적재·Auto·분기가 반복 판단으로 읽히는가?",
        "주의 진입의 감속과 정상 복귀의 회복이 별도 표현이되 게임 규칙을 과장하지 않는가?",
        "승인 자산, 런타임 연결 후보, 문서용 시안의 상태가 서로 섞이지 않는가?"
      ],
      "status_rows": [
        ["기계 흐름·장면·렌더 검수", "PASS · r04 exact PDF, owner readback, flow/branch, all-page render"],
        ["사용자 문서 내용·문장·시각 승인", "r02 문서 후보 승인 보존 · r04 최종 문서 검수 승인"],
        ["새 게임 구현 권한", "없음 · 이 문서는 파생 검수본"],
        ["실제 플레이 검수", "별도 · Windows/오디오, Android, 최종 사용자 확인" ]
      ],
      "close": "검수 후에는 ‘이 설명으로 충분함’, ‘수정할 페이지’, ‘다음에 실제 플레이에서 확인할 질문’을 남긴다."
    }
  ]
}
```
<!-- BLUEPRINT_DATA:END -->

## Publication validation record

```yaml
revision: r04
machine_validation:
  blueprint_renderer_tests: PASS · 7 tests
  project_python_suite: PASS · 259 tests · 1 intentionally skipped
  project_contract: PASS
  pdf_structure: PASS · 26 pages · manifest SHA-256 match · title metadata match
  rendered_visual_inspection: PASS · all 26 pages rasterized and inspected; page 05 re-inspected after its dedicated Edit return-lane correction
adversarial_review_loops:
  - consumer_and_provenance_boundary: PASS · existing runtime assets, approved planning references, and document-only candidates remain separately labelled
  - scope_and_authority: PASS · no Godot scene, GDScript, map, runtime asset, Candidate 010, or Route Book 02 approval change
  - flow_semantics: PASS · direct TITLE→BRIEF first-session lane is independent of TITLE→BOOK→BRIEF; invalid preflight remains BUILD; Retry and Edit end at distinct destinations
  - readability_and_layout: PASS · navigation/gameplay maps and three spatial wireframes reserve independent labels, footer clearance, and non-overlapping action regions; Edit return uses its own lower lane
  - artifact_integrity: PASS · deterministic PDF regenerated, manifest SHA-256 read back, all pages rasterized
known_nonblocking_environment_note:
  - validate_project_contract defers two pre-existing corrupt production-candidate PNG sources; their current runtime-integrated promoted assets remain validated and this r04 scope did not touch them
evidence_ceiling:
  - MACHINE_AND_RENDERED_DOCUMENT_EVIDENCE_PLUS_FINAL_DOCUMENT_REVIEW
  - final_user_review: USER_APPROVED_R04_FINAL_CONTENT_COPY_AND_VISUAL_REVIEW
  - physical_windows_audio_android_release: NOT_RUN_OR_SEPARATE
```

## User final review record

```yaml
blueprint_pair_id: SX-HGB-001
revision: r04
review_status: USER_APPROVED_R04_FINAL_CONTENT_COPY_AND_VISUAL_REVIEW
approved_on: 2026-09-02
approved_scope:
  - SX-HGB-VIS-001_title_hero_document_visual
  - SX-HGB-VIS-002_build_board_document_visual
  - SX-HGB-VIS-003_run_switch_top_document_visual
  - SX-HGB-VIS-004_rail_station_language_document_visual
  - r02_document_visual_provenance_preserved
  - SX-TITLE-WORDMARK-001_existing_approved_document_input
  - r04_independent_flow_maps_spatial_wireframes_run_state_asset_readiness_editorial_scope
excluded_scope:
  - new_gameplay_system
  - runtime_asset_promotion
  - runtime_scene_or_code_change
  - candidate_010_evidence_reinterpretation
  - v02_wayside_pixel_approval
  - physical_or_human_evidence_promotion
requested_changes: []
remaining_risks:
  - Live physical, device, audio, and release evidence remain separate from this document.
approval_evidence: '2026-09-02 current user message: 승인,병합 진행하고 구현작업도 진행해'
```
