#!/bin/sh
wdir=$(pwd)
tmpdir=$(mktemp -d -t cmr-test-XXXXXXXXXX)

# Delete the temporary directory when this test exists.
trap '{ rm -R -f $tmpdir; }' EXIT

# Setup
hook="$wdir/git-hooks/commit-msg-hooks/message-format.sh"
cd "$tmpdir" || (echo "FAILED: Could not cd to tmp dir for message-format.sh test."; exit 1)
git init > /dev/null 2>&1
touch file.txt
cp "$hook" ./.git/hooks/commit-msg
git add . > /dev/null 2>&1

# Assertions
set -e

# exit 1 when commit message too short
(git commit -m "Fixed some stuff" > /dev/null 2>&1) && (echo "FAILED: message-format.sh failed to prevent commit."; exit 1)

# Do nothing if turned off by git configuration.
git config hooks.message-format.disabled true
git commit -m "Fixed some stuff" > /dev/null 2>&1 || (echo "FAILED: message-format.sh couldn't be turned off."; exit 1)
git config --unset hooks.message-format.disabled

# Change regex to allow short message.
git config hooks.message-format.regex '\w+'
git commit --amend -m "Fixed some stuff" > /dev/null 2>&1 || (echo "FAILED: message-format.sh regex couldn't be changed."; exit 1)
git config --unset hooks.message-format.regex

# exit 1 when commit message too short
git commit --amend -m "Fixed some bugs and stuff" > /dev/null 2>&1 || (echo "FAILED: message-format.sh prevented wrong commit."; exit 1)

git config hooks.message-format.message "Expected message"
git commit --amend -m "Too short" 2>&1 | grep -q "Expected message" || (echo "FAILED: message-format.sh custom message was not used."; exit 1)
git config --unset hooks.message-format.message

echo "PASSED: message-format.sh exits 1 message too short and vice versa."
