#!/bin/bash

source .env #SHELL variables for partitionning...
printf "${GREEN}PARTITIONING.SH -- START${NC}\n"

fdisk $DISK << EOF > /dev/null
O
.bck_partition.fdis
g
n
1

+20G
t
22
n


+80G
t
2
home
n



t
3
21
O
.new_part.fdis
EOF

printf "${RED}PARTITIONING.SH: LAYOUT OF .bck_partition.fdis${NC}\n"
cat .bck_partition.fdis
printf "${RED}###############${NC}\n"
echo 
printf "${RED}PARTITIONING.SH: LAYOUT OF .new_part.fdis${NC}\n"
cat .new_part.fdis
printf "${RED}###############${NC}\n"

echo
printf "${RED}PARTITIONING.SH: Do you agree with those changes to disk \"yes\" or \"no\" ?${NC}\n"
while [ 0 -ne 1 ]
do
	read answer
	if [ "$answer" == "yes" ]; then
		fdisk $DISK << EOF
		I
		new_part.fdis
		w
EOF
		break
	elif [ "$answer" == "no" ]; then 
		printf "${GREEN}PARTITIONING.SH -- END${NC}\n\n"
		exit
	else
		printf "${RED}PARTITIONING.SH: Answers can only be \"yes\" or \"no\" ?${NC}\n"
fi
done

echo
printf "${RED}PARTITIONING.SH: Verifying state of the $DISK disk${NC}\n"
sfdisk -V $DISK

echo
printf "${RED}PARTITIONING.SH: Creating FileSystem on ${DISK}1 part${NC}\n"
mkfs -v -t ext4 ${DISK}1
printf "${RED}PARTITIONING.SH: Creating FileSystem on ${DISK}2 part${NC}\n"
mkfs -v -t ext4 ${DISK}2
printf "${RED}PARTITIONING.SH: Creating FileSystem on ${DISK}3 part${NC}\n"
mkfs -v -t ext4 ${DISK}3

printf "${GREEN}PARTITIONING.SH -- END${NC}\n\n"
