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
step "-CfgLdAdd -r1[32:12,32:13] WB ADRA Direct -a0" "Setup boot volume"
step "-AdpBootDrive -Set -L0 -a0" "Set boot volume as default boot disk"
step "-CfgLdAdd -r0[32:0] WB ADRA Direct -a0" "Build OSD device 0 volume"
step "-CfgLdAdd -r0[32:1] WB ADRA Direct -a0" "Build OSD device 1 volume"
step "-CfgLdAdd -r0[32:2] WB ADRA Direct -a0" "Build OSD device 2 volume"
step "-CfgLdAdd -r0[32:3] WB ADRA Direct -a0" "Build OSD device 3 volume"
step "-CfgLdAdd -r0[32:4] WB ADRA Direct -a0" "Build OSD device 4 volume"
step "-CfgLdAdd -r0[32:5] WB ADRA Direct -a0" "Build OSD device 5 volume"
step "-CfgLdAdd -r0[32:6] WB ADRA Direct -a0" "Build OSD device 6 volume"
step "-CfgLdAdd -r0[32:7] WB ADRA Direct -a0" "Build OSD device 7 volume"
step "-CfgLdAdd -r0[32:8] WB ADRA Direct -a0" "Build OSD device 8 volume"
step "-CfgLdAdd -r0[32:9] WB ADRA Direct -a0" "Build OSD device 9 volume"
step "-CfgLdAdd -r0[32:10] WB ADRA Direct -a0" "Build OSD device 10 volume"
step "-CfgLdAdd -r0[32:11] WB ADRA Direct -a0" "Build OSD device 11 volume"


