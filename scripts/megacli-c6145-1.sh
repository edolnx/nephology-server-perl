#!/bin/bash

failed()
{
  sleep 2 # Wait for the kernel to stop whining
  echo "Hrm, that didn't work.  Calling for help."
  sudo ipmitool chassis identify force
  echo "RAID Config failed: ${1}"
  while [ 1 ]; do sleep 10; done
  exit 1;
}

step()
{
  echo "Ateempting to ${2}..."
  sudo /opt/MegaRAID/MegaCli/MegaCli64 ${1} || failed ${2}
}

step "-CfgClr -a0" "Clear RAID Controller Config"
step "-AdpBIOS -Enbl -a0" "Enable RAID Controller for BIOS boot"
step "-AdpSetProp -BootWithPinnedCache -1 -a0" "Continue booting with data in cache"
step "-AdpSetProp -DsblCacheBypass -1 -a0" "Disable cache error messages"
step "-AdpSetProp -CacheFlushInterval -1 -a0" "Flush the cache frequently"
step "-CfgSpanAdd -r10 -Array0[252:0,252:1] -Array1[252:2,252:3] WB ADRA Direct -sz81920 -a0" "Setup boot volume"
step "-CfgSpanAdd -r10 -Array0[252:0,252:1] -Array1[252:2,252:3] WB ADRA Direct -a0" "Setup data volume"
step "-AdpBootDrive -Set -L0 -a0" "Set boot volume as default boot disk"



