#!/bin/sh
# 작업 환경 점검. docs/ENVIRONMENT.md의 도구가 실제로 실행되는지와 버전, notion MCP 연결을 본다.
# 아무것도 설치하거나 설정을 바꾸지 않는다(일부 CLI는 버전 확인 때 자기 설정 폴더를 만들 수 있음).
# 사용: tools/doctor.sh    필수 항목이 하나라도 빠지면 종료 코드 1
set -u

missing_required=0
limit=${DOCTOR_TIMEOUT:-60}

# timeout(리눅스) 또는 gtimeout(macOS: brew install coreutils)이 있을 때만 시간 제한이 걸린다
run_limited() {
    if command -v timeout >/dev/null 2>&1; then
        timeout "$limit" sh -c "$1"
    elif command -v gtimeout >/dev/null 2>&1; then
        gtimeout "$limit" sh -c "$1"
    else
        sh -c "$1"
    fi
}

report() {
    printf '%-8s %-10s %-14s %s\n' "$1" "$2" "$3" "$4"
    if [ "$1" != ok ] && [ "$2" = required ]; then
        missing_required=1
    fi
}

check() {
    level=$1 name=$2 cmd=$3
    if ! command -v "${cmd%% *}" >/dev/null 2>&1; then
        report MISSING "$level" "$name" 'see docs/ENVIRONMENT.md'
        return
    fi
    if out=$(run_limited "$cmd" 2>&1); then
        version=$(printf '%s\n' "$out" | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
        if [ -n "$version" ]; then
            report ok "$level" "$name" "$version"
        else
            report FAILED "$level" "$name" 'ran but printed no version'
        fi
    else
        report FAILED "$level" "$name" "\`$cmd\` exited with an error"
    fi
}

check required claude 'claude --version'
check required git 'git --version'
check required gh 'gh --version'
check required python3 'python3 --version'
check required pdftoppm 'pdftoppm -v'
check required pdftotext 'pdftotext -v'
check required pdfinfo 'pdfinfo -v'
check required uv 'uv --version'
check required markitdown 'markitdown --version'
check required node 'node --version'
check recommend codex 'codex --version'
check recommend ntn 'ntn --version'
check optional ffmpeg 'ffmpeg -version'
check optional npx 'npx --version'

if command -v python3 >/dev/null 2>&1 && python3 -c 'import PIL' 2>/dev/null; then
    report ok required Pillow "$(python3 -c 'import PIL; print(PIL.__version__)')"
else
    report MISSING required Pillow 'see docs/ENVIRONMENT.md'
fi

# MCP: notion은 필수(연결돼야 ok), playwright는 강의 영상을 받을 때만
if command -v claude >/dev/null 2>&1; then
    if servers=$(run_limited 'claude mcp list' 2>&1); then
        for spec in notion:required playwright:optional; do
            s=${spec%%:*} level=${spec#*:}
            line=$(printf '%s\n' "$servers" | grep -E "^$s:" | head -1)
            if [ -z "$line" ]; then
                report MISSING "$level" "mcp $s" 'not registered (see docs/ENVIRONMENT.md)'
            elif printf '%s' "$line" | grep -q 'Connected'; then
                report ok "$level" "mcp $s" connected
            else
                report FAILED "$level" "mcp $s" "$(printf '%s' "$line" | sed 's/.* - //')"
            fi
        done
    else
        report FAILED required 'mcp notion' "\`claude mcp list\` failed or took over ${limit}s"
    fi
fi

if [ "$missing_required" -ne 0 ]; then
    echo "required tools missing or failing" >&2
    exit 1
fi
echo "environment: required tools present"
