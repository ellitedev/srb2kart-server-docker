#!/bin/sh

cd /usr/games/SRB2Kart || exit

ADDONS=$(ls /addons)

if [ -z "$ADDONS" ]; then
    /bin/srb2kart -dedicated -config kartserv.cfg -home /data $*
    exit
fi

# Intentional word splitting
/bin/srb2kart -dedicated -config kartserv.cfg -home /data $* -file $ADDONS

# script from https://github.com/BrianAllred/srb2kart