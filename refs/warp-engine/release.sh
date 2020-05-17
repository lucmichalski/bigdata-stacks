#!/bin/bash


COMMIT_VERSION=`git rev-parse --short HEAD`
BUILD_VERSION=`date +%Y.%m.%d`
TAG_VERSIONS=`git tag -l | sort -r`


cat release/commit.sh.template | sed -e "s/COMMIT_VERSION/${COMMIT_VERSION}/" > .warp/lib/commit.sh
cat release/version.sh.template | sed -e "s/BUILD_VERSION/${BUILD_VERSION}/" > .warp/lib/version.sh


tar cJf warparchive.tar.xz --exclude=".DS_Store" .warp/.
cat warp > dist/warp
cat warparchive.tar.xz >> dist/warp
chmod +x dist/warp
cp dist/warp dist/warp_$BUILD_VERSION