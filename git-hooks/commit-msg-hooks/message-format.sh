#!/bin/sh
# Default to check that commit message has more than three words.
set -e

if ! git config --bool hooks.message-format.disabled ; then
    regex=$(git config hooks.message-format.regex || echo '(\w+\s+){4}')
    perl -E "exit 1 if <> !~ /$regex/m" "$1"  || (echo "Commit message does not adhere to '$regex'"; exit 1)
fi
