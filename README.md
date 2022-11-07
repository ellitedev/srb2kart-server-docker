# Sonic Robo Blast 2 Kart Server

[![Docker Image Version](https://img.shields.io/docker/v/ellite/srb2kart-server)](https://hub.docker.com/r/ellite/srb2kart-server)
[![Docker Image Size](https://img.shields.io/docker/image-size/ellite/srb2kart-server)](https://hub.docker.com/r/ellite/srb2kart-server)

> Containerized version of SRB2Kart.
> This is a fork of [rwanyoikes Dockerfile](https://github.com/rwanyoike/srb2kart-server-docker)

<p align="center">
  <img src="https://cdn.discordapp.com/attachments/298839130144505858/512450353124343808/unknown.png" width="100%" alt="SRB2Kart">
</p>

Containerized version of [SRB2Kart](https://mb.srb2.org/showthread.php?t=43708), a kart racing mod based on the 3D Sonic the Hedgehog fangame [Sonic Robo Blast 2](https://srb2.org/), based on a modified version of [Doom Legacy](http://doomlegacy.sourceforge.net/). You can use SRB2Kart to run a SRB2Kart dedicated netgame server given the proper config.

## Usage

This will pull an image with SRB2Kart and start a dedicated netgame server on port `5029/udp`:

```bash
docker run -it --name srb2kart -p 5029:5029/udp ellite/srb2kart-server:latest
```

### Volumes and persistent data

#### Addons
  In order to load addons, bind the `/addons` volume to a host directory and copy them there.
  ```bash
  docker run -it --name srb2kart -p 5029:5029/udp -v /path/on/host/addons:/addons ellite/srb2kart-server:latest
  ```

#### Luafiles
  Do your addons save configs/data in the `/luafiles` folder? Bind the `/luafiles` volume to a host directory.
  ```bash
  docker run -it --name srb2kart -p 5029:5029/udp -v /path/on/host/luafiles:/luafiles ellite/srb2kart-server:latest
  ```

#### Config
  In order to configure server variables, bind the `/config` volume to a host directory, create `kartserv.cfg`, and edit it.
  ```bash
  docker run -it --name srb2kart -p 5029:5029/udp -v /path/on/host/config:/config ellite/srb2kart-server:latest
  ```
  ```bash
  sudo nano /path/on/host/config/kartserv.cfg
  ```

#### Persistent Data
  In order to persist data through server shutdowns, bind the `/data` volume to a host directory.
  ```bash
  docker run -it --name srb2kart -p 5029:5029/udp -v /path/on/host/data:/data ellite/srb2kart-server:latest
  ```

### systemd

Here's an example of how to run the container as a service on Linux with the help of `systemd`.

1. Create a systemd service descriptor file:

  ```ini
  # /etc/systemd/system/docker.srb2kart.service

  [Unit]
  Description=SRB2Kart Server
  Requires=docker.service
  After=docker.service
  # Ref: https://www.freedesktop.org/software/systemd/man/systemd.unit.html#StartLimitIntervalSec=interval
  StartLimitIntervalSec=60s
  StartLimitBurst=2

  [Service]
  TimeoutStartSec=0
  Restart=on-failure
  RestartSec=5s
  ExecStartPre=/usr/bin/docker stop %n
  ExecStartPre=/usr/bin/docker rm %n
  ExecStartPre=/usr/bin/docker pull ellite/srb2kart-server:<version>
  ExecStart=/usr/bin/docker run --rm --name %n \
      -v <path to data directory>:/data \
      -v <path to config directory>:/config \
      -v <path to addons directory>:/addons \
      -v <path to luafiles directory>:/luafiles \
      -p <port on host>:5029/udp \
      ellite/srb2kart-server:<version>

  [Install]
  WantedBy=multi-user.target
  ```

2. Enable starting the service on system boot:

  ```bash
  systemctl enable docker.srb2kart
  ```

## Manual Build

```bash
git clone https://github.com/ellite/srb2kart-server-docker
cd srb2kart-server-docker/
# Ref for version numbers: https://github.com/STJr/Kart-Public/releases
docker build --build-arg "SRB2KART_VERSION=<version>" \
    -t srb2kart-server:<version> .
```

The build will download the Source Code from a mirror (https://srb2kmods.ellite.dev/) and build the SRB2Kart executable, as well as download the data files (`/usr/share/games/SRB2Kart`) for SRB2Kart.

## License

This project is licensed under the [GPLv2 License](./LICENSE).
