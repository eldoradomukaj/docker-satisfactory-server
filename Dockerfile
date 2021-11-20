FROM steamcmd:latest

COPY --chown=steam:steam entrypoint.sh /
COPY --chown=steam:steam start_server.sh ${HOMEDIR}

ENV CONFIGDIR="/config" \
    GAMEDIR="/config/satisfactory" \
    SAVEDIR="/config/saves" \
    GAMESAVEDIR="${HOMEDIR}/.config/Epic/FactoryGame/Saved/SaveGames" \
    COPYSAVE="false" \
    APPID="1690800" \
    EXPERIMENTAL="true" \
    UPDATE="true" \
    PGID="1000" \
    PUID="1000" \
    SERVERGAMEPORT="7777" \
    SERVERQUERYPORT="15777" \
    SERVERBEACONPORT="15000" \
    MAXPLAYERS="4"

RUN sudo mkdir -p ${CONFIGDIR} \
    && sudo mkdir -p ${GAMEDIR} \ 
    && sudo mkdir -p ${GAMESAVEDIR}

WORKDIR ${GAMEDIR}

VOLUME ["${CONFIGDIR}"]

EXPOSE 7777/udp 15777/udp 15000/udp

ENTRYPOINT [ "/entrypoint.sh" ]
