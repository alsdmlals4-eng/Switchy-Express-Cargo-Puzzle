---
contract_name: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION
contract_version: '4.5'
revision: '2026-08-11-r2'
status: CURRENT_GITHUB_CANONICAL_WORK_INSTRUCTION_BUNDLE
canonical_payload_encoding: UTF-8
canonical_payload_bytes: 77734
canonical_payload_lf_count: 2849
canonical_payload_sha256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
canonical_payload_git_blob_sha1: de7c6f818a4c96d2a02edea5eaff33bb1c39e8da
planning_completion_trigger: USER_EXPLICIT_PLANNING_COMPLETE_DECLARATION
phase_b_required_before_build: true
---

# 프로젝트 총기획·검수·구현·병합·로컬 실행 통합 작업지시문 v4.5 r2 — GitHub Canon

이 파일은 프로젝트의 **현재 작업지시문 정본 locator/manifest**다. 사용자가 제공한 `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md` 원문은 GitHub connector의 단일 대용량 local-file streaming 제약 때문에 임의로 재타이핑하지 않고, 아래 content-addressed segment를 **표시된 순서 그대로, 바이트 구분자 없이 연결**한 payload로 보존한다.

이 bundle의 재구성 결과는 첨부 원본과 정확히 동일하다.

```text
bytes: 77734
LF count: 2849
SHA-256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
Git blob SHA-1: de7c6f818a4c96d2a02edea5eaff33bb1c39e8da
revision: 2026-08-11-r2
```

## Canonical payload segments

| 순서 | 경로 | bytes | SHA-256 | Git blob SHA-1 |
|---:|---|---:|---|---|
| 1 | `docs/work-instructions/v4.5_r2/payload.part01.md` | 13494 | `13b457a6fc3a704ca7ee4f534af803b600c0a3d8e457ec92538c707dcf379828` | `140a1bf3087e4136f22a289d83980e33c232822b` |
| 2 | `docs/work-instructions/v4.5_r2/payload.part02.md` | 13492 | `78b2a048ec9d929553bc95e47f86d1cc3a399bb24ab26ea523c67bcda55c7102` | `4c5697286fc86a7bb82e158c1ae2f04f6a4d2155` |
| 3 | `docs/work-instructions/v4.5_r2/payload.part03.md` | 13486 | `a6a0319723fbdf8901a7afacf0bb8d3c0eac75247dc430d1cb534393bf51b6ea` | `2fbcc2742ed16a00ec516d2a113849137402077a` |
| 4 | `docs/work-instructions/v4.5_r2/payload.part04.md` | 13463 | `2f8ec2950d8ce6067939da381c7188ecc6e83dfcbc88e460442276fa506e5dd7` | `038c570807473ce4514e4827b1b3d326fa347cde` |
| 5 | `docs/work-instructions/v4.5_r2/payload.part04.eof-lf` | 1 | `01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b` | `8b137891791fe96927ad78e64b0aad7bded08bdc` |
| 6 | `docs/work-instructions/v4.5_r2/payload.part05.md` | 13485 | `c138ede7b8210136948112a97acff646c7f1be27ca917a2bd625a8c58750eef4` | `e080c88d6d12c18a89de1a1251eaf8eaa2ba624d` |
| 7 | `docs/work-instructions/v4.5_r2/payload.part06.md` | 10313 | `3ae42f63a2ba263149e6d5b9fa613ff7b2a05aa2115d08b32fa1a532453f9f80` | `642add5f573c90f5911aec0b021c10d486f3d5fb` |

## Byte-exact reconstruction contract

다음 의미와 동등한 **binary concatenation**만 정본 payload를 복원한다. part 사이에 공백·개행·구분자를 새로 삽입하지 않는다.

```python
from hashlib import sha256
from pathlib import Path

parts = [
    "docs/work-instructions/v4.5_r2/payload.part01.md",
    "docs/work-instructions/v4.5_r2/payload.part02.md",
    "docs/work-instructions/v4.5_r2/payload.part03.md",
    "docs/work-instructions/v4.5_r2/payload.part04.md",
    "docs/work-instructions/v4.5_r2/payload.part04.eof-lf",
    "docs/work-instructions/v4.5_r2/payload.part05.md",
    "docs/work-instructions/v4.5_r2/payload.part06.md",
]
payload = b"".join(Path(path).read_bytes() for path in parts)
assert len(payload) == 77734
assert payload.count(b"\n") == 2849
assert sha256(payload).hexdigest() == "3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4"
```

## Authority boundary

- 이 r2 bundle이 병합되면 이전 대화/업로드의 v4.4·초기 v4.5 작업지시문은 역사적 외부 증거다.
- 이 파일은 Base 정본을 복제하지 않는 프로젝트 Thin Adapter다. 매 작업 시작 시 Base current `main`을 다시 읽는다.
- 제품 규칙은 `CURRENT_CONFIRMED_DECISIONS`와 등록된 분야 정본이 계속 소유한다. 이 작업지시문 교체는 새 제품 Decision을 만들지 않는다.
- 현재 Phase A evidence는 `READY_FOR_USER_PLANNING_COMPLETE_GATE`다.
- 사용자가 명시적으로 `기획 완료`를 선언하지 않았으므로 user planning-complete Gate는 아직 `NOT_GRANTED`다.
- Phase B는 `NOT_RUN`, PowerShell/Codex/Godot BUILD는 `BLOCKED`다.
- 이번 사용자의 `권장안대로 승인 · 연속작업 진행 · GitHub 정본 교체`는 **이 문서/정본 교체와 승인 범위의 PR 검증·병합**을 허가하지만 `기획 완료` 선언으로 확장 해석하지 않는다.

## Provenance

교체·검증 감사: `SX-AUD-045`

설계/실행 계획:

- `docs/superpowers/specs/2026-08-11-v4-5-r2-work-instruction-canon-design.md`
- `docs/superpowers/plans/2026-08-11-v4-5-r2-work-instruction-canon.md`
