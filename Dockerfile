FROM alpine:3.12

# Ref: https://github.com/STJr/Kart-Public/releases
ARG SRB2KART_VERSION=1.6
ARG SRB2KART_USER=srb2kart

# Ref: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=srb2kart-data
RUN set -ex \
    && apk add --no-cache --virtual .build-deps curl \
    && mkdir -p /srb2kart-data \
    && curl -L -o /tmp/AssetsLinuxOnly.zip https://github.com/STJr/Kart-Public/releases/download/v${SRB2KART_VERSION}/AssetsLinuxOnly.zip \
    && unzip -d /srb2kart-data /tmp/AssetsLinuxOnly.zip \
    && find /srb2kart-data/mdls -type d -exec chmod 0755 {} \; \
    && mkdir -p /usr/games \
    && mv /srb2kart-data /usr/games/SRB2Kart \
    && rm /tmp/AssetsLinuxOnly.zip \
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
        htop \
        nano \
        nginx \
    && rm -rf /srb2kart

VOLUME /data
VOLUME /addons
VOLUME /luafiles

COPY srb2kart.sh /usr/bin/srb2kart.sh
RUN chmod a+x /usr/bin/srb2kart.sh

RUN adduser -D -u 1000 ${SRB2KART_USER} \
    && mkdir /data && mkdir /addons && mkdir /luafiles \
    && ln -s /data /home/${SRB2KART_USER}/.srb2kart && ln -s /luafiles /home/${SRB2KART_USER}/.srb2kart/luafiles \
    && chown ${SRB2KART_USER} /data && chown ${SRB2KART_USER} /addons && chown ${SRB2KART_USER} /luafiles

USER ${SRB2KART_USER}

WORKDIR /data
EXPOSE 5029/udp

STOPSIGNAL SIGINT

CMD [ "srb2kart.sh" ]