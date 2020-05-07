#!/bin/sh

himage Collector echo "" > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo "execute arp.imn"
	exit 4
fi

# Configure collector
himage Collector mkdir cache > /dev/null 2>&1
hcp temp/* Collector:/cache/

himage Collector pkg add cache/m4-1.4.18_1,1.txz > /dev/null 2>&1
himage Collector pkg add cache/indexinfo-0.3.1.txz > /dev/null 2>&1
himage Collector pkg add cache/rrdtool-1.7.2_2.txz > /dev/null 2>&1
himage Collector pkg add cache/libtool-2.4.6_1.txz > /dev/null 2>&1
himage Collector pkg add cache/nfdump-1.6.19.txz > /dev/null 2>&1

himage Collector mkdir /usr/netflow > /dev/null 2>&1
himage Collector nfcapd -S 1 -w -t 3600 -l /usr/netflow/ -p 4444 
# -D za pozadinski proces
# nfcapd i nfdump bacaju error


# Configure Router to send netflow data to collector
himage Router ngctl mkpeer eth0: netflow lower iface0 > /dev/null 2>&1
himage Router ngctl name eth0:lower netflow > /dev/null 2>&1
himage Router ngctl connect eth0: netflow: upper out0 > /dev/null 2>&1
himage Router ngctl mkpeer netflow: ksocket export9 inet/dgram/udp > /dev/null 2>&1
himage Router ngctl name netflow:export9 exporter > /dev/null 2>&1
himage Router ngctl msg netflow: setconfig { iface=0 conf=7 } > /dev/null 2>&1
himage Router ngctl msg netflow:export9 connect inet/10.0.3.20:4444 > /dev/null 2>&1

echo "Done"
