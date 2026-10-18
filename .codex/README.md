# Codex 진입점

Codex가 자동으로 읽는 공용 규칙은 루트 [AGENTS.md](../AGENTS.md)다. 이 폴더는 Codex 전용
설정과 공용 자료의 탐색 별칭만 둔다.

- `config.toml`: 이 프로젝트의 기본값은 `gpt-6-sol`과 high reasoning. 작업별 모델은 tool-routing.md의 선택표로 바꾼다
- `skills` → `../.claude/skills`
- `rules` → `../.claude/rules`
- `memory` → `../.claude/memory`
- `plans` → `../plans`
- `logs` → `../logs`

규칙·메모리·계획은 Claude 전용 데이터가 아니다. 두 도구가 같은 원본을 읽도록 심링크만 두며,
`.codex/` 아래에 별도 사본을 만들지 않는다. Codex는 작업 시작 시 `AGENTS.md`의 링크를 따라
필요한 rule, memory, plan, skill을 읽는다.

모델은 작업에 맞게 고른다(긴 초안·검토 `gpt-6-sol`, 단순 대량 점검 `gpt-6-luna`, 가장 어려운 검산 `gpt-6-astra`,
이전 세대도 허용). 선택표와 실패 시 대체는 [tool-routing.md](../.claude/rules/tool-routing.md)에 있다.

Codex도 설치된 Notion 플러그인(`notion@openai-curated-remote`)으로 Notion을 읽고 쓸 수 있다. 작업자로 Notion을 다룰 때는
`--disable apps --disable plugins`를 쓰지 않고, 검토·초안 호출에서만 그 인자로 끈다. 밈·커뮤체는
[meme-dictionary.md](../.claude/memory/meme-dictionary.md)를 쓴다.

Codex 자체의 대화 기억은 장기 작업 원본으로 취급하지 않는다. 다시 써야 할 사실은
`workspace-map.md`, 결정은 `decisions.md`, 반복 절차는 `recipes.md`, 실행 상태는 `plans/`, 날짜별 변경은 `logs/daily/`에 기록한다.
