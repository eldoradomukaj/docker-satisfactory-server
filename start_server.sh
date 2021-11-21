#!/bin/bash

set -e

NUM_REGEX='^[0-9]+$'

if [[ "$UPDATE" == "true" ]]; then 
    if [[ "$EXPERIMENTAL" == "true" ]]; then
        printf "Setting experimental flag \\n"
        EXP_FLAG=" -beta experimental"
    fi

    printf "Updating satisfactory...\\n"

    ${STEAMDIR}/steamcmd.sh +force_install_dir ${GAMEDIR} +login anonymous +app_update "${APPID}${EXP_FLAG}" +quit
else
    printf "Skipping update, update set to $UPDATE \\n"
fi

if ! [ -d  ${GAMESAVEDIR}/server ]; then
    mkdir -p ${GAMESAVEDIR}/server
fi

if ! [[ "$MAXPLAYERS" =~ $NUM_REGEX ]]; then
    printf "Invalid max players value: ${MAXPLAYERS}\\n"
    MAXPLAYERS="4"
else
    printf "Setting max players to ${MAXPLAYERS}\\n"
    sed "s/MaxPlayers\=4/MaxPlayers=$MAXPLAYERS/" -i "${HOMEDIR}/Game.ini"
fi

if ! [[ -d ${GAMECONFIG}/Config/LinuxServer ]]
    printf "Creating game config directory \\n"
    mkdir -p "${GAMECONFIG}/Config/LinuxServer"

    printf "Copying game config files \\n"
    cp ${HOMEDIR}/{Game.ini,Engine.ini,Scalability.ini} "${GAMECONFIG}/Config/LinuxServer/"

    printf "Setting correct permissions \\n"
    chmod 400 "${GAMECONFIG}/{Game.ini,Engine.ini,Scalability.ini}"
fi

if [[ "$COPYSAVE" == "true" ]]; then
    printf "Copying save files... \\n"
    cp -a /config/saves/. ${GAMESAVEDIR}/server
else
    printf "Skipping copying save games\\n"
fi

echo "Starting Satisfactory server"
${GAMEDIR}/FactoryServer.sh -log -NoSteamClient -unattended ?listen -Port=$SERVERGAMEPORT -BeaconPort=$SERVERBEACONPORT -ServerQueryPort=$SERVERQUERYPORT
