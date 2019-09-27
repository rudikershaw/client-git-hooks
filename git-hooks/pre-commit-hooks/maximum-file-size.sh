#!/bin/sh
set -e

too_big() {
    if [ "$(stat -c %s "$toplevel/$1")" -gt 1000000 ] ; then
        cat <<EOF
Error: Attempting to commit a file larger than approximately 1MB.

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
if ! git config --bool hooks.allowbigfiles ; then
    toplevel=$(git rev-parse --show-toplevel)
    git diff --name-only --cached | while read -r x; do too_big "$x"; done
fi
