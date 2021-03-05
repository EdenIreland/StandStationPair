#!/bin/bash

#echo $address >> /home/sixshooter/Documents/Eden/Code/Snacker/StandPairing/test.tx

address=$(ls -l /sys/bus/usb-serial/devices | grep $1)
usb="${address##*/}"

path=/dev/$usb 

sleep 10
echo $address >> /home/sixshooter/Documents/Eden/Code/Snacker/StandPairing/test.txt
echo -ne "Reboot"  > "$path"

