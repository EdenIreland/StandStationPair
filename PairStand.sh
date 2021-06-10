#!/bin/bash
stationConfig=/home/eden/StationConfig/StationConfig.json
#stationConfig=/home/sixshooter/Documents/Eden/Code/StationConfig/StationConfig.json   

pair_ssid="$( jq -r '.AP_Wifi.SSID' "$stationConfig" )"
pair_pass="$( jq -r '.AP_Wifi.Password' "$stationConfig" )"

SSID="SSID:""$pair_ssid"
PASS="Pass:""$pair_pass"
echo $SSID

sleep 4
for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
    (
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
	#echo $devname
        [[ "$devname" == "bus/"* ]] && exit
        eval "$(udevadm info -q property --export -p $syspath)"
        [[ -z "$ID_SERIAL" ]] && exit
        device="/dev/$devname - $ID_SERIAL" #| grep Silicon_Labs_CP2104_USB | cut -d- -f1 
	espPort=$(echo "$device" | grep Silicon_Labs_CP2104_USB | cut -d " " -f1)
	#echo $device
	[[ -z "$espPort" ]] && exit
	stty -F "$espPort" raw -echo 115200

	echo -e "$SSID"> $espPort

	sleep 1

	echo -e "$PASS"> $espPort
 
    )
done

#echo "$pair_ssid" >> /home/sixshooter/Documents/Eden/Code/Snacker/StandPairing/RAN.txt

