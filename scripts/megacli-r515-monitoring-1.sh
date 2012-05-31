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
step "-CfgLdAdd -r0[32:12] WT ADRA Direct -a0" "Setup boot volume"
step "-AdpBootDrive -Set -L0 -a0" "Set boot volume as default boot disk"
step "-CfgSpanAdd -r10 -Array0[32:0,32:2,32:4,32:6,32:8,32:10] -Array1[32:1,32:3,32:5,32:7,32:9,32:11] WB ADRA Cached -a0" "Build RAID10 for data"


