#!/bin/bash


sudo cp 85-snacker-pair.rules /etc/udev/rules.d/.

sudo cp write-stand@.service /usr/lib/systemd/system/. 

sudo cp confirm-pair.service /usr/lib/systemd/system/. 

sudo systemctl enable confirm-pair.service

sudo udevadm control --reload-rules && udevadm trigger

sudo systemctl daemon-reload

sudo systemctl mask systemd-udev-settle
