#!/bin/sh

ICMP="8.8.4.4"  # Servidor al que se mandan pings de control
TIME=2          # Tiempo entre cada bucle
TIMEOUT=10	# Tiempo de espera de respuesta al ping
USING_3G="no"   # suponemos 3G inactivo al arranque

while sleep $TIME
do
        if [ "$USING_3G" = "yes" ]; then
		if [ "`ip r list | grep default | awk '{print $5}'`" = "eth0" ]; then
			ip r delete default via 192.168.159.10 dev eth0
			ip r add default via 10.64.64.64 dev 3g-wan
                fi
                if ping -q -c 1 -W $TIMEOUT -I 3g-wan $ICMP > /dev/null; then
                       	echo "3G net OK"
               	else
                       	echo "3G net Fail 1"
                       	echo "Activando ethernet net..."
			ifdown wan
			ifup wan
                       	ip r add default via 192.168.159.10 dev eth0
                       	USING_3G="no"
                fi
        else	# Usando ethernet (o arranque del script)
        	while [ "`ip r list | grep default | awk '{print $5}'`" != "3g-wan" ];		# Espera mientras el 3G no está activo
		do
			if [ "`ip r list | grep default | awk '{print $5}'`" = "" ]; then	# Revisa que eth0 tenga ruta si está presente
				ip r add default via 192.168.159.10 dev eth0			# Ojo que no pise al 3G cuando se active, revisar
			fi
			echo "waiting for 3g-wan up"
			sleep 1
		done
                if ping -q -c 1 -W $TIMEOUT -I 3g-wan $ICMP > /dev/null; then
                        echo "3G net disponible, activando 3G..."
                        USING_3G="yes"
                else
                	echo "3G net Fail 2"
                       	echo "Activando ethernet net..."
			ifdown wan
			ifup wan
                       	ip r add default via 192.168.159.10 dev eth0
                fi
        fi
done;
