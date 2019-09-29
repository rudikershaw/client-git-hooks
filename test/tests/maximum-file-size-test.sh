wdir=$(pwd)
tmpdir=$(mktemp -d -t mfs-test-XXXXXXXXXX)

# Delete the temporary directory when this test exists.
trap '{ rm -R -f $tmpdir; }' EXIT

# Given
hook="$wdir/git-hooks/pre-commit-hooks/maximum-file-size.sh"
cd "$tmpdir"
git init > /dev/null 2>&1
dd if=/dev/zero of=file.toobig bs=1024 count=1024 > /dev/null 2>&1
git add . > /dev/null 2>&1

# When / Then
set +e
sh "$hook" > /dev/null 2>&1 && (echo "FAILED: maximum-file-size.sh should exit 1 when a >1MB file staged."; exit 1)

echo "PASSED: maximum-file-size.sh exits 1 when >1MB file staged."
