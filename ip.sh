#!/bin/sh

ip="0"
ipactual="0"

#sleep 60

/usr/bin/wget -q -O /home/pi/ip/ip http://ipecho.net/plain
ipactual=`cat /home/pi/ip/ip`
/usr/bin/mutt -s "Startup IP" xxxx@gmail.com < /home/pi/ip/ip



while sleep 15
do
	/usr/bin/wget -q -O /home/pi/ip/ip http://ipecho.net/plain
	ip=`cat /home/pi/ip/ip`
	if [ "$ip" != "$ipactual" ]; then
		if [ "$ip" != "" ]; then
			ipactual=$ip
			/usr/bin/mutt -s "IP change" xxxxx@gmail.com < /home/pi/ip/ip
		fi
	fi
done;
