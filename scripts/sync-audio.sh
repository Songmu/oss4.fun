#!/bin/sh
set -eu

cd "$(dirname "$0")/.."

for command in podbard cf; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$command" >&2
        exit 1
    fi
done

for audio in audio/*.mp3; do
    [ -f "$audio" ] || continue
    filename=${audio##*/}
    case "$filename" in
        _*) continue ;;
    esac
    [ ! -f "audio/.$filename.json" ] || continue
    if [ ! -f "episode/${filename%.mp3}.md" ]; then
        printf 'Skipping %s: no matching episode.\n' "$audio"
        continue
    fi

    cf r2 objects put "audio/$filename" \
        --bucket-name oss4fun \
        --file "$audio" \
        --content-type audio/mpeg
    podbard episode --no-edit --save-meta "$audio"
done
