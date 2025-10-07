#!/bin/bash

# ensure the target variable is set
if [ -z "$GCOV_DIR" ]; then
    echo "the environment variable GCOV_PREFIX is not set."
    exit 1
fi

# ensure the source directory exists
if [ ! -d "/magma_out/afl" ]; then
    echo "the directory /magma_out/gcov does not exist."
    exit 1
fi

# copy artifacts to the coverage directory
cp /magma_out/afl/* "$GCOV_DIR"

# TODO use default location instead for monitor support
cp /magma/targets/lua/repo/*.c /magma_out/afl/

# also copy the source files to coverage directory for line by line analyzes
if [ ! -d "/magma/targets/lua/repo" ]; then
    echo "the directory /magma_out/gcov does not exist."
    exit 1
fi

cp /magma/targets/lua/repo/*.c "$GCOV_DIR"
echo "artifacts and source files have been copied to $GCOV_DIR."
