#!/bin/bash

set -e

NUM_REGEX='^[0-9]+$'
USERID=$(id -u)

if ! [ -d ${SAVEDIR} ]; then
    printf "Creating save directory\\n"
    sudo mkdir -p /config/saves
fi

if ! [ -d ${HOMEDIR}/.confg ]; then
    printf "Config directory not found, creating...\\n\\n"
    
    mkdir -p ${HOMEDIR}/.config
    sudo chown -R ${PUID}:${PGID} ${HOMEDIR}/.config
else
    sudo chown -R ${PUID}:${PGID} ${HOMEDIR}/.config
fi

if [[ "$EXPERIMENTAL" == "true" ]]; then
    echo "Setting experimental flag..."
    EXP_FLAG=" -beta experimental"
fi

# if [[ "$USERID" -ne "0" ]]; then
#     printf "Current user is not running as root \\n Set PUID and PGID in environment variables"
#     exit 1
# fi

if ! [ -d ${GAMEDIR}/Engine ]; then
    printf "Game not found, downloading....\\n\\n"

    ${STEAMDIR}/steamcmd.sh +force_install_dir ${GAMEDIR} +login anonymous +app_update "${APPID}${EXP_FLAG}" +quit
fi

if ! [[ "$PGID" =~ $NUM_REGEX ]];then
    printf "Invalid group ID: ${PGID}. Setting PGID to 1000\\n"
    PGID="1000"
fi

if ! [[ "$PUID" =~ $NUM_REGEX ]];then
    printf "Invalid user ID: ${PUID}. Setting PUID to 1000\\n"
    PGID="1000"
fi

if [[ $(getent group ${PGID} | cut -d: -f1) ]]; then
   sudo usermod -a -G "${PGID}" steam
else
   sudo groupmod -g "${PGID}" steam
fi

if [[ $(getent passwd ${PUID} | cut -d: -f1) ]]; then
    USER=$(getent passwd ${PUID} | cut -d: -f1)
else
    sudo usermod -u "${PUID}" steam
fi

sudo chown -R "$PUID":"$PGID" ${CONFIGDIR} ${HOMEDIR}

${HOMEDIR}/start_server.sh
