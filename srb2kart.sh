#!/bin/sh

#Update Repo
rm -rf /addons/repo/*
ln /addons/tracks/* /addons/repo/
ln /addons/chars/* /addons/repo/
ln /addons/loadfirst/* /addons/repo/
ln /addons/loadlast/* /addons/repo/ 
nginx

#Launch Game
srb2kart -dedicated -file bonuschars.kart /addons/loadfirst/* /addons/chars/* /addons/tracks/* /addons/loadlast/*