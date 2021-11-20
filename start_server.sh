#!/bin/bash

set -e

NUM_REGEX='^[0-9]+$'

if [[ "$UPDATE" == "true" ]]; then 
    if [[ "$EXPERIMENTAL" == "true" ]]; then
        echo "Setting experimental flag..."
        EXP_FLAG=" -beta experimental"
    fi

    echo "Updating satisfactory...\\n"

    ${STEAMDIR}/steamcmd.sh +force_install_dir ${GAMEDIR} +login anonymous +app_update "${APPID}${EXP_FLAG}" +quit
else
    echo "Skipping update, update set to $UPDATE \\n"
fi

if ! [ -d  ${GAMESAVEDIR}/server ]; then
    mkdir -p ${GAMESAVEDIR}/server
fi

if ! [[ "$MAXPLAYERS" =~ $NUM_REGEX ]]; then
    printf "Invalid max players value: ${MAXPLAYERS}\\n"
    MAXPLAYERS="16"
else
    printf "Setting max players to ${MAXPLAYERS}\\n"
    #sed "s/MaxPlayers\=16/MaxPlayers=$MAXPLAYERS/" -i "${GAMEDIR}/FactoryGame/FactoryGame/Saved/Config/LinuxServer/Game.ini"
fi

if [[ "$COPYSAVE" == "true" ]]; then
    printf "Copying save files... \\n"
    cp -a /config/saves/. ${GAMESAVEDIR}/server
else
    printf "Skipping copying save games\\n"
fi

echo "Starting Satisfactory server"
${GAMEDIR}/FactoryServer.sh -log -NoSteamClient -unattended ?listen -Port=$SERVERGAMEPORT -BeaconPort=$SERVERBEACONPORT -ServerQueryPort=$SERVERQUERYPORT
