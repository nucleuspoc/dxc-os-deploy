#!/bin/bash

# Get the beginning and end of the free space for creating the new 
# partition
freeBegin=$(parted /dev/sda unit MB print free|grep "Free"|tail -1|awk '{print $1}')
freeEnd=$(parted /dev/sda unit MB print free|grep "Free"|tail -1|awk '{print $2}')

# Create a new partition from the beginning of the new free space
# to the end of the free space
parted -s --align=opt /dev/sda mkpart primary ${freeBegin} ${freeEnd}

# rescan the partition table and disk
partx -a /dev/sda > /dev/null 2>&1
echo 1 > /sys/bus/scsi/devices/2\:0\:0\:0/rescan

# get the newest partition's number
newPartNumber=$(parted /dev/sda unit MB print|grep MB|tail -1|awk '{print $1}')

# add the new partition to LVM
pvcreate /dev/sda$newPartNumber

# add the new pv to an existing volume group 
vgextend rhel /dev/sda$newPartNumber

# extend the logical volume you want to add more space to
lvextend -l +100%FREE /dev/rhel/root

# resize the filesystem so linux can use the space
xfs_growfs /dev/rhel/root

