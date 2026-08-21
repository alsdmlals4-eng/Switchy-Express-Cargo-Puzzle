# First Session Localization Copy · Addendum 01

```yaml
owner_decision: SX-DEC-059
status: CURRENT_ADDENDUM
parent: FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md
locales: [ko, en, ja, zh-Hans]
```

Lesson Card/action CTA에 필요한 공통 키를 추가한다. 기존 matrix의 의미를 바꾸지 않는다.

| Key | Context | KO | EN | JA | ZH-Hans |
|---|---|---|---|---|---|
| `SX_ACTION_START_LESSON` | T1/T3/T4/T5/T6/Capstone Lesson Card CTA | 시작 | Start | 開始 | 开始 |
| `SX_ACTION_START_RUN` | T2 same-layout run CTA | 운행 시작 | Start Run | 運行開始 | 开始运行 |
| `SX_ACTION_CONTINUE` | 비최종 lesson success 이후 다음 Lesson Card 이동 | 계속 | Continue | 続ける | 继续 |

Rules:
- raw key를 player-facing fallback으로 노출하지 않는다.
- 버튼 의미는 네 locale에서 같은 행동을 가리킨다.
- `SX_ACTION_CONTINUE`는 자동 진행 대신 별도 continue 화면이 실제 구현에서 필요하다고 RED test가 증명할 때만 사용한다. 불필요하면 만들었더라도 UI에 노출하지 않는다.
