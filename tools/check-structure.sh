#!/bin/sh
set -eu

required_files='
AGENTS.md
CLAUDE.md
PLANS.md
.codex/README.md
.codex/config.toml
.mcp.json
.claude/rules/notion-safety.md
.claude/rules/cross-review.md
.claude/rules/tool-routing.md
.claude/rules/content-style.md
.claude/rules/memory-policy.md
.claude/rules/learning-materials.md
.claude/rules/course-ai-docs.md
.claude/memory/workspace-map.md
.claude/memory/recipes.md
.claude/memory/decisions.md
.claude/memory/error-log.md
.claude/memory/style-profile.md
.claude/skills/map-notion-workspace/SKILL.md
.claude/skills/capture-to-notion/SKILL.md
.claude/skills/run-notion-automation/SKILL.md
.claude/skills/audit-notion/SKILL.md
.claude/skills/cross-review/SKILL.md
.claude/skills/ingest-learning-materials/SKILL.md
.claude/skills/publish-learning-notes/SKILL.md
.claude/skills/build-textbook-problem-bank/SKILL.md
tools/lecture-to-audio.sh
tools/transcribe.sh
plans/README.md
logs/README.md
materials/README.md
materials/index.md
docs/ARCHITECTURE.md
docs/INTEGRATIONS.md
templates/plan.md
templates/review-packet.md
templates/recipe.md
templates/daily-log.md
SETUP.md
docs/CUSTOMIZE.md
docs/NOTION-CLI.md
.claude/skills/adapt-to-my-setup/SKILL.md
templates/ai-usage-doc.md
templates/lecture-download-skill.md
'

required_dirs='
plans
logs/daily
materials/inbox
materials/courses
'

failed=0
for file in $required_files; do
    if [ ! -f "$file" ]; then
        echo "missing: $file" >&2
        failed=1
    fi
done

for dir in $required_dirs; do
    if [ ! -d "$dir" ]; then
        echo "missing directory: $dir" >&2
        failed=1
    fi
done

for link_spec in "skills:../.claude/skills" "rules:../.claude/rules" "memory:../.claude/memory" "plans:../plans" "logs:../logs"; do
    link_name=${link_spec%%:*}
    link_target=${link_spec#*:}
    if [ ! -L ".codex/$link_name" ]; then
        echo "missing symlink: .codex/$link_name" >&2
        failed=1
    elif [ "$(readlink ".codex/$link_name")" != "$link_target" ]; then
        echo "wrong symlink target: .codex/$link_name" >&2
        failed=1
    fi
done

for skill in .claude/skills/*/SKILL.md; do
    if ! grep -q '^name:' "$skill" || ! grep -q '^description:' "$skill"; then
        echo "invalid skill frontmatter: $skill" >&2
        failed=1
    fi
done

# 과목 Notion 작업 진입점은 모두 과목별 AI 활용 문서 읽기 규칙을 가리켜야 한다(2026-10-07).
for doc in AGENTS.md CLAUDE.md \
    .claude/rules/learning-materials.md \
    .claude/rules/notion-safety.md \
    .claude/rules/content-style.md \
    .claude/rules/cross-review.md \
    .claude/skills/cross-review/SKILL.md \
    .claude/skills/publish-learning-notes/SKILL.md \
    .claude/skills/ingest-learning-materials/SKILL.md \
    .claude/skills/build-textbook-problem-bank/SKILL.md \
    .claude/skills/capture-to-notion/SKILL.md \
    .claude/skills/run-notion-automation/SKILL.md \
    .claude/skills/audit-notion/SKILL.md \
    .claude/skills/map-notion-workspace/SKILL.md; do
    if ! grep -q 'course-ai-docs.md' "$doc"; then
        echo "missing AI 활용 문서 rule link (course-ai-docs.md): $doc" >&2
        failed=1
    fi
done
for tpl in templates/plan.md templates/review-packet.md templates/daily-log.md templates/recipe.md; do
    if ! grep -q 'AI 활용 문서' "$tpl"; then
        echo "missing AI 활용 문서 field: $tpl" >&2
        failed=1
    fi
done

check_lines() {
    file=$1
    limit=$2
    lines=$(wc -l < "$file")
    if [ "$lines" -gt "$limit" ]; then
        echo "warning: $file has $lines lines (target <= $limit)" >&2
    fi
}

check_lines AGENTS.md 260
check_lines CLAUDE.md 120
check_lines .claude/memory/error-log.md 200

if [ "$failed" -ne 0 ]; then
    exit 1
fi

echo 'NotionAction structure: OK'
