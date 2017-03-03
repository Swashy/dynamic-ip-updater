#!/bin/bash

#Get the latest IP
newIP=$(tail -n 1 /home/swashy/ip.txt)
# Get the line number where our A record IP is.
iPLine=$(grep -n 'FINDME' /etc/nsd/zones/somewhere.mudcrabz.net.conf |  cut -d: -f1)
serialNumber=$(grep -e 'Serial' /etc/nsd/zones/somewhere.mudcrabz.net.conf | cut -d\; -f1)
#strip trailing and leading whitespace
serialNumber="$(echo -e "${serialNumber}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

echo "Serial number is $serialNumber"
#Insert IP line into number into awk, pipe the line into grep to get the IP.
currentIP=$(awk "NR==$iPLine" /etc/nsd/zones/somewhere.mudcrabz.net.conf | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

#https://www.gnu.org/software/bash/manual/bashref.html#Conditional-Constructs
if [ "$newIP" == "$currentIP" ]; then
    echo -e "IPs are the same! \n$currentIP"
  else
    echo -e "IP's are not the same!! \nnewIP: $newIP \ncurrentIP: $currentIP"

    # These sed command's first field "/FINDME/" and "/[0-9]{1-10}/" will go to the line with this match
    # the arg after replaces a finding.
    sed -i.bak "/FINDME/ s/$currentIP/$newIP/" /etc/nsd/zones/somewhere.mudcrabz.net.conf
    serialNumberIncremented=$(($serialNumber+1))
    echo "New serial will be $serialNumberIncremented"
    sed -i.bak "/Serial/ s/[0-9]/$serialNumberIncremented/" /etc/nsd/zones/somewhere.mudcrabz.net.conf
    nsd-control reload
fi


