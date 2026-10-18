# Materials

강의 PDF·필기 PDF·TXT를 Notion에 옮기기 전 출처와 파생물을 관리하는 로컬 작업 구역이다.

```text
materials/
├── inbox/                       # 사용자가 막 넣은 원본
├── guides/
│   ├── original/                # 사용자가 파일로 준 AI 활용 기준 문서
│   └── extracted/               # 검색용 추출문
├── courses/
│   └── <course-slug>/
│       ├── video/               # 학교 LMS에서 받은 강의 영상(개인 학습용)
│       ├── audio/               # 전사용 mp3 (tools/lecture-to-audio.sh)
│       ├── transcripts/         # 로컬 Whisper 전사 txt/srt (tools/transcribe.sh)
│       ├── source/              # 확인된 원본 PDF/TXT, CLOVA Note 전사 TXT
│       ├── extracted/           # MarkItDown/OCR/pdftotext 결과
│       └── captures/            # Notion에 넣을 검증된 캡처
└── index.md                     # 파일·페이지·캡처 출처표
```

새 과목은 `courses/_template` 구조를 복사해 만든다. 원본과 파생 파일은 저작권·개인정보·용량
문제로 기본 git ignore 대상이다. 파일을 옮기거나 이름을 바꾸기 전에 사용자의 참조 경로가
깨지지 않는지 확인한다.

MarkItDown 추출문은 검색용이다. 공식 PDF MCP나 로컬 렌더링으로 PDF 표, 그림, 수식, 손필기,
색 강조와 슬라이드 배치를 직접 확인한다. 캡처 규칙은
[learning-materials.md](../.claude/rules/learning-materials.md)를 따른다.
