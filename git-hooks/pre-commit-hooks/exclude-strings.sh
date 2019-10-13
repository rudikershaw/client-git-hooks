#!/bin/sh
set -e

# Run the hook if it has not been disabled by custom git configuration
if ! git config --bool hooks.allowexcludedstrings ; then
    # Get the file name or a UUID (i.e. a file name that can't possibly exist by accident)
    file=$(git config hooks.exclusionsfile || echo '0bd306a6-654b-42bd-996c-fded43fc14ff')
    # Copy the line seperate list of exclusions into a variable or default to 'TODO'
    toplevel=$(git rev-parse --show-toplevel)
    exclusions=$(cat "$toplevel/$file" || echo 'TODO')

    echo "$exclusions" | while read -r x; do
        git diff --cached -S"$x" --diff-filter=d --exit-code -- . ":(exclude)$toplevel/$file" > /dev/null 2>&1 || (echo "You cannot commit new instances of $x"; exit 1)
    done
fi
