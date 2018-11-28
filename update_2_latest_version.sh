#!/bin/bash

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"v([^"]+)".*/\1/'                                    # Pluck JSON value
}

release=$(get_latest_release "mattermost/mattermost-server")

sed -i -E "s/^(ENV MM_VERSION).+/\1=${release}/" "$HOME/mattermost-docker/app/Dockerfile"

