#!/usr/bin/env bash

set -x

# $1 => image to use
# $2 => tag to use

docker pull "$1"
docker tag "$1" "$2"
docker push "$2"
