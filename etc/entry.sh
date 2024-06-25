#!/bin/bash

# Create steam app directory
mkdir -p "${STEAMAPPDIR}" || true

# Download updates
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
    +login "anonymous" \
    +app_update "${STEAMAPPID}" \
    +quit

# Switch to server directory
cd "${STEAMAPPDIR}"

# Check architecture
if [ "$(uname -m)" = "aarch64" ]; then
    # ARM64 architecture
	# create an arm64 version of srcds_run
	cp ./srcds_run ./srcds_run-arm64
    SRCDS_RUN="srcds_run-arm64"
    sed -i 's/$HL_CMD/box86 $HL_CMD/g' "$SRCDS_RUN"
    chmod +x "$SRCDS_RUN"
else
    # Other architectures
    SRCDS_RUN="srcds_run"
fi

# Start server
"./$SRCDS_RUN" -game hl2mp \
	"${HL2DM_ARGS}" \
    +clientport "${HL2DM_CLIENTPORT}" \
    +map "${HL2DM_MAP}" \
    +sv_lan "${HL2DM_LAN}" \
    +tv_port "${HL2DM_SOURCETVPORT}" \
    -autoupdate \
    -console \
    -ip "${HL2DM_IP}" \
    -master \
    -maxplayers "${HL2DM_MAXPLAYERS}" \
    -port "${HL2DM_PORT}" \
    -steam_dir "${HOMEDIR}/Steam" \
    -steamcmd_script "${STEAMCMDDIR}" \
    -strictportbind \
    -tickrate "${HL2DM_TICKRATE}" \
    -usercon