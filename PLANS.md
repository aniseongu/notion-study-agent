# 실행 계획 규칙

복잡하거나 위험한 Notion 작업은 [plans/](plans/)에 ExecPlan을 만든다. Codex와 Claude 모두
같은 계획 파일을 읽고 갱신한다.

계획이 필요한 경우:

- 처음 실행하는 반복 자동화
- 10개 이상 생성·수정
- 둘 이상의 데이터 소스나 상위 페이지
- 스키마·보기·관계 변경
- 이동·병합·보관·삭제·본문 전체 교체
- 여러 PDF/TXT를 합쳐 새 학습 구조를 만드는 작업

파일명은 `YYYY-MM-DD-short-name.md`이고 [templates/plan.md](templates/plan.md)를 사용한다.
계획은 목적, 범위, live 근거, source coverage, 매칭 키, dry run, 위험·복구, 교차검토,
실행 결과와 read-back 검증을 포함한다.

계획은 실행 중에도 갱신하는 living document다. 대화 전문이나 Notion 본문 전체를 복사하지
않고, 다음 세션이 같은 결과를 재현하는 데 필요한 결정과 증거만 남긴다.
