#!/bin/sh
wdir=$(pwd)
tmpdir=$(mktemp -d -t es-test-XXXXXXXXXX)

# Delete the temporary directory when this test exists.
trap '{ rm -R -f $tmpdir; }' EXIT

# Setup
hook="$wdir/git-hooks/pre-commit-hooks/exclude-strings.sh"
cd "$tmpdir" || (echo "FAILED: Could not cd to tmp dir for excluded-strings.sh test."; exit 1)
git init > /dev/null 2>&1
echo 'TODO' > file.txt
echo 'TODIDNT' > file2.txt
echo 'exclude-this' > file3.txt
echo 'exclude-this' > exclusions.txt
git add . > /dev/null 2>&1

# Assertions
set -e
# exit 1 when a file with TODO is staged.
sh "$hook" > /dev/null 2>&1 && (echo "FAILED: exclude-strings.sh should exit 1 when TODO present in staged changes."; exit 1)
git config hooks.excluded-strings.message "Expected message"
sh "$hook" 2>&1 | grep -q "Expected message" || (echo "FAILED: excluded-strings.sh custom message was not used."; exit 1)
git config --unset hooks.excluded-strings.message
# Do nothing if turned off by git configuration.
git config hooks.excluded-strings.disabled true
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: exclude-strings.sh do nothing when hooks.excluded-strings.disabled=true."; exit 1)
git config --unset hooks.excluded-strings.disabled
# exit 1 when line from exclusions file is staged.
git config hooks.excluded-strings.file 'exclusions.txt'
sh "$hook" > /dev/null 2>&1 && (echo "FAILED: exclude-strings.sh should exit 1 when exclusions file configured."; exit 1)
# But not because that text is in the exclusions file itself.
rm file3.txt
git add .
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: exclude-strings.sh should do nothing when exclusions file simply updated."; exit 1)
git config --unset hooks.excluded-strings.file

# exit 0 when no exluded strings are staged.
rm file.txt
git add .
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: exclude-strings.sh should exit 0 when no TODO in staged changes."; exit 1)

echo "PASSED: exclude-strings.sh exits 1 when new instances of excluded strings are staged."
