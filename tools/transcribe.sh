#!/bin/sh
# 강의 mp3 → 로컬 Whisper 전사 txt/srt (faster-whisper, whisper-ctranslate2 고정 버전).
# 사용: tools/transcribe.sh [--force] [--model NAME] [--language ko|en] <course-slug> [audio-file...]
# 파일을 생략하면 materials/courses/<course-slug>/audio/*.mp3 전체.
# 출력: materials/courses/<course-slug>/transcripts/<이름>.txt, .srt
# txt·srt가 모두 있고 txt가 mp3보다 새로우면 건너뛴다(멱등). 음성은 외부로 보내지 않는다.
set -eu

WCT='whisper-ctranslate2==0.5.7'
force=0
model=large-v3-turbo
language=''
while [ $# -gt 0 ]; do
    case $1 in
        --force) force=1; shift ;;
        --model) model=$2; shift 2 ;;
        --language) language=$2; shift 2 ;;
        -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
        -*) echo "unknown option: $1" >&2; exit 2 ;;
        *) break ;;
    esac
done
[ $# -ge 1 ] || { sed -n '2,6p' "$0" >&2; exit 2; }

course=$1
shift
case $course in
    ''|*/*|.*) echo "invalid course slug: $course" >&2; exit 2 ;;
esac

root=$(cd "$(dirname "$0")/.." && pwd)
base="$root/materials/courses/$course"
out_dir="$base/transcripts"
mkdir -p "$out_dir"
[ $# -gt 0 ] || set -- "$base"/audio/*.mp3

created=0 skipped=0 failed=0
for src in "$@"; do
    [ -f "$src" ] || { echo "not found: $src" >&2; failed=$((failed + 1)); continue; }
    name=$(basename "$src")
    name=${name%.*}
    if [ "$force" -eq 0 ] && [ -f "$out_dir/$name.srt" ] && [ -f "$out_dir/$name.txt" ] \
        && [ "$out_dir/$name.txt" -nt "$src" ]; then
        echo "skipped: $out_dir/$name.txt"
        skipped=$((skipped + 1))
        continue
    fi
    tmp=$(mktemp -d "$out_dir/.work.XXXXXX")
    start=$(date +%s)
    # --language를 생략하면 앞부분으로 자동 감지한다. 영어 강의를 ko로 고정하면 품질이 떨어진다.
    # shellcheck disable=SC2086
    if uvx --quiet --from "$WCT" whisper-ctranslate2 "$src" \
        --model "$model" --device cpu --compute_type int8 --threads "$(nproc)" \
        ${language:+--language "$language"} --vad_filter True --condition_on_previous_text False \
        --output_format all --output_dir "$tmp" --verbose False >/dev/null \
        && rm -f "$out_dir/$name.txt" \
        && mv "$tmp/$name.srt" "$out_dir/$name.srt" \
        && mv "$tmp/$name.txt" "$out_dir/$name.txt"; then
        # txt가 완료 표시다. 옛 txt를 먼저 지우고, srt → txt 순서로 옮겨 중간 실패가 skip되지 않게 한다.
        rm -rf "$tmp"
        echo "created: $out_dir/$name.txt ($(( ($(date +%s) - start) / 60 )) min, model=$model)"
        created=$((created + 1))
    else
        rm -rf "$tmp"
        echo "failed: $src" >&2
        failed=$((failed + 1))
    fi
done

echo "created=$created skipped=$skipped failed=$failed"
[ "$failed" -eq 0 ]
