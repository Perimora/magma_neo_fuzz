#!/bin/bash

# Pre-requirements (same as your previous script)

# set default max log size to 1 MiB
LOGSIZE=${LOGSIZE:-$[1 << 20]}

export MONITOR="$SHARED/monitor"
mkdir -p "$MONITOR"

# change working directory to somewhere accessible by the monitor
cd "$SHARED"

# Step 1: Start the monitor in the background and let it run indefinitely
rm -f "$MONITOR/tmp"*
polls=("$MONITOR"/*)
if [ ${#polls[@]} -eq 0 ]; then
    counter=0
else
    timestamps=($(sort -n < <(basename -a "${polls[@]}")))
    last=${timestamps[-1]}
    counter=$(( last + POLL ))
fi

while true; do
    "$OUT/monitor" --dump row > "$MONITOR/tmp"
    if [ $? -eq 0 ]; then
        mv "$MONITOR/tmp" "$MONITOR/$counter"
    else
        rm "$MONITOR/tmp"
    fi
    counter=$(( counter + POLL ))
    sleep $POLL
done &  # Monitor runs in the background

echo "Monitor started at $(date '+%F %R')"

# Keep the script running (so the container stays active)
tail -f /dev/null  # This keeps the script running indefinitely
