# CLAUDE.md

@AGENTS.md

위 import가 Claude Code와 Codex가 공유하는 규칙 원본이다. 공용 규칙은 `AGENTS.md`에서만
고치고, 이 파일에는 Claude Code 전용 진입점만 둔다.

## 스킬 인덱스

| 상황 | 스킬 |
|---|---|
| 강의 PDF·필기 PDF·TXT를 읽고 출처와 캡처 후보를 만들 때 | [ingest-learning-materials](.claude/skills/ingest-learning-materials/SKILL.md) |
| 실제 `AI 활용 문서`와 기존 말투대로 학습 노트를 Notion에 게시할 때 | [publish-learning-notes](.claude/skills/publish-learning-notes/SKILL.md) |
| 강의 범위의 교재 문제를 빠짐없이 문제은행에 넣을 때 (그림은 캡처) | [build-textbook-problem-bank](.claude/skills/build-textbook-problem-bank/SKILL.md) |
| 기출·교재·과제 문제의 정답·풀이·코드를 직접 요청할 때 | [answer-study-questions](.claude/skills/answer-study-questions/SKILL.md) |
| 처음 받아서 SETUP.md대로 내 학교·과목·Notion에 맞출 때 | [adapt-to-my-setup](.claude/skills/adapt-to-my-setup/SKILL.md) |
| 처음 연결하거나 대상 DB/페이지가 불명확할 때 | [map-notion-workspace](.claude/skills/map-notion-workspace/SKILL.md) |
| 대화·메모·결정을 Notion에 정리할 때 | [capture-to-notion](.claude/skills/capture-to-notion/SKILL.md) |
| 확정된 반복·대량 작업을 실행할 때 | [run-notion-automation](.claude/skills/run-notion-automation/SKILL.md) |
| 중복·누락·스키마 상태를 읽기 전용으로 점검할 때 | [audit-notion](.claude/skills/audit-notion/SKILL.md) |
| Codex와 계획/결과를 교차검토할 때 | [cross-review](.claude/skills/cross-review/SKILL.md) |

## 세션 시작 시

1. `AGENTS.md` 1절을 확인한다.
2. [.claude/memory/error-log.md](.claude/memory/error-log.md)와
   [.claude/memory/workspace-map.md](.claude/memory/workspace-map.md)를 읽는다.
3. 반복 작업이면 실행 전에 [recipes.md](.claude/memory/recipes.md)의 해당 recipe를 읽는다.
4. 과목 Notion 작업이면 어떤 스킬보다 먼저 Notion의 그 과목 `AI 활용 문서`를 live fetch해 전부 읽는다
   (ID: workspace-map 「학업 작성 기준 페이지」, 절차: [course-ai-docs.md](.claude/rules/course-ai-docs.md)).

## Claude Code 전용 동작

- 일반 작업의 Claude 모델은 고정하지 않고 작업 성격에 맞춰 고른다. CLI 교차검토는 `AGENTS.md` 5절의 검토자 모델을 명시한다.

- Notion 작업 전 `/mcp`로 `notion` 연결을 확인한다. 루트 `.mcp.json`은 프로젝트 공용 연결
  선언이며, 최초 사용 시 사용자가 대화형 승인을 완료해야 할 수 있다.
- 중요한 Notion 변경을 Claude가 수행할 때는 `cross-review` 스킬로 Codex
  읽기 전용 검토(모델은 tool-routing.md의 선택표, 기본 `gpt-6-sol`)를 먼저 받는다.
- Codex 검토는 `codex exec --sandbox read-only`를 우선한다. 설치된 `codex@openai-codex`
  플러그인의 `/codex:*` 명령은 사람이 대화형으로 호출할 때 쓸 수 있다.
- 강의 페이지·문제 해설처럼 긴 초안은 Codex에 맡겨 Claude 토큰을 아낀다. Claude는 원본 이미지
  판독·입력 패킷 작성·검수·게시를 맡는다. 분담표와 호출법은
  [tool-routing.md의 Codex 위임 절](.claude/rules/tool-routing.md)을 따른다.
- 검토 결과를 그대로 채택하지 말고 대상 스키마와 재조회 결과로 직접 확인한다.
- Notion MCP가 연결되지 않았으면 로컬 문서만 준비하고, 연결되지 않은 상태에서 완료했다고
  보고하지 않는다.
