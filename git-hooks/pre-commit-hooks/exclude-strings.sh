#!/bin/sh
set -e

# Run the hook if it has not been disabled by custom git configuration
if ! git config --bool hooks.excluded-strings.disabled > /dev/null ; then
    # Get the file name or a UUID (i.e. a file name that can't possibly exist by accident)
    file=$(git config hooks.excluded-strings.file || echo '0bd306a6-654b-42bd-996c-fded43fc14ff')
    # Copy the line seperate list of exclusions into a variable or default to 'TODO'
    toplevel=$(git rev-parse --show-toplevel)
    exclusions=$(cat "$toplevel/$file" 2>/dev/null || echo 'TODO')
    message=$(git config hooks.excluded-strings.message || echo "You cannot commit new instances of ")

    echo "$exclusions" | while read -r x; do
        git diff --cached -S"$x" --diff-filter=d --exit-code -- . ":(exclude)$toplevel/$file" > /dev/null 2>&1 || (echo "$message $x"; exit 1)
    done
fi
