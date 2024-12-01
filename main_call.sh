#!/bin/bash

#II. Preparing for the Build

source .env #Sourcing .env for Shell and subShells variable...

PART_2_DIR=part2/
PART_3_DIR=part3/


if [ "$USER" = "root" ] 
then
	if [ -z "$DISK" ]; then 
		printf "${RED}MAIN_CALL.SH: .env is not set fill and change the name of \
 the .env_layout file...${NC}\n"
	fi

	bash ${PART_2_DIR}version_check.sh
	bash ${PART_2_DIR}partitioning.sh
	bash ${PART_2_DIR}mount_partitions.sh
	bash ${PART_2_DIR}packages.sh
	bash ${PART_2_DIR}limited_dir_layout.sh 
	bash ${PART_2_DIR}set_env.sh

	chown -R lfs:lfs part3/
	chown lfs:lfs main_call.sh
	rm -rf /home/lfs/main_call_lfs.sh
	ln main_call.sh /home/lfs/main_call_lfs.sh
	mkdir -v /home/lfs/part3/
	ln part3/* /home/lfs/part3/

	[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

	printf "${RED}MAIN_CALL.SH: You have been switched to lfs user call bash main_call.sh \
this will run the rest of the script...${NC}\n"
	su --login lfs

	[ ! -e /etc/bash.bashrc.NOUSE ] || mv -v /etc/bash.bashrc.NOUSE /etc/bash.bashrc
elif [ "$USER" = "lfs" ]
then

	## chapter 5 compiling the cross toolchain

	bash ${PART_3_DIR}Binutils_pass_1.sh
	bash ${PART_3_DIR}Gcc_pass_1.sh
	bash ${PART_3_DIR}Linux-6.10.5_api_headers.sh
	bash ${PART_3_DIR}Glibc-2.40.sh
	bash ${PART_3_DIR}Libstdc++_of_gcc.sh
	
	## chapter 6 Compiling with the cross toolchain more temp tools including \
	## gcc_pass_2 and binutils_pass_2

	bash ${PART_3_DIR}m4-1.4.19.sh
	bash ${PART_3_DIR}ncurses-6.5.sh
	bash ${PART_3_DIR}bash-5.2.32.sh
	bash ${PART_3_DIR}6.5_coreutils-9.5.sh
fi

#If test suites fail a lot... https://www.linuxfromscratch.org/lfs/faq.html#no-ptys
#Some know and discarded testsuite fails.. https://www.linuxfromscratch.org/lfs/build-logs/12.2/

