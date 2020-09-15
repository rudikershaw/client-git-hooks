#!/bin/sh
wdir=$(pwd)
tmpdir=$(mktemp -d -t mfs-test-XXXXXXXXXX)

# Delete the temporary directory when this test exists.
trap '{ rm -R -f $tmpdir; }' EXIT

# Setup
hook="$wdir/git-hooks/pre-commit-hooks/file-size.sh"
cd "$tmpdir" || (echo "FAILED: Could not cd to tmp dir for file-size.sh test."; exit 1)
git init > /dev/null 2>&1
dd if=/dev/zero of=file.toobig bs=1024 count=1024 > /dev/null 2>&1
touch file.small
git add . > /dev/null 2>&1

# Assertions
set -e
# exit 1 when a file larger than 1MB is staged.
sh "$hook" > /dev/null 2>&1 && (echo "FAILED: file-size.sh should exit 1 when a >1MB file staged."; exit 1)
git config hooks.file-size.message "Expected message"
sh "$hook" 2>&1 | grep -q "Expected message" || (echo "FAILED: file-size.sh custom message was not used."; exit 1)
git config --unset hooks.file-size.message
# Do nothing if turned off by git configuration.
git config hooks.file-size.disabled true
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: file-size.sh exit 0 when hooks.file-size.disabled=true."; exit 1)
git config --unset hooks.file-size.disabled
# Increase max file size above 1MB to allow commit.
git config hooks.file-size.bytes 2000000
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: file-size.sh exit 0 when hooks.file-size.bytes is larger than biggest file."; exit 1)
git config --unset hooks.file-size.bytes
# exit 0 when no files larger than 1MB are staged.
rm file.toobig
sh "$hook" > /dev/null 2>&1 || (echo "FAILED: file-size.sh should exit 0 when no >1MB files staged."; exit 1)

echo "PASSED: file-size.sh exits 1 when >1MB file staged and 0 otherwise."
