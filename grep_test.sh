#!/bin/sh

while [ "`ip r list | grep default | awk '{print $5}'`" != "wlan0" ];
do
	if [ "`ip r list | grep default | awk '{print $5}'`" = "" ]; then
		sudo ip r add default via 192.168.159.10 dev eth0
	fi
	echo "waiting for wlan0 up"
	sleep 1
done

if [ "`ip r list | grep default | awk '{print $5}'`" = "wlan0" ]; then
	echo "si"
else
	echo "no"
fi

if ping -q -c 1 -W 10 -I wlan0 8.8.8.8 > /dev/null; then
	echo "wifi net OK"
else
	echo "wifi net fail"
fi
