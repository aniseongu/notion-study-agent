# 오류 로그

다음 세션에서 반복하면 안 되는 실패만 기록한다. 같은 실패가 두 번 나오면 로그를 늘리지 말고 규칙·recipe·검사 도구로 승격한다.

형식:

```text
## YYYY-MM-DD — 요약
- 증상:
- 원인:
- 영향:
- 해결:
- 재발 방지:
```

## 처음 쓰는 사람이 자주 겪는 것

- Notion MCP는 없는 select 옵션을 자동으로 만들지 않는다. 새 `Week N` 같은 옵션은 스키마 변경으로 먼저 추가해야 한다.
- Claude CLI 검토에서 `--tools`만으로는 MCP 쓰기 도구가 꺼지지 않는다. `--strict-mcp-config`와 `--disallowedTools "mcp__*"`를 함께 쓴다([cross-review.md](../rules/cross-review.md)).
- Notion 쓰기 인자의 한글을 `\uXXXX`로 손수 이스케이프하면 다른 글자로 바뀐다. 원문 그대로 보낸다.
