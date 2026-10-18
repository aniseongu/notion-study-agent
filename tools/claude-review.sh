#!/usr/bin/env bash
# Run a read-only Claude review without racing another review's OAuth refresh.
set -u
set -o pipefail

if [[ $# -ne 1 ]]; then
  echo 'usage: tools/claude-review.sh "review prompt"' >&2
  exit 2
fi

config_dir=${CLAUDE_CONFIG_DIR:-"$HOME/.claude"}
if [[ ! -d $config_dir ]]; then
  echo "Claude config directory does not exist: $config_dir" >&2
  exit 2
fi

umask 077
exec 9>>"$config_dir/.notionaction-review.lock" || exit 2
if ! flock -w 1800 9; then
  echo 'Timed out waiting for another NotionAction Claude review.' >&2
  exit 75
fi

tmp_dir=$(mktemp -d) || exit 2
trap 'rm -rf -- "$tmp_dir"' EXIT

for attempt in 1 2 3; do
  ENABLE_CLAUDEAI_MCP_SERVERS=false claude --print \
    --model claude-opus-5-5 \
    --permission-mode plan \
    --tools 'Read,Glob,Grep' \
    --disallowedTools 'mcp__*' \
    --strict-mcp-config \
    --effort high \
    --no-session-persistence \
    "$1" >"$tmp_dir/stdout" 2>"$tmp_dir/stderr"
  status=$?

  # Some Claude print failures are returned as text with exit status zero.
  if [[ $status -eq 0 ]] && \
    grep -Fq 'Failed to refresh OAuth token: another Claude Code process is refreshing it or exited mid-refresh' \
    "$tmp_dir/stdout" "$tmp_dir/stderr" && \
    ! grep -Eq '^VERDICT: (PASS|BLOCK)' "$tmp_dir/stdout"; then
    status=1
  fi

  if [[ $status -eq 0 ]]; then
    cat "$tmp_dir/stdout"
    cat "$tmp_dir/stderr" >&2
    exit 0
  fi

  if ! grep -Fq 'Failed to refresh OAuth token: another Claude Code process is refreshing it or exited mid-refresh' \
    "$tmp_dir/stdout" "$tmp_dir/stderr"; then
    cat "$tmp_dir/stdout"
    cat "$tmp_dir/stderr" >&2
    exit "$status"
  fi

  if [[ $attempt -eq 3 ]]; then
    cat "$tmp_dir/stdout"
    cat "$tmp_dir/stderr" >&2
    exit "$status"
  fi

  echo "Claude OAuth refresh is busy; retrying review ($attempt/2)." >&2
  sleep 30
done
