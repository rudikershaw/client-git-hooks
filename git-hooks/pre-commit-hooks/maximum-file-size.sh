#!/bin/sh
too_big() {
    bytez=$(cat "$(git rev-parse --show-toplevel)/$1" | wc -c)
    if [ "$bytez" -gt 1000000 ] ; then
        cat <<EOF
Error: Attempting to commit a file larger than approximately 1mb.

Commiting large files slows jenkins builds, clones, and other operations we'd rather not slow down.
Consider generating, downloading, zipping, etc these files.

Offending file - $1
EOF
        exit 1
    fi
}
# If you want to allow large files to be committed set this variable to true.
allowbigfiles=$(git config --bool hooks.allowbigfiles)

# Redirect output to stderr.
exec 1>&2

if [ "$allowbigfiles" != "true" ]
then
  set -e
  git diff --name-only --cached $1 | while read x; do too_big $x; done
fi
