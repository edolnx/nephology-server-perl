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
step "-CfgLdAdd -r0[32:0] WB NORA Direct -sz10240 -a0" "Build OSD device 0 journal"
step "-CfgLdAdd -r0[32:0] WT ADRA Direct -a0" "Build OSD device 0 data volume"
step "-CfgLdAdd -r0[32:1] WB NORA Direct -sz10240 -a0" "Build OSD device 1 journal"
step "-CfgLdAdd -r0[32:1] WT ADRA Direct -a0" "Build OSD device 1 data volume"
step "-CfgLdAdd -r0[32:2] WB NORA Direct -sz10240 -a0" "Build OSD device 2 journal"
step "-CfgLdAdd -r0[32:2] WT ADRA Direct -a0" "Build OSD device 2 data volume"
step "-CfgLdAdd -r0[32:3] WB NORA Direct -sz10240 -a0" "Build OSD device 3 journal"
step "-CfgLdAdd -r0[32:3] WT ADRA Direct -a0" "Build OSD device 3 data volume"
step "-CfgLdAdd -r0[32:4] WB NORA Direct -sz10240 -a0" "Build OSD device 4 journal"
step "-CfgLdAdd -r0[32:4] WT ADRA Direct -a0" "Build OSD device 4 data volume"
step "-CfgLdAdd -r0[32:5] WB NORA Direct -sz10240 -a0" "Build OSD device 5 journal"
step "-CfgLdAdd -r0[32:5] WT ADRA Direct -a0" "Build OSD device 5 data volume"
step "-CfgLdAdd -r0[32:6] WB NORA Direct -sz10240 -a0" "Build OSD device 6 journal"
step "-CfgLdAdd -r0[32:6] WT ADRA Direct -a0" "Build OSD device 6 data volume"
step "-CfgLdAdd -r0[32:7] WB NORA Direct -sz10240 -a0" "Build OSD device 7 journal"
step "-CfgLdAdd -r0[32:7] WT ADRA Direct -a0" "Build OSD device 7 data volume"
step "-CfgLdAdd -r0[32:8] WB NORA Direct -sz10240 -a0" "Build OSD device 8 journal"
step "-CfgLdAdd -r0[32:8] WT ADRA Direct -a0" "Build OSD device 8 data volume"
step "-CfgLdAdd -r0[32:9] WB NORA Direct -sz10240 -a0" "Build OSD device 9 journal"
step "-CfgLdAdd -r0[32:9] WT ADRA Direct -a0" "Build OSD device 9 data volume"
step "-CfgLdAdd -r0[32:10] WB NORA Direct -sz10240 -a0" "Build OSD device 10 journal"
step "-CfgLdAdd -r0[32:10] WT ADRA Direct -a0" "Build OSD device 10 data volume"
step "-CfgLdAdd -r0[32:11] WB NORA Direct -sz10240 -a0" "Build OSD device 11 journal"
step "-CfgLdAdd -r0[32:11] WT ADRA Direct -a0" "Build OSD device 11 data volume"


