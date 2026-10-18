# 작성자와 같은 작업 환경 만들기

이 저장소를 만든 사람이 실제로 쓰는 도구와 버전입니다(2026-10-18 확인). 아래 프롬프트를 주면 LLM이 [tools/doctor.sh](../tools/doctor.sh)로
지금 컴퓨터에 무엇이 있는지 확인하고, 빠진 것만 하나씩 설치합니다.

```text
docs/ENVIRONMENT.md를 읽고 tools/doctor.sh로 내 컴퓨터를 확인해줘.
빠진 것만 「설치 명령」으로 하나씩 설치해줘. sudo, 원격 설치 스크립트(curl | sh), 전역 패키지 설치,
로그인이 필요한 단계는 실행 전에 명령을 보여주고 내가 승인하면 실행해줘. 끝나면 doctor.sh를 다시 돌려 결과를 보여줘.
```

로그인(Notion OAuth, `ntn login`, Codex 로그인, 학교 사이트)은 사람이 직접 합니다. LLM에게 비밀번호나 토큰을 붙여 넣지 마세요.

## 운영체제

| 항목 | 작성자 환경 | 메모 |
|---|---|---|
| OS | Windows + WSL2 Ubuntu 26.04 | 저장소는 WSL 안(`~/…`)에 둡니다. 심볼릭 링크와 셸 스크립트가 그대로 동작합니다 |
| 강의자료 원본 | Windows 폴더를 WSL `/mnt/c/…`로 읽음 | 경로는 SETUP.md 3절에 적습니다 |

macOS도 대부분 그대로 됩니다. `apt` 대신 `brew install ffmpeg poppler gh coreutils`를 쓰면 됩니다(작성자는 시험하지 않음). `coreutils`는 `tools/doctor.sh`의 시간 제한(`gtimeout`)에 씁니다.

## 도구

| 도구 | 작성자 버전 | 쓰는 곳 | 필요 |
|---|---|---|---|
| Claude Code | 2.1.302 | 작업자. 스킬 실행, Notion 쓰기 | 필수 |
| Notion MCP | 원격(`mcp.notion.com`) | Notion 읽기·쓰기. 설치 없이 저장소 `.mcp.json`을 승인하고 `/mcp`에서 OAuth | 필수 |
| git, gh | 2.53.0, 2.46.0 | 버전 관리 | 필수 |
| Python 3 + Pillow | 3.14.4, 12.1.1 | 린터, 캡처 자르기 | 필수 |
| poppler (`pdftoppm`, `pdftotext`, `pdfinfo`) | 26.01.0 | PDF 쪽 렌더링·쪽별 텍스트 | 필수 |
| uv | 0.13.1 | MarkItDown, Whisper 실행 | 필수 |
| MarkItDown CLI | 0.1.8 (`pdf,docx,pptx,xlsx`) | docx·pptx·xlsx·PDF → 검색용 Markdown | 필수 |
| Node.js (nvm) | 24.21.0 | Codex·ntn·Playwright 실행 | 필수 |
| Codex CLI | 0.162.1 | 교차검토, 긴 초안 | 권장 |
| Notion CLI `ntn` | 0.23.20 | 캡처·PDF 일괄 업로드([NOTION-CLI.md](NOTION-CLI.md)) | 권장 |
| Playwright MCP | `@playwright/mcp@0.0.83` | 학교 LMS 조회, CLOVA Note 웹 전사 | 강의 영상을 받을 때 |
| ffmpeg | 8.0.1 | 영상 → mp3 (`tools/lecture-to-audio.sh`) | 녹음을 쓸 때 |
| Whisper | `whisper-ctranslate2==0.5.7` | 로컬 전사. `tools/transcribe.sh`가 `uvx`로 그때 실행하므로 따로 설치하지 않음 | 선택 |
| Codex Notion 플러그인 | `notion@openai-curated-remote` 3.0.1 | Codex가 작업자로 Notion을 다룰 때 | 선택 |
| Claude Code Codex 플러그인 | `codex@openai-codex` 1.0.6 | 대화 중 `/codex:*` 명령 | 선택 |

## 설치 명령 (Ubuntu/WSL)

시스템 패키지(`sudo` 필요):

```bash
sudo apt install git gh python3 python3-pil poppler-utils ffmpeg
```

원격 설치 스크립트(내 계정 폴더에 설치, `sudo` 불필요):

```bash
curl -fsSL https://claude.ai/install.sh | bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Node.js는 [nvm 안내](https://github.com/nvm-sh/nvm#installing-and-updating)대로 nvm을 설치한 뒤:

```bash
nvm install 24
```

내 계정 폴더에 까는 도구(`sudo` 붙이지 않음):

```bash
uv tool install 'markitdown[pdf,docx,pptx,xlsx]==0.1.8'
npm install -g @openai/codex@0.162.1
npm install -g ntn@0.23.20
claude mcp add playwright -s user -- npx -y @playwright/mcp@0.0.83
codex mcp add playwright -- npx -y @playwright/mcp@0.0.83
```

로그인(사람이 직접 브라우저에서):

```bash
claude          # 첫 실행 때 로그인, 저장소 폴더에서 /mcp → notion OAuth
codex login
ntn login
```

선택 플러그인:

- Codex Notion 플러그인: Codex 앱·CLI의 플러그인 목록에서 Notion 설치
- Claude Code Codex 플러그인: Claude Code에서 `/plugin marketplace add openai/codex-plugin-cc` → `/plugin install codex@openai-codex`

## 일부러 켜지 않은 것

| 도구 | 이유 |
|---|---|
| MarkItDown **MCP 서버** | `file:`·`http(s):` 주소를 아무거나 읽을 수 있어, 강의자료에 숨은 지시문이 로컬 파일을 읽어 밖으로 보내게 만들 수 있습니다. 작성자도 CLI만 씁니다 |
| PDF MCP 서버 | 저장소 `.mcp.json`에 선언돼 있지만 작성자는 `pdftoppm` 렌더링으로 PDF를 봅니다. 쓰지 않으려면 `.claude/settings.local.json`의 `disabledMcpjsonServers`에 `"pdf"`를 넣습니다 |

## 확인

```bash
tools/doctor.sh          # 도구가 실행되는지와 버전, notion MCP 연결
claude mcp list          # notion, playwright 연결 상태
codex mcp list           # Codex 쪽 MCP
ntn doctor               # Notion CLI 인증
```

버전은 작성자가 확인한 값입니다. `apt` 패키지는 배포판 버전을 따르고, 더 새 버전을 써도 대부분 됩니다. 문제가 생기면 표의 버전으로 맞추고, 모델 이름처럼 계정마다 다른 값은 SETUP.md 7절과
[CUSTOMIZE.md](CUSTOMIZE.md)대로 바꿉니다.
