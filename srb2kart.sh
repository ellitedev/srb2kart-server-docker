#!/bin/sh
#Thanks to Monitor#6336 for the script

KART_EXEC="/usr/bin/srb2kart"
KART_DIR="/kart"
SERVER_NAME="spinOut"

# find all the files in order
LOAD_FIRST="$(find $KART_DIR/mods/loadfirst -type f | sort)"
CHARS="$(find $KART_DIR/mods/chars -type f | sort)"
TRACKS="$(find $KART_DIR/mods/tracks -type f | sort)"
LOAD_LAST="$(find $KART_DIR/mods/loadlast -type f | sort)"

# populate the index folder and start NGINX
echo "Clearing mod index"
find $KART_DIR/mods/index -type l -exec rm '{}' ';'
echo "Done"
echo "Populating mod index"
find $KART_DIR/mods/ -type f \( -not -path "$KART_DIR/mods/archive/*" \) -exec \
    ln -s '{}' $KART_DIR/mods/index/ ';'
nginx
echo "NGINX STARTED"
wait
echo "Done"

# Create archive for download
echo "Creating archive"
ARCHIVE_NAME="$SERVER_NAME.zip"
echo $(find $KART_DIR/mods/index -type l) > $KART_DIR/mods/archive/mods.txt
zip --junk-paths $KART_DIR/mods/archive/$ARCHIVE_NAME $(find $KART_DIR/mods/index -type l)
ln $KART_DIR/mods/archive/$SERVER_NAME.zip $KART_DIR/mods/index/$SERVER_NAME.zip
wait
echo "Done"

EXTRA_FILES="$LOAD_FIRST $CHARS $TRACKS $LOAD_LAST"
$KART_EXEC -dedicated -file bonuschars.kart $EXTRA_FILES
