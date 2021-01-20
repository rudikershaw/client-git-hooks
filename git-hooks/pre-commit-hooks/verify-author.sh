#!/bin/sh
set -e

# Run the hook if it has not been disabled by custom git configuration.
if ! git config --bool hooks.verify-author.disabled > /dev/null ; then
    # Get the name and email of the author from the git configuration.
    name=$(git config user.name)
    email=$(git config user.email)

    # Get regexes for validating the author details or use sensible defaults.
    nameregex=$(git config hooks.verify-author.username || echo '\w\w+')
    emailregex=$(git config hooks.verify-author.email || echo '[^@]+@[^\.]+\..+')
    usernamemessage=$(git config hooks.verify-author.username-message || echo "Author's Git user.name must match regex")
    emailmessage=$(git config hooks.verify-author.email-message || echo "Author's Git user.email must match regex")

    perl -E "exit 1 if '$name' !~ /$nameregex/" || (echo "$usernamemessage '$nameregex'"; exit 1)
    perl -E "exit 1 if '$email' !~ /$emailregex/" || (echo "$emailmessage '$emailregex'"; exit 1)
fi
