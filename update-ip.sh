#!/bin/bash

#
newIP=$(tail -n 1 /home/swashy/ip.txt)
changeIPLine=$(grep -n 'FINDME' /etc/nsd/zones/somewhere.mudcrabz.net.conf |  cut -d: -f1)
newSerialLine=$(grep -n 'Serial' /etc/nsd/zones/somewhere.mudcrabz.net.conf |  cut -d: -f1)

sed -i '$changeIPLines/.*/$currentIP/' file.txt

currentIP=$(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /etc/nsd/zones/somewhere.mudcrabz.net.conf)


