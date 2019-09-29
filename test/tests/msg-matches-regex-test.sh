#!/bin/sh
wdir=$(pwd)
tmpdir=$(mktemp -d -t cmr-test-XXXXXXXXXX)

# Delete the temporary directory when this test exists.
trap '{ rm -R -f $tmpdir; }' EXIT

# Setup
hook="$wdir/git-hooks/commit-msg-hooks/msg-matches-regex.sh"
cd "$tmpdir" || (echo "FAILED: Could not cd to tmp dir for msg-matches-regex.sh test."; exit 1)
git init > /dev/null 2>&1
touch file.txt
cp "$hook" ./.git/hooks/commit-msg
git add . > /dev/null 2>&1

# Assertions
set -e
# exit 1 when commit message too short
(git commit -m "Fixed some stuff" > /dev/null 2>&1) && (echo "FAILED: msg-matches-regex.sh failed to prevent commit."; exit 1)
# Do nothing if turned off by git configuration.
git config hooks.allowcommitmsg true
git commit -m "Fixed some stuff" > /dev/null 2>&1 || (echo "FAILED: msg-matches-regex.sh couldn't be turned off."; exit 1)
git config --unset hooks.allowcommitmsg
# Change regex to allow short message.
git config hooks.commitmsgregex '\w+'
git commit --amend -m "Fixed some stuff" > /dev/null 2>&1 || (echo "FAILED: msg-matches-regex.sh regex couldn't be changed."; exit 1)
git config --unset hooks.commitmsgregex
# exit 1 when commit message too short
git commit --amend -m "Fixed some bugs and stuff" > /dev/null 2>&1 || (echo "FAILED: msg-matches-regex.sh prevented wrong commit."; exit 1)

echo "PASSED: msg-matches-regex.sh exits 1 message too short and vice versa."
