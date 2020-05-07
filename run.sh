#!/bin/sh

BIN=/usr/local/bin/
NFDUMP="$BIN"nfdump
NFCAPD="$BIN"nfcapd
LIB=/usr/local/lib/
DEP="$LIB"libnfdump-1.6.19.so

[ -f $"NFDUMP" ] && exit 1
[ -f $"NFCAPD" ] && exit 2
[ -f $"DEP" ] && exit 3

himage Alice echo "" > /dev/null 2>&1

[ $? -ne 0 ] && exit 4

himage router1 usr/sbin/ngctl -f- <<EOF
    mkpeer igb0: netflow lower iface0
    name igb0:lower netflow
    connect igb0: netflow: upper out0
    mkpeer netflow: ksocket export9 inet/dgram/udp
    name netflow:export9 exporter
    msg netflow: setconfig {iface=0 conf=7}
    msg netflow:export9 connect inet/10.0.0.1:4444
EOF

echo "Done"
