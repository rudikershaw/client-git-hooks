#!/bin/sh
set -e

too_big() {
    if [ "$(wc -c <"$toplevel/$1")" -gt "$maxsize" ] ; then
        message=$(git config hooks.file-size.message || cat << EOF
Error: Attempting to commit a file larger than approximately $(maxsize/1000/1000)MB.

Commiting large files slows jenkins builds, clones, and other operations.
Consider generating, downloading, zipping, etc these files.

Offending file -
EOF
        )
        echo "$message $1"
        exit 1
    fi
}

# Redirect output to stderr.
exec 1>&2

# If you want to allow large files to be committed set this variable to true.
if ! git config --bool hooks.file-size.disabled > /dev/null ; then
    toplevel=$(git rev-parse --show-toplevel)
    maxsize=$(git config --int hooks.file-size.bytes || echo 1000000)
    git diff --name-only --diff-filter=ACM --cached | while read -r x; do too_big "$x"; done
fi
