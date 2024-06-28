**Half-Life 2: Deathmatch Server Docker Image**
==============================================

Run a Half-Life 2: Deathmatch server easily inside a Docker container, optimized for ARM64 (using box86).

**Supported tags**
-----------------

* `latest` - the most recent production-ready image, based on `sonroyaalmerol/steamcmd-arm64:root`

**Documentation**
----------------

### Ports
The container uses the following ports:
* `:27015 TCP/UDP` as the game transmission, pings and RCON port
* `:27005 UDP` as the client port

### Environment variables

* `HL2DM_ARGS`: Additional arguments to pass to the server.
* `HL2DM_CLIENTPORT`: The client port for the server.
* `HL2DM_IP`: The IP address for the server.
* `HL2DM_LAN`: Whether the server is LAN-only or not.
* `HL2DM_MAP`: The map for the server.
* `HL2DM_MAXPLAYERS`: The maximum number of players allowed to join the server.
* `HL2DM_PORT`: The port for the server.
* `HL2DM_SOURCETVPORT`: The Source TV port for the server.
* `HL2DM_TICKRATE`: The tick rate for the server.

### Directory structure
The following directories and files are important for the server:

```
📦 /home/steam
|__📁hl2dm-server // The server root (hlds folder name using env)
|  |__📁hlds
|  |  |__📁cfg
|  |  |  |__⚙️server.cfg
|__📃srcds_run // Script to start the server
|__📃srcds_run-arm64 // Script to start the server on ARM64
```

### Examples

This will start a simple server in a container named `hl2dm-server`:
```sh
docker run -d --name hl2dm-server \
  -p 27005:27005/udp \
  -p 27015:27015 \
  -p 27015:27015/udp \
  -e HL2DM_ARGS="" \
  -e HL2DM_CLIENTPORT=27005 \
  -e HL2DM_IP="" \
  -e HL2DM_LAN="0" \
  -e HL2DM_MAP="dm_overwatch" \
  -e HL2DM_MAXPLAYERS="12" \
  -e HL2DM_PORT=27015 \
  -e HL2DM_SOURCETVPORT="27020" \
  -e HL2DM_TICKRATE="" \
  -v /home/ponfertato/Docker/hl2dm-server:/home/steam/hl2dm-server/hlds \
  ponfertato/hl2dm:latest
```

...or Docker Compose:
```sh
version: '3'

services:
  hl2dm-server:
    container_name: hl2dm-server
    restart: unless-stopped
    image: ponfertato/hl2dm:latest
    tty: true
    stdin_open: true
    ports:
      - "27005:27005/udp"
      - "27015:27015"
      - "27015:27015/udp"
    environment:
      - HL2DM_ARGS=""
      - HL2DM_CLIENTPORT=27005
      - HL2DM_IP=""
      - HL2DM_LAN="0"
      - HL2DM_MAP="dm_overwatch"
      - HL2DM_MAXPLAYERS="12"
      - HL2DM_PORT=27015
      - HL2DM_SOURCETVPORT="27020"
      - HL2DM_TICKRATE=""
    volumes:
      - ./hl2dm-server:/home/steam/hl2dm-server/hlds
```

**Health Check**
----------------

This image contains a health check to continually ensure the server is online. That can be observed from the STATUS column of docker ps

```sh
CONTAINER ID        IMAGE                    COMMAND                 CREATED             STATUS                    PORTS                                                                                     NAMES
e9c073a4b262        ponfertato/hl2dm            "/home/steam/entry.sh"   21 minutes ago      Up 21 minutes (healthy)   0.0.0.0:27005->27005/udp, 0.0.0.0:27015->27015/tcp, 0.0.0.0:27015->27015/udp   distracted_cerf
```

**License**
----------

This image is under the [MIT license](LICENSE).
