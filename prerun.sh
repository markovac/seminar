#!/bin/sh

# Load netgraph modules
kldload netgraph ng_netflow ng_ether ng_ksocket

# Remove cached pkg files and download libtool and nfdump
#rm /var/cache/pkg/* > /dev/null 2>&1
#pkg fetch libtool > /dev/null 2>&1
#pkg fetch nfdump > /dev/null 2>&1

#mv /var/cache/pkg/* temp/

echo "done"
