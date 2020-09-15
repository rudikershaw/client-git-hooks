#!/bin/sh

# Run all scripts defined in the tests directory.
# This allows individual operations/verifications/restriction to be stored in their own files.
set -e

[ ! -z "${BUILD}" ] || (echo "ERROR: Do not run the tests manually!\\n Use 'docker build ./' instead."; exit 1)

for f in $(dirname "$0")/tests/*.sh; do
  sh "$f"
done
