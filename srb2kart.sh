#!/bin/sh
shopt -s globstar 
shopt -s nocaseglob 
shopt -s nullglob

#Update Repo
rm -rf /addons/repo/*.+(pk3|wad|lua|soc)
ln /addons/tracks/**/*.* /addons/repo/
ln /addons/chars/**/*.+(pk3|wad) /addons/repo/
ln /addons/loadfirst/**/*.* /addons/repo/
ln /addons/loadlast/**/*.* /addons/repo/ 

#Launch Game
srb2kart -dedicated -file /addons/loadfirst/**/*.* /addons/chars/**/*.* /addons/tracks/**/*.* /addons/loadlast/**/*.*