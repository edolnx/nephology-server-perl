#!/bin/bash

failed()
{
  sleep 2 # Wait for the kernel to stop whining
  echo "Hrm, that didn't work.  Calling for help."
  sudo ipmitool chassis identify force
  echo "OSD partitioning failed: ${1}"
  while [ 1 ]; do sleep 10; done
  exit 1;
}

echo "Create label on data drive"
sudo parted -s -acylinder /dev/sdb mklabel gpt || failed "mklabel sdb"
echo "Creating partition for data"
sudo parted -s -acylinder /dev/sdb mkpart data 1 100% || failed "mkpart data"
