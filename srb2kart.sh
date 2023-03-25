#!/bin/sh

#Update Repo
rm -rf /addons/repo/*
ln /addons/tracks/* /addons/repo/
ln /addons/chars/* /addons/repo/
ln /addons/loadfirst/* /addons/repo/
ln /addons/loadlast/* /addons/repo/ 

#Launch Game
srb2kart -dedicated -file /addons/loadfirst/* /addons/chars/* /addons/tracks/* /addons/loadlast/*