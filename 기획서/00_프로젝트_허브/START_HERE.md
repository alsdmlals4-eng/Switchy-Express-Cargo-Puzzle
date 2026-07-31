# Switchy Express 프로젝트 허브

## 프로젝트 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | **Switchy Express: Cargo Puzzle** |
| 장르 | 무한 생존 점수 경쟁형 철도 노선·화물 스택 퍼즐 |
| 플랫폼 | Android / Google Play |
| 엔진 | Godot 4.7.1 / GDScript |
| 화면 | 가로형 |
| 현재 단계 | PRE_PRODUCTION |
| 코어 상태 | CORE_CONFIRMED |
| 제품 구현 | NOT_STARTED |
| POC | HTML 규칙 검증 완료, 제품 증거 아님 |
| Sheet | `https://docs.google.com/spreadsheets/d/1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo/edit` |
| Base | v9.3.0 (`30ca6c7b5f93521f0eb0eed42d01437cd43c50ae`) |

## 한 문장 플레이어 약속

> 필요한 화물을 선택해 열차에 역순으로 쌓고, 선로 분기기를 바꿔 알맞은 역에서 콤보 하역하며 연료가 다하기 전까지 최고 점수를 갱신한다.

## 현재 읽기 순서

```text
CURRENT_CONFIRMED_DECISIONS.md
→ ACTIVE_CONTEXT.md
→ ../../10_경험/CORE_GAMEPLAY.md
→ ../../20_시스템_콘텐츠/CORE_SYSTEMS.md
→ ../../40_표현/VISUAL_DIRECTION.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ ../../../docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md
```

## 현재 Gate

`G1_CORE_CONFIRMED` 통과. 다음 Gate는 `G2_VERTICAL_SLICE_CONTRACT_APPROVED`다.

## 다음 작업

1. Godot 프로젝트와 테스트 러너 생성
2. 연결 철도 그래프와 2·3단계 분기 라우팅 구현
3. 화물 적재·LIFO 하역·스테이션 시스템 구현
4. 연료·속도·부스터·점수 루프 구현
5. 모바일 가로형 HUD와 시각 가독성 구현
6. 플레이테스트 계측과 적대적 검토
