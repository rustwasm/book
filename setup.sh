#!/bin/bash

if [ -z "${TRAVIS_BRANCH:-}" ]; then
    echo "This script may only be run from Travis!"
    exit 1
fi

if [[ "$TRAVIS_BRANCH" != "master" || "$TRAVIS_RUST_VERSION" != "stable" || "$TRAVIS_OS_NAME" != "linux" ]]; then
    echo "This commit was made against '$TRAVIS_BRANCH' with '$TRAVIS_RUST_VERSION' on '$TRAVIS_OS_NAME'."
    echo "Instead of 'master' branch with 'stable' on 'linux'!"
    echo "Not deploying!"
    exit 0
fi

# Returns 1 if program is installed and 0 otherwise
program_installed() {
    local return_=1

    type $1 >/dev/null 2>&1 || { local return_=0; }

    echo "$return_"
}

# Ensure required programs are installed
if [ $(program_installed git) == 0 ]; then
    echo "Please install Git."
    exit 1
elif [ $(program_installed mdbook) == 0 ]; then
    echo "Please install mdbook: cargo install mdbook."
    exit 1
fi
