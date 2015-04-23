#!/bin/sh

ICMP="8.8.4.4"  # Servidor al que se mandan pings de control
TIME=2          # Tiempo entre cada bucle
TIMEOUT=10	# Tiempo de espera de respuesta al ping
USING_3G="no"   # suponemos 3G inactivo al arranque

while sleep $TIME
do
        if [ "$USING_3G" = "yes" ]; then
		if [ "`ip r list | grep default | awk '{print $5}'`" = "wlan0" ]; then
			ip r delete default via 192.168.159.10 dev eth0
			ip r add default via 192.168.43.1 dev wlan0
                fi
                if ping -q -c 1 -W $TIMEOUT -I wlan0 $ICMP > /dev/null; then
                       	echo "wlan0 net OK"
               	else
                       	echo "wlan0 net Fail 1"
                       	echo "Activando ethernet net..."
			ip r delete default via 192.168.43.1 dev wlan0
                       	ip r add default via 192.168.159.10 dev eth0
                       	USING_3G="no"
                fi
        else	# Usando ethernet (o arranque del script)
        	while [ "`ip r list | grep default | awk '{print $5}'`" != "wlan0" ];		# Espera mientras el 3G no está activo
		do
			if [ "`ip r list | grep default | awk '{print $5}'`" = "" ]; then	# Revisa que eth0 tenga ruta si está presente
				ip r add default via 192.168.159.10 dev eth0			# Ojo que no pise al 3G cuando se active, revisar
			fi
			echo "waiting for wlan0 up"
			sleep 1
		done
                if ping -q -c 1 -W $TIMEOUT -I wlan0 $ICMP > /dev/null; then
                        echo "wlan0 net disponible, activando wlan0..."
                        USING_3G="yes"
                else
                	echo "wlan0 net Fail 2"
                       	echo "Activando ethernet net..."
			ip r delete default via 192.168.43.1 dev wlan0
                       	ip r add default via 192.168.159.10 dev eth0
                fi
        fi
done;
