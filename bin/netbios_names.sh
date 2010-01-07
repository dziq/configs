#!/bin/sh
# netbios_names.sh copyright by Łukasz Fidosz 
# distributed under GNU General Public License version 3

if [ $UID -ne 0 ]; then
	echo "---"
	echo "Błąd: skrypt musi zostać uruchomiony z konta root'a!"
	echo "---"
	exit
fi

mkdir -p /tmp/hostnames
cd /tmp/hostnames

nmap -A $(nmap -sP 192.168.0.1/24 | awk '/Host.*\ be up/ {print $2}') > hosty
csplit -s -k -f host hosty '/^Interesting ports on/' {*}

for i in /tmp/hostnames/host0*
do
	if [ -n "$(grep 'NetBIOS name' $i)" ];
	then
		ip=$(awk '/Interesting ports on/ {print $4}' $i)
		name=$(awk '/NetBIOS name:/ {print $5}' $i | tr -d ,)
		echo "$ip $name"
	fi
done

rm -rf ../hostnames
