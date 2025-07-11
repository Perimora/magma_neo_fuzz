#!/bin/bash

# set the repository url and the target path where you want to move the afl-cov file
REPO_URL="https://github.com/mrash/afl-cov.git"

# temporary directory to clone the repository
REPO_DIR='/afl-cov'

mkdir $REPO_DIR

# clone the repository into the temporary directory
echo "cloning repository from $REPO_URL..."
git clone "$REPO_URL" "$REPO_DIR"

# check if the repository was cloned successfully
if [ $? -ne 0 ]; then
    echo "error: failed to clone the repository."
    exit 1
fi

mkdir '/coverage'

cp $REPO_DIR/afl-cov /coverage

echo "setup completed successfully."
