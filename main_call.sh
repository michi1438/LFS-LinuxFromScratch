#!/bin/bash

#II. Preparing for the Build

source .env #Sourcing .env for Shell and subShells variable...
PART_2_DIR=part2/

if [ -n "$DISK" ]; then 
	printf "${RED}MAIN_CALL.SH: .env is not set fill and change the name of \
	   the .env_layout file...${NC}\n"
fi

bash ${PART_2_DIR}version_check.sh
bash ${PART_2_DIR}partitioning.sh
bash ${PART_2_DIR}mount_partitions.sh
bash ${PART_2_DIR}packages.sh
bash ${PART_2_DIR}limited_dir_layout.sh 

[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

su --login lfs

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS=-j$(nproc)
EOF

source ~/.bash_profile

echo "there"

#If test suites fail a lot... https://www.linuxfromscratch.org/lfs/faq.html#no-ptys
#Some know and discarded testsuite fails.. https://www.linuxfromscratch.org/lfs/build-logs/12.2/

# III. Building the LFS Cross Toolchain and Temporary Tools

PART_3_DIR=part3/


# --- END
exit
exit
[ ! -e /etc/bash.bashrc.NOUSE ] || mv -v /etc/bash.bashrc.NOUSE /etc/bash.bashrc
