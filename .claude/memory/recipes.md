# Notion 자동화 Recipe

재실행이 승인된 작업만 둔다. 현재 등록된 recipe는 없다.

새 recipe는 [templates/recipe.md](../../templates/recipe.md)를 복사해 추가한다. 각 recipe는 다음
조건을 만족해야 한다.

- 대상 page/data_source ID가 workspace map에서 검증됨
- 안정적인 매칭 키와 정규화 규칙이 있음
- 0개/1개/여러 개 매칭 정책이 있음
- 속성·본문 매핑과 보존 범위가 분명함
- dry-run 예시와 검증식이 있음
- 재실행했을 때 중복 생성하지 않음

## Registry

| recipe_id | 상태 | 목적 | 대상 | 마지막 검증 |
|---|---|---|---|---|
| - | - | 아직 없음 | - | - |
