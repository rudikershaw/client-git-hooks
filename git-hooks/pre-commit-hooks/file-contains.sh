#!/bin/sh
set -e

exclusions='TODO'

if ! git config --bool hooks.allowfilescontain ; then
    git diff --cached -S"$exclusions" --exit-code --quiet || (echo "You cannot commit new instances of TODO"; exit 1)
fi
