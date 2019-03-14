#!/bin/bash

_PWD="$(dirname "$(readlink -f "$0")")"

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"v([^"]+)".*/\1/' |                                 # Pluck JSON value
    sort -r |                                                       # Sort the version with the highest first
    head -n 1                                                       # Pick the top version
}

release=$(get_latest_release "mattermost/mattermost-server")

sed -i -E "s/^(ENV MM_VERSION).+/\1=${release}/" "$_PWD/app/Dockerfile"

for name in $(find $_PWD -iname Dockerfile -exec sed -nr 's/FROM[[:space:]]+//p' '{}' \;); do
    docker pull $name
done
