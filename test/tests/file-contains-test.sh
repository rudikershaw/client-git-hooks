#!/bin/sh
wdir=$(pwd)
tmpdir=$(mktemp -d -t fc-test-XXXXXXXXXX)

# Delete the temporary directory when this test exists.
trap '{ rm -R -f $tmpdir; }' EXIT

# Setup
hook="$wdir/git-hooks/pre-commit-hooks/file-contains.sh"
cd "$tmpdir" || (echo "FAILED: Could not cd to tmp dir for file-contains.sh test."; exit 1)
git init > /dev/null 2>&1
echo 'TODO' > file.txt
echo 'TODIDNT' > file2.txt
git add . > /dev/null 2>&1

# Assertions
set -e
# exit 1 when a file larger than 1MB is staged.
sh "$hook" > /dev/null 2>&1 && (echo "FAILED: file-contains.sh should exit 1 when TODO present in staged changes."; exit 1)
# Do nothing if turned off by git configuration.
git config hooks.allowfilescontain true
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: file-contains.sh do nothing when hooks.allowfilescontain=true."; exit 1)
git config --unset hooks.allowfilescontain
# exit 0 when no files larger than 1MB are staged.
rm file.txt
git add .
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: file-contains.sh should exit 0 when no TODO in staged changes."; exit 1)

echo "PASSED: file-contains.sh exits 1 when new instances of bad string are staged."
