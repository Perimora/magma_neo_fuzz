#!/bin/bash
set -e

##
# Pre-requirements:
# - env TARGET: path to target work dir
# - env OUT: path to directory where artifacts are stored
# - env CC, CXX, FLAGS, LIBS, etc...
##

if [ ! -d "$TARGET/repo" ]; then
    echo "fetch.sh must be executed first."
    exit 1
fi

# build lua library
# ANSI escape code for red text
RED='\033[0;31m'
# ANSI escape code to reset color
NC='\033[0m'

echo -e "${RED}building lua library${NC}"
echo -e "${RED}CC: $CC${NC}"
echo -e "${RED}CXX: $CXX${NC}"
echo -e "${RED}CCFLAGS: $CFLAGS${NC}"
echo -e "${RED}CXXFLAGS: $CXXFLAGS${NC}"
echo -e "${RED}LDFLAGS: $LDFLAGS${NC}"

cd "$TARGET/repo"
make -j$(nproc) clean
make -j$(nproc) liblua.a

echo "copy lua library"
cp liblua.a "$OUT/"
find . -name "*.gcno" -exec cp {} "$OUT" \;

# build driver
echo -e "${RED}building lua driver${NC}"
echo -e "${RED}CC: $CC${NC}"
echo -e "${RED}CXX: $CXX${NC}"
echo -e "${RED}CCFLAGS: $CFLAGS${NC}"
echo -e "${RED}CXXFLAGS: $CXXFLAGS${NC}"
echo -e "${RED}LDFLAGS: $LDFLAGS${NC}"

make -j$(nproc) lua
cp lua "$OUT/"
find . -name "*.gcno" -exec cp {} "$OUT" \;