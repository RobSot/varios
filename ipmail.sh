#!/bin/sh

#sleep 100

/usr/bin/wget -q -O /home/pi/ip/ip2 http://ipecho.net/plain
/usr/bin/mutt -s "Startup IP (day check)" xxxxxxx@gmail.com < /home/pi/ip/ip

while sleep 28800
do
	/usr/bin/wget -q -O /home/pi/ip/ip2 http://ipecho.net/plain
	/usr/bin/mutt -s "IP day check" xxxxxxx@gmail.com < /home/pi/ip/ip2
done;

