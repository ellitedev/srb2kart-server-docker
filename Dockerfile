FROM alpine:latest

# Ref: https://github.com/STJr/Kart-Public/releases
ARG SRB2KART_VERSION=1.6

# Ref: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=srb2kart-data
RUN set -ex \
    && apk add --no-cache --virtual .build-deps curl \
    && mkdir -p /srb2kart-data \
    && curl -L -o /tmp/AssetsLinuxOnly.zip https://github.com/STJr/Kart-Public/releases/download/v${SRB2KART_VERSION}/AssetsLinuxOnly.zip \
    && unzip -d /srb2kart-data /tmp/AssetsLinuxOnly.zip \
    && find /srb2kart-data/mdls -type d -exec chmod 0755 {} \; \
    && mkdir -p /usr/games \
    && mv /srb2kart-data /usr/games/SRB2kart \
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
        sdl2 \
        zlib-dev \
        zlib-static \
    && git clone --depth=1 -b v${SRB2KART_VERSION} https://github.com/STJr/Kart-Public.git /srb2kart \
    && (cd /srb2kart/src \
        && make -j$(nproc) LINUX64=1 NOHW=1 NOGME=1) \
    && cp /srb2kart/bin/Linux64/Release/lsdl2srb2kart /usr/bin/srb2kart \
    && apk del .build-deps \
    && rm -rf /srb2kart 

# Adding in game dependancies and nginx
RUN apk add --no-cache \
        curl-dev \
        curl-static \
        libpng-dev \
        libpng-static \
        sdl2_mixer-dev \
        sdl2-dev \
        sdl2 \
        nginx \
        zip

# Volumes   
VOLUME /kart

# Copy over all the scripts
COPY --chmod=755 srb2kart.sh /usr/bin/srb2kart.sh
COPY default.conf /etc/nginx/http.d/default.conf

RUN echo "1" > /run/nginx/nginx.pid

# Make all the folders and links
RUN ln -s /kart /root/.srb2kart

WORKDIR /usr/games/SRB2kart

EXPOSE 5029/udp
EXPOSE 80/udp

STOPSIGNAL SIGINT

ENTRYPOINT [ "srb2kart.sh" ]