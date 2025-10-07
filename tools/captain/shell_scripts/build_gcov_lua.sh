#!/bin/bash

export FUZZER="gcov_afl"
export TARGET="lua"

./tools/captain/build_gcov_docker.sh