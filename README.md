# Sonic Robo Blast 2 Kart Server

![Docker Build Status](https://img.shields.io/docker/build/rwanyoike/srb2kart-server-docker)
![Docker Image Version](https://img.shields.io/docker/v/rwanyoike/srb2kart-server-docker)
![Docker Image Size](https://img.shields.io/docker/image-size/rwanyoike/srb2kart-server-docker)

> Containerized version of SRB2Kart.

<h1 align="center">
  <img src="https://cdn.discordapp.com/attachments/298839130144505858/512450353124343808/unknown.png" alt="SRB2Kart">
</h1>

Containerized version of [SRB2Kart](https://mb.srb2.org/showthread.php?t=43708), a kart racing mod based on the 3D Sonic the Hedgehog fangame [Sonic Robo Blast 2](https://srb2.org/), based on a modified version of [Doom Legacy](http://doomlegacy.sourceforge.net/). You can use SRB2Kart to run a SRB2Kart dedicated netgame server given the proper config.

## Usage

This will pull an image with SRB2Kart and start a dedicated netgame server on port `5029/udp`:

```shell
docker run -it --name srb2kart-server --publish 5029:5029/udp rwanyoike/srb2kart-server
```

## Manual Build

```shell
git clone https://github.com/rwanyoike/srb2kart-server-docker
cd srb2kart-server-docker/
docker build --tag srb2kart-server:latest .
```

The build will clone the [STJr/Kart-Public](https://github.com/STJr/Kart-Public) repository and build the SRB2Kart executable, as well as download data files for SRB2Kart. Building the executable can take some time depending on your hardware.

## License

This project is licensed under the [GPLv2 License](./LICENSE).
