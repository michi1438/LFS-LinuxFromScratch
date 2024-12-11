#!/bin/bash

source .env #Sourcing .env for Shell and subShells variable...
printf "${GREEN}MOUNT_PARTITIONS.SH -- START${NC}\n"

mkdir -pv ${LFS}
CHECK_MOUNT=$(mount | grep -m 1 -o "${LFS} ")
if [ "$CHECK_MOUNT" != "${LFS} " ]; then
	mount -v -t ext4 ${DISK}1 ${LFS}
else
	printf "${RED}MOUNT_PARTITIONS.SH: ${CHECK_MOUNT} is already mounted..${NC}\n"
fi

mkdir -pv ${LFS}/home
CHECK_MOUNT=$(mount | grep -m 1 -o "${LFS}/home ")
if [ "$CHECK_MOUNT" != "${LFS}/home " ]; then
	mount -v -t ext4 ${DISK}2 ${LFS}/home
else
	printf "${RED}MOUNT_PARTITIONS.SH: ${CHECK_MOUNT} is already mounted..${NC}\n"
fi

mkdir -pv ${LFS}/src
CHECK_MOUNT=$(mount | grep -m 1 -o "${LFS}/src")
if [ "$CHECK_MOUNT" != "${LFS}/src" ]; then
	mount -v -t ext4 ${DISK}3 ${LFS}/src
else
	printf "${RED}MOUNT_PARTITIONS.SH: ${CHECK_MOUNT} is already mounted..${NC}\n"
fi
echo

#CHECK for nosuid or nodev in mount output
printf "${RED}MOUNT_PARTITIONS.SH: CHECK for \"nosuid\" or \"nodev\" in mount output.${NC}\n"

CHECK_MOUNT=$(mount | grep ${DISK})
if [[ "$CHECK_MOUNT" =~ "nosuid" ]]; then
	printf "${RED}MOUNT_PARTITIONS.SH: \"nosuid\" in mount output (NEEDS ATTENTION).${NC}\n"
fi
if [[ "$CHECK_MOUNT" =~ "nodev" ]]; then
	printf "${RED}MOUNT_PARTITIONS.SH: \"nodev\" in mount output (NEEDS ATTENTION).${NC}\n"
fi

echo
printf "${RED}MOUNT_PARTITIONS.SH: Mount output.${NC}\n"
printf "$CHECK_MOUNT\n"

echo
printf "${RED}MOUNT_PARTITIONS.SH: Swapon output.${NC}\n"
swapon

echo
printf "${RED}MOUNT_PARTITIONS.SH: lsblk output.${NC}\n"
lsblk $DISK

printf "${GREEN}MOUNT_PARTITIONS.SH -- END${NC}\n\n"
