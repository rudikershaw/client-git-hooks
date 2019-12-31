#!/bin/sh
wdir=$(pwd)
tmpdir=$(mktemp -d -t va-test-XXXXXXXXXX)

# Delete the temporary directory when this test exists.
trap '{ rm -R -f $tmpdir; }' EXIT

# Setup
hook="$wdir/git-hooks/pre-commit-hooks/verify-author.sh"
cd "$tmpdir" || (echo "FAILED: Could not cd to tmp dir for verify-author.sh test."; exit 1)
git init > /dev/null 2>&1
echo 'Conent' > file.txt
git add . > /dev/null 2>&1

# Assertions
set -e
# exit 0 when details are configured correctly.
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: verify-author.sh should exit 0 when author details configured correctly."; exit 1)
# exit 1 when authors details are not valid.
git config user.name "P"
git config user.email "S"
sh "$hook" > /dev/null 2>&1 && (echo "FAILED: verify-author.sh should exit 1 when author details are not configured."; exit 1)
# Do nothing if turned off by git configuration.
git config hooks.allowanyauthor true
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: verify-author.sh should do nothing when hooks.allowanyauthor=true."; exit 1)
git config --unset hooks.allowanyauthor

echo "PASSED: verify-author.sh exits 1 when new instances of excluded strings are staged."
