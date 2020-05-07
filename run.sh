#!/bin/sh

BIN=/usr/local/bin/
NFDUMP="$BIN"nfdump
NFCAPD="$BIN"nfcapd
LIB=/usr/local/lib/
DEP="$LIB"libnfdump-1.6.19.so

[ -f $"NFDUMP" ] && exit 1
[ -f $"NFCAPD" ] && exit 2
[ -f $"DEP" ] && exit 3

himage Collector echo "" > /dev/null 2>&1

[ $? -ne 0 ] && exit 4

# Configure collector
hcp "$NFDUMP" Collector:"$BIN"
hcp "$NFCAPD" Collector:"$BIN"
hcp "$DEP" Collector:"$LIB"
himage Collector mkdir /usr/netflow
himage Collector nfcapd -S 1 -w -t 3600 -D -l /usr/netflow/ -p 4444 
# -D za pozadinski proces


# Configure Router to send netflow data to collector
himage Router ngctl mkpeer eth0: netflow lower iface0
himage Router ngctl name eth0:lower netflow
himage Router ngctl connect eth0: netflow: upper out0
himage Router ngctl mkpeer netflow: ksocket export9 inet/dgram/udp
himage Router ngctl name netflow:export9 exporter
himage Router ngctl msg netflow: setconfig { iface=0 conf=7 }
himage Router ngctl msg netflow:export9 connect inet/10.0.3.20:4444

echo "Done"
