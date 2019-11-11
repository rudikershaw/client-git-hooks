#!/bin/sh
wdir=$(pwd)
tmpdir=$(mktemp -d -t groups-test-XXXXXXXXXX)

# Delete the temporary directory when this test exists.
trap '{ rm -R -f $tmpdir; }' EXIT

# Setup
cd "$tmpdir" || (echo "FAILED: Could not cd to tmp dir for file-contains.sh test."; exit 1)
git init > /dev/null 2>&1
cp -a "$wdir/git-hooks/" git-hooks/
chmod -R +x git-hooks/
git add . > /dev/null 2>&1
git commit -am "Add hooks before setting up hooks path." > /dev/null 2>&1
git config core.hooksPath git-hooks/
echo 'test' > file.txt
git add . > /dev/null 2>&1

# Assertions
set -e
# Failed commit because of commit-msg.
git commit -m "#1 fail." > /dev/null 2>&1 && (echo "FAILED: commit-msg hook should have caught this."; exit 1)
# Passed commit.
git commit -m "#1 This message should work." > /dev/null 2>&1 || (echo "FAILED: No git hooks should have been triggered."; exit 1)

echo "PASSED: Hooks were run from their grooped hook file."
