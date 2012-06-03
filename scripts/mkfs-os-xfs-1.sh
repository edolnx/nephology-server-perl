#!/bin/bash

failed()
{
  sleep 2 # Wait for the kernel to stop whining
  echo "Hrm, that didn't work.  Calling for help."
  sudo ipmitool chassis identify force
  echo "OS partitioning failed: ${1}"
  while [ 1 ]; do sleep 10; done
  exit 1;
}


echo "Creating root volume"
sudo mkfs.xfs -f -d su=64k,sw=1 /dev/sda1 || failed "mkfs.xfs sda1"
echo "Creating tmp volume"
sudo mkfs.xfs -f -d su=64k,sw=1 /dev/sda5 || failed "mkfs.xfs sda5"
echo "Creating vartmp volume"
sudo mkfs.xfs -f -d su=64k,sw=1 /dev/sda6 || failed "mkfs.xfs sda6"
echo "Creating var volume"
sudo mkfs.xfs -f -d su=64k,sw=1 /dev/sda7 || failed "mkfs.xfs sda7"
