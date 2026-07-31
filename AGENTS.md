# Switchy Express 공용 AI 작업 규칙

이 저장소는 `alsdmlals4-eng/Base` v9.3 운영 계약을 적용한 Godot 모바일 게임 프로젝트다.

## 우선순위

1. 사용자의 최신 지시
2. 이 `AGENTS.md`
3. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
4. 등록된 분야 책임 원본
5. 실제 코드·데이터·Scene·Resource·자산·테스트
6. 프로젝트에 고정된 Base v9.3 기준
7. 외부 사례·과거 대화·추정

## 역할 분리

- ChatGPT: 기획, 벤치마킹, 시스템·데이터 설계, Google Sheets GDD, GitHub 문서·Issue, Codex Goal, 적대적 검토, 테스트 체크리스트
- Codex: 승인된 구현 계획에 따른 실제 Godot/GDScript 코드와 저장소 파일 변경
- 사용자가 명시하지 않은 게임 규칙·세계관·과금·콘텐츠를 임의로 확정하지 않는다.

## 엔진·플랫폼

- Engine: Godot `4.7.1-stable`
- Language: GDScript
- Primary platform: Android / Google Play
- Orientation: landscape
- Godot 용어를 사용하며 Unity/C#/Prefab/MonoBehaviour 프레이밍을 사용하지 않는다.

## 현재 코어 보호

- 자동 운행하는 화물열차
- 연결된 가로형 15×10 철도망
- 2단계·3단계 이상 분기기
- `짐싣기` 입력 중 지나가는 화물만 적재
- 마지막에 실은 화물부터 하역하는 LIFO 규칙
- 같은 색 연속 하역 콤보
- 배송으로 점수와 연료 회복
- 시간 경과에 따른 기본 속도·연료 소모 증가
- 화물 적재량에 따른 속도 감소
- 부스터 사용 중 속도 증가와 추가 연료 소모
- 연료 0에서 게임오버
- 무한 생존과 최고 점수 경쟁

코어 변경은 `USER_DECISION_REQUIRED`다.

## 정본

- 현재 결정: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- 핵심 경험: `기획서/10_경험/CORE_GAMEPLAY.md`
- 시스템 규칙: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
- 아트·UI: `기획서/40_표현/VISUAL_DIRECTION.md`
- Vertical Slice: `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- 사용자 GDD: `https://docs.google.com/spreadsheets/d/1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo/edit`

## 금지

- 승인 없이 코어 변경
- HTML POC를 제품 구현 완료 증거로 사용
- 생성 콘셉트 이미지를 실제 게임 캡처로 표시
- FIFO 하역으로 되돌리기
- 색상만으로 화물과 역을 구분
- 무조작 영구 생존 루프 허용
- 실행하지 않은 테스트를 통과로 보고
- 사용자 승인 없이 광고·가챠·에너지·PvP·길드 추가
