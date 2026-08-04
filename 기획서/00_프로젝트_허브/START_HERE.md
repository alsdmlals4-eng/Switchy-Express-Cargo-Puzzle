# Switchy Express 프로젝트 허브

## 현재 제품 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | Switchy Express: Cargo Puzzle |
| 장르 | 유한 스테이지 선로 건설·LIFO 화물 배송 퍼즐 |
| 플랫폼 | Android · landscape |
| 엔진 | Godot 4.7.1 · GDScript |
| 현재 결정 | GMB-002 · SX-DEC-027~036 |
| 현재 감사 | SX-AUD-012 |
| 구현 상태 | old endless core 존재 · 새 finite core 재기획 필요 |
| 다음 Gate | FINITE_PUZZLE_DEFINITION_OF_READY |
| Sheet | correct 12-tab GDD · same-ID sync required |

## 한 문장

> 선로를 건설해 화물을 원하는 순서로 만나고, 마지막에 실은 화물부터 내리는 LIFO를 역산해 제한 시간 안에 모든 배송을 끝내는 비용·속도·Combo 최적화 퍼즐.

## 반드시 먼저 읽기

1. `FINITE_DELIVERY_PUZZLE_BASELINE.md`
2. `CURRENT_CONFIRMED_DECISIONS.md`
3. `CANON_REPLACEMENT_REGISTER.md`
4. `../10_경험/CORE_GAMEPLAY.md`
5. `../20_시스템_콘텐츠/CORE_SYSTEMS.md`
6. `../50_제작_검증/SX_AUD_012_FINITE_DELIVERY_PIVOT_AUDIT.md`
7. `ROADMAP.md`

## 핵심 재미

```text
선로 건설
→ 화물 조우 순서
→ LIFO 스택
→ 역 방문·분기 실행
→ Combo 하역
→ 시간·건설비·점수 재설계
```

## 현재 중요한 경계

- LIFO 의미는 유지한다.
- endless survival·fuel·BOOST·capacity 8·pickup respawn은 현 제품 권위가 아니다.
- 기존 CI와 merge는 old core의 역사 증거다.
- 새 Definition of Ready 전에는 old VS03 package 구현을 이어가지 않는다.
- Sheet와 GitHub는 같은 Decision/Audit ID를 사용한다.
- wrong `19Ff...` Sheet는 사용하지 않는다.

## 진행 순서

```text
GMB-002 canonical merge
→ correct Sheet sync/readback
→ finite puzzle DoR
→ package segmentation
→ Codex TDD implementation
→ Android/human/balance validation
```

## 아트 방향

귀엽고 친근한 프리미엄 캐주얼 3D 카툰·토끼 기관사 방향은 유지한다. 새 시각 작업은 선로 건설 ghost, 비용 비교, LIFO TOP, 최대 1초 연속 하역, Combo 출발 가속을 우선한다.

## 보류

- UGC map editor/publication/community
- 환적역
- 다중 열차·신호 자동화
- 온라인 반복 도전 backend
