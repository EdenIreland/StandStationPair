
#!/bin/bash
#Identifier used for ESP32
#/dev/ttyUSB0 - Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_01DE90F3

for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
    (
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        [[ "$devname" == "bus/"* ]] && exit
        eval "$(udevadm info -q property --export -p $syspath)"
        [[ -z "$ID_SERIAL" ]] && exit
        device="/dev/$devname - $ID_SERIAL" #| grep Silicon_Labs_CP2104_USB | cut -d- -f1 
	espPort=$(echo "$device" | grep Silicon_Labs_CP2104_USB | cut -d " " -f1)
	[[ -z "$espPort" ]] && exit
	python -m esptool --chip esp32 --port "$espPort" --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 80m --flash_size detect 0xe000 ./boot_app0.bin 0x1000 ./bootloader_qio_80m.bin 0x10000 ./ESP_REST_Sketch.ino.bin 0x8000 ./ESP_REST_Sketch.ino.partitions.bin 
    )
done
