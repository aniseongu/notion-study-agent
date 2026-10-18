# Plans

이 폴더는 새 자동화, 대량 작업, 파괴적 작업의 실행 전 계약과 교차검토 패킷을 둔다.

파일명은 `YYYY-MM-DD-short-name.md`로 한다. [templates/plan.md](../templates/plan.md)에서 시작하고,
필요하면 같은 파일 안에 review packet을 붙이거나 별도 `-review.md` 파일을 만든다.

상태는 `draft → reviewed → approved → running → completed/blocked` 순서로 갱신한다.

- 단건·낮은 위험 작업에는 plan을 억지로 만들지 않는다.
- 완료된 plan에서 반복 가치가 확인되면 핵심 계약을 `recipes.md`로 옮긴다.
- Notion 본문·대화 전문·자격 증명·민감 정보는 plan에 복사하지 않는다.
- `plans/tmp/`는 임시 출력용이며 git에서 제외한다.
