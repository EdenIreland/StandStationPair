#!/bin/bash
stationConfig=/home/eden/StationConfig/StationConfig.json
#stationConfig=/home/sixshooter/Documents/Eden/Code/StationConfig/StationConfig.json   

pair_ssid="$( jq -r '.AP_Wifi.SSID' "$stationConfig" )"
pair_pass="$( jq -r '.AP_Wifi.Password' "$stationConfig" )"

pair_ssid="$pair_ssid"
pair_pass="$pair_pass"
#debug
echo $pair_ssid

sleep 4
for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
    (
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        #echo $devname
        [[ "$devname" == "bus/"* ]] && exit
        eval "$(udevadm info -q property --export -p $syspath)"
        [[ -z "$ID_SERIAL" ]] && exit
        device="/dev/$devname - $ID_SERIAL" 

        #Look for serial converter matching stand by manufacturer
        ##Bus 001 Device 009: ID 1a86:55d4 QinHeng Electronics 
        espPort=$(echo "$device" | grep "1a86_USB_Single_Serial" | cut -d " " -f1)

        [[ -z "$espPort" ]] && exit
        #open the port
        stty -F "$espPort" raw -echo 115200 cs8 cread clocal
        #sleep to prevent garbage being sent during port opening
        sleep 2

        #echo to port and do not ouput any trailing new lines
        #escape characters are used o/*n the stand to side to process ";"
        echo -e "wifi;""$pair_ssid"";""$pair_pass"> $espPort

    )
done


