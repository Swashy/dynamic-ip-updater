#!/bin/bash

#Get the latest IP
newIP=$(tail -n 1 /home/swashy/ip.txt)
# Get the line number where our A record IP is.
iPLine=$(grep -n 'FINDME' /etc/nsd/zones/somewhere.mudcrabz.net.conf |  cut -d: -f1)
serialNumber=$(grep -e 'Serial' /etc/nsd/zones/somewhere.mudcrabz.net.conf | cut -d\; -f1)

#Insert IP line into number into awk, pipe the line into grep to get the IP.
currentIP=$(awk "NR==$iPLine" /etc/nsd/zones/somewhere.mudcrabz.net.conf | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

#https://www.gnu.org/software/bash/manual/bashref.html#Conditional-Constructs
if [ "$newIP" == "$currentIP" ]; then
    echo "IPs are the same!, \n newIP: $newIP \n currentIP: $currentIP"
  else
    echo "IP's are not the same!!, \n newIP: $newIP \n currentIP: $currentIP"

    sed -i "/FINDME/ s/$currentIP/$newIP/" /etc/nsd/zones/somewhere.mudcrabz.net.conf
    serialNumberIncremented=$(($serialNumber+1))
    
    #gawk -i inplace -v one="$serialLine" -v two="$serialNumber" -v three="$SerialNumberIncremented" 'NR==one { sub("two", "three") }; { print }' /etc/nsd/zones/somewhere.mudcrabz.net.conf
    #sed -i.bak "s/$serialNumber/$serialNumberIncremented/" /etc/nsd/zones/somewhere.mudcrabz.net.conf
    sed -i "/Serial/ s/$SerialNumber/$SerialNumberIncremented/" /etc/nsd/zones/somewhere.mudcrabz.net.conf
fi


