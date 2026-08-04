# [대체됨] VS03-05A Minimal Playable Core Surface Implementation Plan

상태: `[대체됨 · 실행 금지]`

이 계획은 완성형 RailGraph·fuel·BOOST·capacity 8·endless result를 전제로 한 old playable surface 계획이다.

`GMB-002 · SX-DEC-027~036`에 따라 현재 제품은 player track construction·finite delivery·unlimited LIFO·time limit·stars를 사용한다. 따라서 이 계획의 Scene/HUD 구현을 이어가면 구형 제품을 고착시킨다.

새 실행 순서:

```text
finite puzzle Definition of Ready
→ package segmentation
→ Track construction domain
→ finite delivery run
→ Combo/track performance
→ tutorial/authored maps
→ stars/local records
→ product surface
```

현재 정본:

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- `기획서/00_프로젝트_허브/ROADMAP.md`

이전 계획 세부는 git history에서만 역사 자료로 조회한다.
