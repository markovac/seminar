#!/bin/sh

BIN=/usr/local/bin/
NFDUMP="$BIN"nfdump
NFCAPD="$BIN"nfcapd
LIB=/usr/local/lib/
DEP="$LIB"libnfdump-1.6.19.so

[ -f $"NFDUMP" ] && exit 1
[ -f $"NFCAPD" ] && exit 2
[ -f $"DEP" ] && exit 3

echo "OK"
