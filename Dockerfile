FROM alpine:3.12

# Ref: https://github.com/STJr/Kart-Public/releases
ARG SRB2KART_VERSION=1.6

# Ref: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=srb2kart-data
RUN set -ex \
    && apk add --no-cache --virtual .build-deps curl \
    && mkdir -p /srb2kart-data \
    && curl -L -o /tmp/srb2kart-v${SRB2KART_VERSION//./}-Installer.zip https://srb2kmods.ellite.dev/srb2kinstaller_${SRB2KART_VERSION}.zip \
    && unzip -d /srb2kart-data /tmp/srb2kart-v${SRB2KART_VERSION//./}-Installer.zip \
    && rm /tmp/srb2kart-v${SRB2KART_VERSION//./}-Installer.zip \
    && find /srb2kart-data/mdls -type d -exec chmod 0755 {} \; \
    && mkdir -p /usr/games \
    && mv /srb2kart-data /usr/games/SRB2Kart \
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
    && mkdir -p /data \
    && git clone --depth=1 -b v${SRB2KART_VERSION} https://github.com/STJr/Kart-Public.git /srb2kart \
    && (cd /srb2kart/src \
        && make -j$(nproc) LINUX64=1 NOHW=1 NOGME=1) \
    && cp /srb2kart/bin/Linux64/Release/lsdl2srb2kart /usr/bin/srb2kart \
    && apk del .build-deps \
    && apk add --no-cache\
        curl-dev \
        curl-static \
        libpng-dev \
        libpng-static \
        sdl2_mixer-dev \
        sdl2-dev \
        sdl2-static \
    && rm -rf /srb2kart

VOLUME /data
VOLUME /config
VOLUME /addons
VOLUME /luafiles

RUN ln -sf /config/kartserv.cfg /usr/games/SRB2Kart/kartserv.cfg && ln -sf /addons /usr/games/SRB2Kart/addons && ln -sf /luafiles /usr/games/SRB2Kart/luafiles

WORKDIR /usr/games/SRB2Kart

EXPOSE 5029/udp

COPY srb2kart.sh /usr/bin/srb2kart.sh
RUN chmod a+x /usr/bin/srb2kart.sh

STOPSIGNAL SIGINT

ENTRYPOINT ["srb2kart.sh"]
