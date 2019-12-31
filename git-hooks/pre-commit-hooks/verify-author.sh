#!/bin/sh
set -e

# Run the hook if it has not been disabled by custom git configuration.
if ! git config --bool hooks.verify-author.disabled ; then
    # Get the name and email of the author from the git configuration.
    name=$(git config user.name)
    email=$(git config user.email)

    # Get regexes for validating the author details or use sensible defaults.
    nameregex=$(git config hooks.verify-author.username || echo '\w\w+')
    emailregex=$(git config hooks.verify-author.email || echo '[^@]+@[^\.]+\..+')

    perl -E "exit 1 if '$name' !~ /$nameregex/" || (echo "Author's Git user.name must match regex '$nameregex'"; exit 1)
    perl -E "exit 1 if '$email' !~ /$emailregex/" || (echo "Author's Git user.email must match regex '$emailregex'"; exit 1)
fi
