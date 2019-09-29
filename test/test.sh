#!/bin/sh

# Run all scripts defined in the tests directory.
# This allows individual operations/verifications/restriction to be stored in their own files.
set -e
for f in $(dirname "$0")/tests/*.sh; do
  sh "$f"
done
