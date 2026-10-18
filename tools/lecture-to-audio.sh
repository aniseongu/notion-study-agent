#!/bin/sh
# 강의 영상/음성 → 전사용 mp3 (샤나인코더 대체).
# 사용: tools/lecture-to-audio.sh [--force] [--normalize] <course-slug> <file-or-dir>...
# 출력: materials/courses/<course-slug>/audio/<원본 파일명>.mp3
# 이미 같은 이름의 mp3가 원본보다 새로우면 건너뛴다(멱등). --force는 다시 만든다.
set -eu

force=0
normalize=0
while [ $# -gt 0 ]; do
    case $1 in
        --force) force=1; shift ;;
        --normalize) normalize=1; shift ;;
        -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
        --) shift; break ;;
        -*) echo "unknown option: $1" >&2; exit 2 ;;
        *) break ;;
    esac
done

if [ $# -lt 2 ]; then
    sed -n '2,5p' "$0" >&2
    exit 2
fi

course=$1
shift
case $course in
    ''|*/*|.*) echo "invalid course slug: $course" >&2; exit 2 ;;
esac

root=$(cd "$(dirname "$0")/.." && pwd)
out_dir="$root/materials/courses/$course/audio"
mkdir -p "$out_dir"

command -v ffmpeg >/dev/null || { echo 'ffmpeg not found' >&2; exit 1; }

# 음성 인식에는 mono면 충분하다. 44.1kHz/96kbps mono는 75분 기준 약 55MB.
filter=''
[ "$normalize" -eq 1 ] && filter='-af dynaudnorm'

created=0 skipped=0 failed=0

convert() {
    src=$1
    name=$(basename "$src")
    out="$out_dir/${name%.*}.mp3"
    if [ "$force" -eq 0 ] && [ -f "$out" ] && [ "$out" -nt "$src" ]; then
        echo "skipped: $out"
        skipped=$((skipped + 1))
        return
    fi
    tmp="$out.part.mp3"
    # shellcheck disable=SC2086
    if ffmpeg -hide_banner -loglevel error -nostdin -y -i "$src" -vn -ac 1 -ar 44100 \
        $filter -c:a libmp3lame -b:a 96k "$tmp"; then
        mv "$tmp" "$out"
        dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$out" \
            | awk '{printf "%d:%02d:%02d", $1/3600, ($1%3600)/60, $1%60}')
        echo "created: $out ($dur)"
        created=$((created + 1))
    else
        rm -f "$tmp"
        echo "failed: $src" >&2
        failed=$((failed + 1))
    fi
}

for arg in "$@"; do
    if [ -d "$arg" ]; then
        for f in "$arg"/*; do
            case $(printf '%s' "$f" | tr 'A-Z' 'a-z') in
                *.mp4|*.mkv|*.webm|*.mov|*.m4a|*.wav|*.aac|*.flac|*.ogg) convert "$f" ;;
            esac
        done
    elif [ -f "$arg" ]; then
        convert "$arg"
    else
        echo "not found: $arg" >&2
        failed=$((failed + 1))
    fi
done

echo "created=$created skipped=$skipped failed=$failed"
[ "$failed" -eq 0 ]
