#!/bin/sh
SCRIPTPATH=/DataVolume/Plex\ Media\ Server/Application
export LD_LIBRARY_PATH="${SCRIPTPATH}"
export PLEX_MEDIA_SERVER_HOME="${SCRIPTPATH}"
export PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/DataVolume/Plex Media Server/Library/Application Support"
ulimit -s 3000
/DataVolume/Plex\ Media\ Server/Application/Plex\ Media\ Server