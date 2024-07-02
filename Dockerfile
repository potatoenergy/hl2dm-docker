FROM sonroyaalmerol/steamcmd-arm64:root AS build_stage

LABEL maintainer="ponfertato@ya.ru"
LABEL description="A Dockerised version of the Half-Life 2: Deathmatch dedicated server for ARM64 (using box86)"

RUN dpkg --add-architecture amd64 \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    net-tools \
    lib32gcc-s1:amd64 \
    lib32stdc++6 \
    lib32z1 \
    libcurl3-gnutls:i386 \
    libcurl4-gnutls-dev:i386 \
    libcurl4:i386 \
    libgcc1 \
    libncurses5:i386 \
    libsdl1.2debian \
    libtinfo5 \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm -rf /var/lib/apt/lists/*

ENV HOMEDIR="/home/steam" \
    STEAMAPPID="232370" \
    STEAMAPPDIR="/home/steam/hl2dm-server"

COPY etc/entry.sh ${HOMEDIR}/entry.sh

WORKDIR ${STEAMAPPDIR}

RUN chmod +x "${HOMEDIR}/entry.sh" \
    && chown -R "${USER}":"${USER}" "${HOMEDIR}/entry.sh" ${STEAMAPPDIR}

FROM build_stage AS bookworm-root

ENV HL2DM_ARGS="" \
    HL2DM_CLIENTPORT="27005" \
    HL2DM_IP="" \
    HL2DM_LAN="0" \
    HL2DM_MAP="dm_overwatch" \
    HL2DM_MAXPLAYERS="12" \
    HL2DM_PORT="27015" \
    HL2DM_SOURCETVPORT="27020" \
    HL2DM_TICKRATE=""

EXPOSE ${HL2DM_CLIENTPORT}/udp \
    ${HL2DM_PORT}/tcp \
    ${HL2DM_PORT}/udp \
    ${HL2DM_SOURCETVPORT}/udp

USER ${USER}
WORKDIR ${HOMEDIR}

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD netstat -l | grep "${HL2DM_PORT}.*LISTEN"

CMD ["bash", "entry.sh"]