---
paths:
  - "plans/**"
  - "templates/review-packet.md"
  - ".claude/skills/cross-review/**"
---

# Claude ↔ Codex 양방향 교차검토

상위 규칙: [AGENTS.md 5절](../../AGENTS.md).

검토 목적은 같은 모델이 자기 계획을 다시 읽는 것보다, 반대 도구가 누락·오해·파괴 범위를
독립적으로 찾게 하는 것이다. 검토자는 실행자가 아니며 파일과 Notion을 수정하지 않는다.

## 검토 입력

[review-packet 템플릿](../../templates/review-packet.md)에 다음 근거를 넣는다.

- 사용자의 원래 목적과 승인된 범위
- 과목 작업이면 `AI 활용 문서` fetch 시각·최종 수정과 이번 작업에 걸리는 절 요약([course-ai-docs.md](course-ai-docs.md))
- 대상 URL/ID와 fetch 시각
- 실제 스키마 요약
- 전체 예상 건수와 대표 샘플 3건
- 매칭 키, 필드 매핑, 충돌 정책
- 바뀌는 것과 보존할 것
- 실패·재시도·보상 정책
- 실행 후에는 실제 건수와 재조회 증거

본문 원문이나 민감 정보를 통째로 넣지 않는다. 검토에 필요한 최소 발췌만 쓴다.

## Claude가 작업자일 때: Codex 검토

Codex CLI를 OS 수준 읽기 전용 샌드박스로 실행한다. `--ignore-user-config`로 사용자
`config.toml`의 MCP 서버를 로드하지 않고, project `.codex/config.toml`과 `AGENTS.md`는 유지한다.
기본 모델은 `gpt-6-sol`(high)이고, 작업에 따라 [tool-routing.md](tool-routing.md)의 선택표대로 고른다(2026-10-05 사용자 위임).

```bash
codex exec \
  --ignore-user-config \
  --disable apps \
  --disable plugins \
  -c model_reasoning_effort=\"high\" \
  --model gpt-6-sol \
  --sandbox read-only \
  --ephemeral \
  --cd "$PWD" \
  "AGENTS.md와 지정한 review packet을 읽고 Notion 변경을 검토하라. 파일이나 Notion을 수정하지
  마라. 범위, 대상 식별, 스키마 보존, 멱등성, pagination, 재시도, 검증, 복구 가능성을 확인하고
  PASS 또는 BLOCK으로 답하라."
```

대화형 Claude 세션에서 사람이 직접 검토를 요청할 때는 설치된 `codex@openai-codex` 플러그인의
`/codex:adversarial-review`도 쓸 수 있다. 모델을 확실히 고정할 때는 위
`codex exec` 경로를 우선한다.

모델이 Codex CLI 버전·계정에 따라 목록에 없을 수 있다(2026-09-30 전역 `codex-cli 0.154.0`은 `gpt-6-sol`에서 400,
2026-10-05 전역 `0.159.0`은 `gpt-6.1-sol`·`gpt-6-astra`·`gpt-6-luna` 모두 통과). 이 경우 tool-routing.md 선택표의 다음
후보 모델로 한 단계씩 내려가고, 구버전 전역 CLI의 model-catalog 오류에는 설치된 `openai.chatgpt-*` 확장의 최신 내장
`codex`로 같은 모델을 한 번 재시도할 수 있다. 어느 경우든 `--ignore-user-config --disable apps --disable plugins
--sandbox read-only`를 유지하고, 실제로 쓴 모델을 결과 보고에 적는다.

## Codex가 작업자일 때: Claude Opus 5.5 검토

Claude를 plan 권한과 읽기 도구만으로 실행한다. 프로젝트 `CLAUDE.md`와 `AGENTS.md`를 자동으로
읽으며, 세션 기록은 남기지 않는다.

```bash
tools/claude-review.sh "CLAUDE.md와 지정한 review packet을 읽고 Notion 변경을 검토하라. 파일이나 Notion을 수정하지
마라. 범위, 대상 식별, 스키마 보존, 멱등성, pagination, 재시도, 검증, 복구 가능성을 확인하고
PASS 또는 BLOCK으로 답하라."
```

라이브 Notion 재조회는 작업자가 수행해 packet에 증거를 넣는다. `--strict-mcp-config`와
`--disallowedTools "mcp__*"`, `ENABLE_CLAUDEAI_MCP_SERVERS=false`를 함께 써서 검토자에게
project/user/claude.ai MCP를 로드하지 않는다. 검토자에게 Notion 쓰기 권한을 주지 않는다.
실행기는 검토 호출을 직렬화하고 OAuth 갱신 충돌 오류가 난 경우에만 30초 간격으로 최대 두 번
재시도한다. 다른 오류는 그대로 반환하며 인증 파일이나 Claude의 잠금 파일을 지우지 않는다.

## 출력 계약

```text
VERDICT: PASS | BLOCK
BLOCKERS:
- 없음, 또는 실행 전 반드시 고칠 문제
WARNINGS:
- 실행을 막지는 않지만 확인할 문제
EVIDENCE_GAPS:
- 판단에 필요한데 packet에 없는 근거
CHECKED:
- 실제로 확인한 항목
```

`BLOCK`은 중복 생성, 잘못된 대상, 데이터 손실, 승인되지 않은 범위 확대, 검증 불가능처럼 결과를
바꿀 수 있는 문제에만 쓴다. 문체나 취향은 `WARNING`이다.

## 실패 처리

- 검토 CLI가 없거나 인증되지 않았거나 지정 모델이 지원되지 않으면 한 번 진단한다. 전역
  Codex가 model-catalog 오류를 낸 경우에만 최신 공식 VS Code 확장 내장 CLI로 같은 모델을 한
  번 재시도한다. 그 외 반복 실행은 금지하고, 모델 변경은 선택표 안에서만 하며 보고한다.
- 같은 blocker를 수정한 뒤 재검토는 한 번까지 한다.
- 두 번째에도 같은 blocker가 남거나 두 도구가 상반된 결론을 내면 사용자에게 근거를 나란히
  보여 주고 판단을 요청한다.
- 검토 도구가 파일을 바꿨다면 결과를 채택하지 말고 diff를 확인한다. 읽기 전용 위반을
  [error-log.md](../memory/error-log.md)에 기록한다.
