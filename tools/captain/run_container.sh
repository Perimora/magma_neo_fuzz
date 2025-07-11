#!/bin/bash

# default values for the environment variables
SHARED="./workdir"
FUZZER="gcov_afl"
POLL="5"
TIMEOUT="24h"
TARGET="lua"
PROGRAM="lua"
WORKERS="1"

# parse command-line arguments
while getopts "d:f:p:t:w:e:h" opt; do
  case $opt in
    d) SHARED=$OPTARG ;;     # SHARED directory
    f) FUZZER=$OPTARG ;;     # Fuzzer type
    p) POLL=$OPTARG ;;       # Poll interval
    t) TIMEOUT=$OPTARG ;;    # Timeout duration
    w) WORKERS=$OPTARG ;;    # Workers count
    e) ENTRYPOINT=$OPTARG ;;
    h)
       echo "Usage: $0 [-d SHARED] [-f FUZZER] [-p POLL] [-t TIMEOUT] [-w WORKERS]"
       echo "  -d SHARED    : Directory for shared files (default: ./workdir)"
       echo "  -f FUZZER    : Fuzzer type (default: gcov_afl)"
       echo "  -p POLL      : Poll interval in seconds (default: 5)"
       echo "  -t TIMEOUT   : Timeout duration (default: 24h)"
       echo "  -w WORKERS   : Number of worker threads (default: 1)"
       echo "  -e ENTRYPOINT   : Entrypoint of container"
       exit 0 ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# create the shared directory if it doesn't exist
mkdir -p "$SHARED"

# start the fuzzing campaign
echo "Starting MAGMA container with the following settings:"
echo "  SHARED=$SHARED"
echo "  FUZZER=$FUZZER"
echo "  POLL=$POLL"
echo "  TIMEOUT=$TIMEOUT"
echo "  TARGET=$TARGET"
echo "  PROGRAM=$PROGRAM"
echo "  WORKERS=$WORKERS"
echo "  ENTRYPOINT=$ENTRYPOINT"

FUZZER=$FUZZER TARGET=$TARGET PROGRAM=$PROGRAM SHARED=$SHARED POLL=$POLL TIMEOUT=$TIMEOUT WORKERS=$WORKERS\
  ./magma/tools/captain/start.sh
