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
	rm -rf /home/lfs/part3/
	ln main_call.sh /home/lfs/main_call_lfs.sh
	mkdir -v /home/lfs/part3/
	ln part3/* /home/lfs/part3/

	[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

	printf "${RED}MAIN_CALL.SH: You have been switched to lfs user, \
call bash main_call.sh this will run the rest of the script...${NC}\n"
	su --login lfs

	for dir in $LFS/sources/{sed-4.9/,tar-1.35/,xz-5.6.2/,file-5.45/,grep-3.11/,gzip-1.13/,m4-1.4.19/,gawk-5.3.0/,gcc-14.2.0/,glibc-2.40/,make-4.4.1/,bash-5.2.32/,ncurses-6.5/,patch-2.7.6/,linux-6.10.5/,coreutils-9.5/,diffutils-3.10/}
	do
		if [ ! -d "$dir" ]; then
			printf "${RED}MAIN_CALL.SH: Chapter 6 was not finished all the \
required directories are not there, $dir is missing...${NC}\n"
			exit
		fi
		printf "${RED}MAIN_CALL.SH: dir $dir exists!${NC}\n"
	done

	printf "${RED}MAIN_CALL.SH: Chapter 7 -- Entering Chroot.${NC}\n"
	chown --from lfs -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
	case $(uname -m) in
	  x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
	esac
	
	printf "${RED}MAIN_CALL.SH: Creating virtual fs!${NC}\n"
	mkdir -pv $LFS/{dev,proc,sys,run}
	mount -v --bind /dev $LFS/dev
	mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
	mount -vt proc proc $LFS/proc
	mount -vt sysfs sysfs $LFS/sys
	mount -vt tmpfs tmpfs $LFS/run

	if [ -h $LFS/dev/shm ]; then
		install -v -d -m 1777 $LFS$(realpath /dev/shm)
	else
		mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
	fi

	chroot "$LFS" /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$TERM"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		MAKEFLAGS="-j$(nproc)"      \
		TESTSUITEFLAGS="-j$(nproc)" \
		/bin/bash --login

	[ ! -e /etc/bash.bashrc.NOUSE ] || mv -v /etc/bash.bashrc.NOUSE /etc/bash.bashrc
	exit
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
	bash ${PART_3_DIR}6.5_Coreutils-9.5.sh
	bash ${PART_3_DIR}6.6_Diffutils-3.10.sh
	bash ${PART_3_DIR}6.7_File-5.45.sh
	bash ${PART_3_DIR}6.8_Findutils-4.10.0.sh
	bash ${PART_3_DIR}6.9_Gawk-5.3.0.sh
	bash ${PART_3_DIR}6.10_Grep-3.11.sh
	bash ${PART_3_DIR}6.11_Gzip-1.13.sh
	bash ${PART_3_DIR}6.12_Make-4.4.1.sh
	bash ${PART_3_DIR}6.13_Patch-2.7.6.sh
	bash ${PART_3_DIR}6.14_Sed-4.9.sh
	bash ${PART_3_DIR}6.15_Tar-1.35.sh
	bash ${PART_3_DIR}6.16_Xz-5.6.2.sh
	bash ${PART_3_DIR}6.17_Binutils-2.43.1_pass_2.sh
	bash ${PART_3_DIR}6.18_Gcc-14.2.0_pass_2.sh
	printf "${RED}MAIN_CALL_LFS.SH: You need to switch to root, \
exit to return to root, the rest of the script should execute on its own...${NC}\n"

fi

#If test suites fail a lot... https://www.linuxfromscratch.org/lfs/faq.html#no-ptys
#Some know and discarded testsuite fails.. https://www.linuxfromscratch.org/lfs/build-logs/12.2/
