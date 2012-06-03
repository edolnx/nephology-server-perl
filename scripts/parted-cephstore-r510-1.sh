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


echo "Making label on OSD devices"
for DEV in sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm sdn sdo
  do sudo parted -s -acylinder /dev/$DEV mklabel gpt || failed "mklabel $DEV"
done
echo "Creating osd device 1 journal label"
sudo parted -s -acylinder /dev/sdb mkpart osd-device-001-journal 1 100% || failed "mkpart 001-journal"
echo "Creating osd device 1 data label"
sudo parted -s -acylinder /dev/sdc mkpart osd-device-001-data 1 100% || failed "mkpart 001-data"
echo "Creating osd device 2 journal label"
sudo parted -s -acylinder /dev/sdd mkpart osd-device-002-journal 1 100% || failed "mkpart 002-journal"
echo "Creating osd device 2 data label"
sudo parted -s -acylinder /dev/sde mkpart osd-device-002-data 1 100% || failed "mkpart 002-data"
echo "Creating osd device 3 journal label"
sudo parted -s -acylinder /dev/sdf mkpart osd-device-003-journal 1 100% || failed "mkpart 003-journal"
echo "Creating osd device 3 data label"
sudo parted -s -acylinder /dev/sdg mkpart osd-device-003-data 1 100% || failed "mkpart 003-data"
echo "Creating osd device 4 journal label"
sudo parted -s -acylinder /dev/sdh mkpart osd-device-004-journal 1 100% || failed "mkpart 004-journal"
echo "Creating osd device 4 data label"
sudo parted -s -acylinder /dev/sdi mkpart osd-device-004-data 1 100% || failed "mkpart 004-data"
echo "Creating osd device 5 journal label"
sudo parted -s -acylinder /dev/sdj mkpart osd-device-005-journal 1 100% || failed "mkpart 005-journal"
echo "Creating osd device 5 data label"
sudo parted -s -acylinder /dev/sdk mkpart osd-device-005-data 1 100% || failed "mkpart 005-data"
echo "Creating osd device 6 journal label"
sudo parted -s -acylinder /dev/sdl mkpart osd-device-006-journal 1 100% || failed "mkpart 006-journal"
echo "Creating osd device 6 data label"
sudo parted -s -acylinder /dev/sdm mkpart osd-device-006-data 1 100% || failed "mkpart 006-data"
echo "Creating osd device 7 journal label"
sudo parted -s -acylinder /dev/sdn mkpart osd-device-007-journal 1 100% || failed "mkpart 007-journal"
echo "Creating osd device 7 data label"
sudo parted -s -acylinder /dev/sdo mkpart osd-device-007-data 1 100% || failed "mkpart 007-data"
