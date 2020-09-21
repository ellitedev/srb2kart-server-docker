FROM alpine:3.12

ARG SRB2KART_VERSION 1.3
ARG SRB2KART_USER srb2kart

# Ref: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=srb2kart-data
RUN set -ex \
    && apk add --no-cache --virtual .build-deps curl \
    && mkdir -p /srb2kart-data \
    && curl -L -o /tmp/srb2kart-v${SRB2KART_VERSION//./}-Installer.exe https://github.com/STJr/Kart-Public/releases/download/v${SRB2KART_VERSION}/srb2kart-v${SRB2KART_VERSION//./}-Installer.exe \
    && unzip -d /srb2kart-data /tmp/srb2kart-v${SRB2KART_VERSION//./}-Installer.exe \
    && find /srb2kart-data/mdls -type d -exec chmod 0755 {} \; \
    && mkdir -p /usr/share/games \
    && mv /srb2kart-data /usr/share/games/SRB2Kart \
    && apk del .build-deps

# Ref: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=srb2kart
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        bash \
        curl-dev \
        curl-static \
        gcc \
        git \
        gzip \
        libc-dev \
        libpng-dev \
        libpng-static \
        make \
        nghttp2-static \
        openssl-libs-static \
        sdl2_mixer-dev \
        sdl2-dev \
        sdl2-static \
        upx \
        zlib-dev \
        zlib-static \
    && git clone --depth=1 -b v${SRB2KART_VERSION} https://github.com/STJr/Kart-Public.git /srb2kart \
    && (cd /srb2kart/src \
        && make -j$(nproc) LINUX64=1 NOHW=1 NOGME=1 STATIC=1) \
    && cp /srb2kart/bin/Linux64/Release/lsdl2srb2kart /usr/bin/srb2kart \
    && apk del .build-deps \
    && rm -rf /srb2kart

VOLUME /data

RUN adduser -D -u 10001 ${SRB2KART_USER} \
    && ln -s /data /home/${SRB2KART_USER}/.srb2kart \
    && chown ${SRB2KART_USER} /data

USER ${SRB2KART_USER}

WORKDIR /usr/share/games/SRB2Kart

EXPOSE 5029/udp

STOPSIGNAL SIGINT

ENTRYPOINT ["srb2kart"]

CMD ["-dedicated"]
