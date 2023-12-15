#!/bin/sh
#Thanks to Monitor#6336 for the script

KART_EXEC="/usr/bin/srb2kart"
ROOT_DIR="/kart"
MODS_DIR="/kart/mods"
SERVER_NAME="ModPack"

mkdir -p -m 755 $MODS_DIR/archive $MODS_DIR/chars $MODS_DIR/repo $MODS_DIR/loadfirst $MODS_DIR/loadlast $MODS_DIR/tracks

# if kartserv.cfg doesn't exist, touch it
if [ ! -f $ROOT_DIR/kartserv.cfg ]; then
    echo "kartserv.cfg not found, creating it"
    touch $ROOT_DIR/kartserv.cfg

    #  check if it was created, if not, exit
    if [ ! -f $ROOT_DIR/kartserv.cfg ]; then
        echo "kartserv.cfg could not be created, exiting"
        exit 1
    fi
fi

# if kartserv.cfg has the wrong permissions, fix it, srb2k needs to be able to execute it
if [ ! -x $ROOT_DIR/kartserv.cfg ]; then
    echo "kartserv.cfg has the wrong permissions, fixing it"
    chmod 755 $ROOT_DIR/kartserv.cfg

    #  check if it was fixed, if not, exit
    if [ ! -x $ROOT_DIR/kartserv.cfg ]; then
        echo "kartserv.cfg could not be fixed, exiting"
        exit 1
    fi
fi

# find all the files in order
LOAD_FIRST="$(find $MODS_DIR/loadfirst -type f | sort)"
CHARS="$(find $MODS_DIR/chars -type f | sort)"
TRACKS="$(find $MODS_DIR/tracks -type f | sort)"
LOAD_LAST="$(find $MODS_DIR/loadlast -type f | sort)"

# populate the repo folder and start NGINX
echo "Clearing mod repo"
find $MODS_DIR/repo -type l -exec rm '{}' ';'
echo "Done"
echo "Populating mod repo"
find $MODS_DIR/ -type f \( -not -path "$MODS_DIR/archive/*" \) -exec \
    ln -s '{}' $MODS_DIR/repo/ ';'
nginx
echo "NGINX STARTED"

# Create archive for download
echo "Creating archive"
ARCHIVE_NAME="$SERVER_NAME.zip"
echo $(find $MODS_DIR/repo -type l) > $MODS_DIR/archive/mods.txt
zip --junk-paths $MODS_DIR/archive/$ARCHIVE_NAME $(find $MODS_DIR/repo -type l)
ln $MODS_DIR/archive/$SERVER_NAME.zip $MODS_DIR/repo/$SERVER_NAME.zip
wait
echo "Done"

EXTRA_FILES="$LOAD_FIRST $CHARS $TRACKS $LOAD_LAST"
$KART_EXEC -dedicated -config $ROOT_DIR/kartserv.cfg -file $EXTRA_FILES