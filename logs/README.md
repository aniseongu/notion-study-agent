# Daily logs

`logs/daily/YYYY-MM-DD.md`는 그날의 material change를 다음 세션이 빠르게 이어받도록 남기는
작업 이력이다. 한 날짜에는 파일 하나만 쓰고, 같은 날 작업은 섹션을 추가한다.

기록할 것:

- 사용자가 원한 결과
- 실제 변경 파일과 외부 변경 범위
- 확정된 결정과 이유
- 실행한 검증과 PASS/BLOCK
- 남은 일과 다음 시작점

기록하지 않을 것:

- 전체 대화와 도구 출력 원문
- Notion 페이지 본문 전체
- 비밀번호, 토큰, 이메일, 실명 등 개인정보
- 이미 `decisions.md`나 recipe에 있는 규칙의 장문 복제

장기 운영 결정은 `.claude/memory/decisions.md`, 재실행 계약은 `recipes.md`, 위험 작업의 실행
계획은 `plans/`가 원본이다. daily log는 링크와 짧은 진행 이력만 남긴다.
