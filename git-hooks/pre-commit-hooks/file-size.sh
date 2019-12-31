#!/bin/sh
set -e

too_big() {
    if [ "$(stat -c %s "$toplevel/$1")" -gt "$maxsize" ] ; then
        cat <<EOF
Error: Attempting to commit a file larger than approximately $(maxsize/1000/1000)MB.

Commiting large files slows jenkins builds, clones, and other operations we'd rather not slow down.
Consider generating, downloading, zipping, etc these files.

Offending file - $1
EOF
        exit 1
    fi
}

# Redirect output to stderr.
exec 1>&2

# If you want to allow large files to be committed set this variable to true.
if ! git config --bool hooks.file-size.disabled ; then
    toplevel=$(git rev-parse --show-toplevel)
    maxsize=$(git config --int hooks.file-size.bytes || echo 1000000)
    git diff --name-only --diff-filter=ACM --cached | while read -r x; do too_big "$x"; done
fi