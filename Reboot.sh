#!/bin/bash
#Bus 001 Device 009: ID 1a86:55d4 QinHeng Electronics 


espPort="/dev/ttyACM2"

stty -F "$espPort" raw -echo 115200 cs8 cread clocal
sleep 2

echo -e "Reboot" > "$espPort"
#cat "$espPort"

echo hello >> /home/eden/PairStand/txt

#cat "$espPort"

