#!/bin/bash

sudo cp 85-snacker-pair.rules /etc/udev/rules.d/.

sudo cp write-stand@.service /usr/lib/systemd/system/. 

sudo udevadm control --reload-rules && udevadm trigger

sudo systemctl daemon-reload
