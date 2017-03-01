#!/bin/bash

#Get the latest IP
newIP=$(tail -n 1 /home/swashy/ip.txt)
# Get the line number where our A record IP and Serial is
iPLine=$(grep -n 'FINDME' /etc/nsd/zones/somewhere.mudcrabz.net.conf |  cut -d: -f1)
serialLine=$(grep -n 'Serial' /etc/nsd/zones/somewhere.mudcrabz.net.conf |  cut -d: -f1)
serialNumber=$(grep -e 'Serial' /etc/nsd/zones/somewhere.mudcrabz.net.conf | cut -d\; -f1)

#Insert IP line into number into awk, pipe the line into grep to get the IP.
currentIP=$(awk "NR==$iPLine" /etc/nsd/zones/somewhere.mudcrabz.net.conf | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

#https://www.gnu.org/software/bash/manual/bashref.html#Conditional-Constructs
if [ "$newIP" == "$currentIP" ]; then
    echo "IPs are the same!, \n newIP: $newIP \n currentIP: $currentIP"
  else
    echo "IP's are not the same!!, \n newIP: $newIP \n currentIP: $currentIP"
    #awk "NR==$IPLine { sub("AAA", "BBB") }"
    # TODO Still trying to figure out how to replace a string in a specific line, but just going by IP now.
    sed -i.bak "s/$currentIP/$newIP/" /etc/nsd/zones/somewhere.mudcrabz.net.conf
    serialNumberIncremented=$(($serialNumber+1))
    
    gawk -i inplace "NR==$serialLine { sub("$serialNumber", "$serialNumberIncremented") }; { print }" /etc/nsd/zones/somewhere.mudcrabz.net.conf
    #sed -i.bak "s/$serialNumber/$serialNumberIncremented/" /etc/nsd/zones/somewhere.mudcrabz.net.conf
fi


