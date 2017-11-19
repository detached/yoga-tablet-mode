#! /bin/bash

SYSFS_FILE="/sys/devices/platform/thinkpad_acpi/hotkey_tablet_mode"

function evaluate_status {
  
  if [ $1 -eq "0" ]; then
    
    echo "Notebook mode"      
    xinput set-prop 13 "Device Enabled" 1
    xinput set-prop 14 "Device Enabled" 1
  fi

  if [ $1 -eq "1" ]; then
    
    echo "Tablet mode"
    xinput set-prop 13 "Device Enabled" 0
    xinput set-prop 14 "Device Enabled" 0
  fi 
}

tablet_mode=$(cat $SYSFS_FILE)
evaluate_status $tablet_mode

while inotifywait -qq $SYSFS_FILE; do

  new_status=$(cat $SYSFS_FILE)

  if [ ! $new_status -eq $tablet_mode ]; then

    tablet_mode=$new_status

    evaluate_status $tablet_mode
  fi
done

