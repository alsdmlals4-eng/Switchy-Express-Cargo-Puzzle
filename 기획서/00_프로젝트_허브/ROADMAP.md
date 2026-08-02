# Roadmap

## M0 — 운영체계 설치 · COMPLETE

- [x] GitHub 정본·Registry·Base Adapter·Google Sheets GDD 연결
- [x] 새 작업자가 저장소만으로 현재 결정과 다음 작업 복원
- [x] Base v9.4 운영 계약 적용

## M1 — 철도·열차·화물 기반 · COMPLETE

- [x] Godot 4.7.1 프로젝트와 헤드리스 테스트 러너
- [x] 15×10 연결 철도망
- [x] 2단계·3단계 분기기
- [x] 직진 우선 기본 노선·5칸 경로 미리보기
- [x] 연속 기관차 이동·경로 보간
- [x] 최대 8개 화차 위치 계산 기반
- [x] LOAD 선택 적재와 LIFO stack
- [x] 스테이션 6개와 색상별 pickup 최소 4개
- [x] 런타임 재생성 회복

증거:

- PR #9 / `801632949d28564528e38d83dac59cccc6f06fb2`
- PR #12 / `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
- PR #13 / `4e435a1a6d10ab146197671049da80709fd18c1f`
- Godot `9 cases / 6915 assertions / 0 failures`

남은 품질 증거: 실제 화면 가독성, 맵 다양성·경로 엔트로피, 장시간 soak.

## M2 — 총기획·정본 복구 · IN_PROGRESS

- [x] Post-VS02 실제 구현과 정본 드리프트 감사
- [x] 잘못 제공된 타 프로젝트 Sheet 제외
- [x] Post-VS02 GitHub 정본 복구·올바른 Sheet 동기화
- [x] 전체 기획 Coverage Matrix와 분야 간 적대적 검토
- [x] `SX-DEC-014` Combo 의미 확정·Sheet 동기화
- [x] `SX-DEC-015` compact wagon token·compressed footprint 확정·Sheet 동기화
- [x] `SX-DEC-016` 실제 첫 run 상황형 온보딩 승인·설계·TDD 계획
- [x] `SX-OPS-001` Grill Me 10건 batch merge·pre-merge audit 프로토콜
- [x] PR #27 병합 직전 GitHub·PR·Sheet 전수 감사
- [x] F21 역사 계약·F22 VS-03C 순서·F23 Sheet stale 행 수정
- [x] canonical merge `3cd13ff375a597d4eba9035af5b05e6186fb4853`
- [x] `SX-DEC-016`·`SX-OPS-001` Sheet 12탭 readback `PASS · SYNCED`
- [ ] `GMB-001`: `SX-DEC-017`부터 중요 Decision 10건, 현재 0/10
- [ ] 남은 중요 Grill Me 완료
- [ ] VS-03 Codex Definition of Ready

완료 기준: GitHub 정본·Issue·Plan·Sheet가 실제 구현과 일치하고, 중요한 기획 충돌이 Decision ID로 닫히며, 상세 수치는 시험값으로 구분된다. 정규 Grill Me batch는 10건 canonical merge와 Sheet closure까지 완료돼야 닫힌다.

## M3 — 핵심 생존 루프 · NOT_STARTED

### VS-03A · 생존 경제 도메인

- [ ] 시간 기반 기본 속도 상승
- [ ] 화물 수에 따른 속도 감소
- [ ] 시간 기반 연료 소모
- [ ] BOOST 속도·추가 연료 소모
- [ ] 하역 그룹 크기 기반 점수·연료 보상
- [ ] `SX-DEC-014` Combo·max_combo·speed_bonus 분리
- [ ] 무입력 영구 생존 방지
- [ ] 연료 0 게임오버와 결과 요약

### VS-03B · 제품 플레이 화면

- [ ] RailBoardView·SwitchView
- [ ] LOAD·BOOST·Unload Order HUD
- [ ] `COMBO ×N`·Run Max Combo·별도 speed bonus 피드백
- [ ] CargoStack→compact token count/order ViewModel
- [ ] fractional path history 기반 0~8 token 추종
- [ ] 8 token chain 2.18칸·trailing footprint 최대 3칸 시험값
- [ ] compressed footprint 기반 spawn exclusion
- [ ] rear token·HUD first item·CargoStack top parity
- [ ] 0/1/4/8·곡선 대표 캡처
- [ ] 결과 화면·즉시 재시작
- [ ] 최고 점수·최장 생존·최대 Combo 저장
- [ ] 저장 버전·손상 fallback
- [ ] 48dp·safe area·Reduced Motion·mute·haptic-off

### VS-03C · first-session contextual onboarding

- [ ] OnboardingState와 normalized domain events
- [ ] first-run assist policy: fuel drain 0.5×·escalation pause·120초·3초 restore `TEST_VALUE`
- [ ] 첫 LOAD·첫 switch safe pause
- [ ] mixed-stack LIFO proof와 첫 Combo proof
- [ ] 저연료 BOOST hint
- [ ] skip·timeout·resume·versioned preference
- [ ] Help 재생 시 assist 미활성
- [ ] assisted first run과 일반 balance telemetry 분리

M3 종료 기준: 한 세션이 시작→상황형 학습→운행→적재→compact token 변화→분기→LIFO 하역→Combo·보상→연료 0→결과→재시작까지 실제로 연결되고 자동 테스트가 통과한다.

## M4 — 목표 품질·플레이테스트 · NOT_STARTED

- [ ] telemetry와 저장 지속성 검증
- [ ] 10분 headless soak
- [ ] Android 실제 기기 실행·성능
- [ ] 첫 경험 사용자 5명 이상
- [ ] 4/5 LOAD·분기 독립 수행
- [ ] 4/5 rear-token LIFO 설명
- [ ] 4/5 Combo 의미 설명
- [ ] 3/5 안내 비과잉 평가
- [ ] first input 전 불공정 실패 0건
- [ ] 8 token 가독성·spawn 공정성 검증
- [ ] assisted first run과 일반 balance 분석 분리
- [ ] 맵 다양성·경로 엔트로피 측정
- [ ] 밸런스 재조정
- [ ] MUST_FIX 회귀 검증
- [ ] Production Gate

## M5 — Grill Me Batch 운영 · ACTIVE

책임 정본: `기획서/50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md`

```text
CATCH-UP-001: SX-DEC-014~016 · CLOSED
→ GMB-001: SX-DEC-017부터 0/10
→ 각 승인: batch branch/PR + Sheet APPROVED_PENDING_BATCH_MERGE
→ 10번째 승인: FREEZE + GitHub/PR/Sheet 12탭 adversarial audit
→ canonical merge + Sheet readback + Sync Closure
```

## 현재 실행 순서

```text
SX-DEC-014/015/016 · SX-OPS-001 GitHub/Sheet SYNCED
→ GMB-001 / SX-DEC-017부터 10건
→ G3P close
→ VS-03A
→ VS-03B
→ VS-03C
→ VS-04
→ Production Gate
```
