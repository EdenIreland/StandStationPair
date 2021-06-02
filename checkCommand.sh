#!/bin/bash
arg=$(stty -F /dev/ttyUSB0 raw -echo 115200)
if [ $? -eq 0 ]; then
    echo OK
else
    echo FAIL
fi
