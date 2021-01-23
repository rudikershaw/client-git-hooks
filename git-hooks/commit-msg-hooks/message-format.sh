#!/bin/sh
# Default to check that commit message has more than three words.
set -e

if ! git config --bool hooks.message-format.disabled > /dev/null ; then
    regex=$(git config hooks.message-format.regex || echo '(\w+\s+){4}')
    message=$(git config hooks.message-format.message || echo "Commit message does not adhere to '$regex'")
    perl -E "exit 1 if <> !~ /$regex/m" "$1" > /dev/null || (echo "$message"; exit 1)
fi
