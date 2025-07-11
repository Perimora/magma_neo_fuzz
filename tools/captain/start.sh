# Pre-requirements (environment variables must be set)
if [ -z $FUZZER ] || [ -z $TARGET ] || [ -z $PROGRAM ]; then
    echo '$FUZZER, $TARGET, and $PROGRAM must be specified as' \
         'environment variables.'
    exit 1
fi

MAGMA=${MAGMA:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" >/dev/null 2>&1 \
    && pwd)"}
export MAGMA
source "$MAGMA/tools/captain/common.sh"

IMG_NAME="magma/$FUZZER/$TARGET"

if [ ! -z $AFFINITY ]; then
    flag_aff="--cpuset-cpus=$AFFINITY --env=AFFINITY=$AFFINITY"
fi

if [ ! -z "$ENTRYPOINT" ]; then
    flag_ep="--entrypoint=$ENTRYPOINT"
fi

# edited to also mount custom script directory
if [ ! -z "$SHARED" ]; then
    SHARED="$(realpath "$SHARED")"
    flag_volume="--volume=$SHARED:/magma_shared --volume=./scripts:/scripts"
fi

# Adding the DOCKER_NAME to the container
if [ ! -z "$DOCKER_NAME" ]; then
    flag_name="--name=$DOCKER_NAME"
fi

echo $DOCKER_NAME

if [ -t 1 ]; then
    docker run -it $flag_volume \
        --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
        --env=PROGRAM="$PROGRAM" --env=ARGS="$ARGS" \
        --env=FUZZARGS="$FUZZARGS" --env=POLL="$POLL" --env=TIMEOUT="$TIMEOUT" \
        $flag_aff $flag_name --entrypoint "/bin/bash" "$IMG_NAME" -c "sleep infinity"
else
    container_id=$(
    docker run -dt $flag_volume \
        --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
        --env=PROGRAM="$PROGRAM" --env=ARGS="$ARGS" \
        --env=FUZZARGS="$FUZZARGS" --env=POLL="$POLL" --env=TIMEOUT="$TIMEOUT" \
        --network=none $flag_aff $flag_name --entrypoint "/bin/bash" "$IMG_NAME" -c "sleep infinity"
    )
    container_id=$(cut -c-12 <<< $container_id)
    echo_time "Container for $FUZZER/$TARGET/$PROGRAM started with name $DOCKER_NAME (ID: $container_id)"
    docker logs -f "$container_id" &
    exit_code=$(docker wait $container_id)
    exit $exit_code
fi

