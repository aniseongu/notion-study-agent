---
name: adapt-to-my-setup
description: Read the user's filled-in SETUP.md and adapt this repository's rules, skills, memory templates, and model settings to their school, LMS, local folders, courses, Notion structure, and tone by following docs/CUSTOMIZE.md. Local files only; never writes to Notion.
---

# Adapt This Repository to My Setup

The repository ships with the original author's situation as worked examples. This skill rewrites only the
situation-specific parts listed in [docs/CUSTOMIZE.md](../../../docs/CUSTOMIZE.md) so they match the user's
[SETUP.md](../../../SETUP.md). Shared safety rules stay as they are.

## Invariants

- **Local files only.** Do not create, edit, or move anything in Notion here. Notion mapping is a separate,
  read-only step (`map-notion-workspace`) that the user starts.
- Change only the rows of the CUSTOMIZE.md "꼭 바꿔야 하는 곳" table that differ from SETUP.md. Keep the
  safety procedures in `AGENTS.md` sections 1–5, `notion-safety.md`, `cross-review.md`, `course-ai-docs.md`.
  Inside those files, only **values** listed in the table may change (time zone, model names, CLI flags), and a
  value is changed everywhere it appears so the files stay consistent.
- When a rule is duplicated (for example the lecture-progress rule in `learning-materials.md` and
  `publish-learning-notes` 6a), change every copy the table names.
- Do not invent values. If a SETUP.md cell is empty and the change needs it, ask one question at a time.
- Never write passwords, cookies, tokens, student IDs, or emails into any file.

## Workflow

1. Read `AGENTS.md`, `docs/CUSTOMIZE.md`, and `SETUP.md`. List empty cells that block a change and ask about
   them one by one. Empty cells that block nothing stay empty.
2. Build a change list: file → section → current example text → new text → SETUP.md item. Show it to the user
   and wait for approval before editing.
3. Apply the approved edits with minimal diffs. Typical changes:
   - School LMS name, week rule, and week-lookup script name in `learning-materials.md` and
     `publish-learning-notes`.
   - Textbook problem kinds and numbering in `build-textbook-problem-bank`.
   - Tone and meme rules in `content-style.md`, `style-profile.md`, `meme-dictionary.md`, and `AGENTS.md` 6절.
   - Time zone, model names in `AGENTS.md`, `tool-routing.md`, `.codex/config.toml`.
   - Course list in `style-profile.md`; new course slugs as `materials/courses/<slug>/` copied from `_template`.
4. LMS tools, as a separate step that needs a live browser session with the user:
   - The user downloads videos → create the LMS skill and its tools from `templates/lecture-download-skill.md`.
   - The user does not download but uses the LMS week modules → create only `tools/<lms>-modules.js` from the
     same template's 「만들 도구」.
   - Neither → change `learning-materials.md` 「주차 확정」 and `publish-learning-notes` step 3 to use a week
     table the user confirms in `materials/index.md`.
5. If a course has no `AI 활용 문서`, offer the interview in docs/CUSTOMIZE.md 「과목 AI 활용 문서 만들기」.
   Save the draft under `materials/guides/` only. The user pastes it into Notion; this skill never writes it
   (AGENTS.md 1절 12번 requires the live document to exist before any course Notion work).
6. Run `tools/check-structure.sh`. If a skill was added or removed, update the `CLAUDE.md` skill index and the
   required-file list in `tools/check-structure.sh` so the check passes.
7. Report: files changed, rows of CUSTOMIZE.md applied, rows skipped and why, questions still open, and the
   next steps (`map-notion-workspace`, then the first small lecture).
