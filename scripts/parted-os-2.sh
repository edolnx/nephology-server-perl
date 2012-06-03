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


echo "Making msdos label on sda"
sudo parted -s -acylinder /dev/sda mklabel msdos || failed "mklabel sda"
sleep 2
echo "Creating root volume"
sudo parted -s -acylinder /dev/sda mkpart primary 201 10441 || failed "mkpart sda1"
sleep 2
echo "Creating swap volume"
sudo parted -s -acylinder /dev/sda mkpart primary 10441 18633 || failed "mkpart sda2"
sleep 1
sudo mkswap /dev/sda2 || failed "mkswap sda2"
sleep 2
echo "Creating extended volume"
sudo parted -s -acylinder /dev/sda mkpart extended 18633 100% || failed "mkpart sda3"
sleep 1
echo "Creating tmp volume"
sudo parted -s -acylinder /dev/sda mkpart logical 18633 26825 || failed "mkpart sda5"
sleep 1
echo "Creating vartmp volume"
sudo parted -s -acylinder /dev/sda mkpart logical 26825 35017 || failed "mkpart sda6"
sleep 1
echo "Creating var volume"
sudo parted -s -acylinder /dev/sda mkpart logical 35017 45497 || failed "mkpart sda7"
sleep 1
echo "Creating home volume"
sudo parted -s -acylinder /dev/sda mkpart logical 45497 100% || failed "mkpart sda8"
sleep 1
