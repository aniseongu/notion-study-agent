# MCP·플러그인·CLI 연결

연결 상태는 세션마다 다릅니다. 지난번에 연결됐다는 기억만 믿지 말고 작업을 시작할 때 다시 확인합니다.

## Claude Code

루트 [.mcp.json](../.mcp.json)이 프로젝트 공용 MCP 두 개를 선언합니다.

| 서버 | 쓰는 곳 |
|---|---|
| `notion` (`https://mcp.notion.com/mcp`) | Notion 읽기·쓰기. OAuth라 토큰을 파일에 둘 필요가 없음 |
| `pdf` | `./materials` 아래 PDF의 쪽 검색·스크린샷. 이 폴더 밖은 열지 않음 |

```bash
claude mcp list
claude mcp get notion
```

처음 열 때 `.mcp.json` 서버를 승인하고 `/mcp`에서 `notion` OAuth를 마칩니다. 같은 프로젝트에서 Claude Code 세션을 여러 개
동시에 시작하면 OAuth 갱신이 충돌할 수 있으니 하나씩 여세요.

MarkItDown은 **CLI로만** 씁니다: `markitdown <파일> -o <out.md>` (`uv tool install 'markitdown[pdf,docx,pptx,xlsx]'`).
MarkItDown MCP 서버는 `file:`·`http(s):` 주소를 아무거나 읽을 수 있어, 강의자료나 웹페이지에 숨은 지시문이 로컬 파일을 읽어 밖으로
보내게 만들 수 있습니다. 그래서 `.mcp.json`에 넣지 않았습니다. CLI는 내가 지정한 파일만 변환합니다.

## Codex

Codex는 루트 [AGENTS.md](../AGENTS.md)를 자동으로 읽습니다. Notion은 Codex 앱의 Notion 플러그인으로 쓰거나 CLI에 MCP를 붙입니다.

```bash
codex mcp add notion --url https://mcp.notion.com/mcp
codex mcp login notion
codex mcp list
```

- **작업자로 Notion에 쓸 때:** 플러그인·MCP를 켠 `codex exec`.
- **검토·초안을 맡길 때:** `--ignore-user-config --disable apps --disable plugins --sandbox read-only`로 Notion과 파일 쓰기를 모두 끕니다.
- 모델은 계정마다 다릅니다. `codex debug models`로 목록을 보고 [tool-routing.md](../.claude/rules/tool-routing.md)의 선택표를 고칩니다.

교차검토 명령과 packet 형식은 [cross-review.md](../.claude/rules/cross-review.md)에 있습니다.

## Notion CLI

로컬 캡처·PDF 업로드와 스크립트 작업에 씁니다. [NOTION-CLI.md](NOTION-CLI.md)를 보세요.

## PDF를 MCP 없이 볼 때

```bash
pdfinfo materials/courses/<course>/source/<file>.pdf
mkdir -p plans/tmp/pdf-render/<source-id>
pdftoppm -f 12 -l 14 -png -r 180 materials/courses/<course>/source/<file>.pdf plans/tmp/pdf-render/<source-id>/page
```

한 번에 1~3쪽만 렌더링해 직접 보고, 최종 crop만 `captures/`로 옮깁니다. PDF 쪽과 슬라이드 번호는 `materials/index.md`에 따로 적습니다.

## 개념 구분

- **Skill:** 모델에게 반복 절차와 판단 기준을 줍니다.
- **MCP:** Notion 같은 외부 서비스의 도구와 데이터를 연결합니다.
- **Plugin:** skill, MCP, hook을 설치 가능한 한 단위로 묶습니다.
