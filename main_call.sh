#!/bin/bash
#II. Preparing for the Build
source .env #Sourcing .env for Shell and subShells variable...

msg_head=$(echo $0 | awk '{ print toupper($0) }')

function finish {
	echo
	printf "${RED}${msg_head//PART3\//} something has failed and the \
the script has been interupted...${NC}\n"
}
trap finish ERR

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

part_2_dir=part2/
part_3_dir=part3/

if [ "$USER" = "root" ] 
then
	if [ -z "$DISK" ]; then 
		printf "${RED}MAIN_CALL.SH: .env is not set fill and change the name of \
 the .env_layout file...${NC}\n"
	fi

	bash ${part_2_dir}version_check.sh
	bash ${part_2_dir}partitioning.sh
	bash ${part_2_dir}mount_partitions.sh
	bash ${part_2_dir}packages.sh
	bash ${part_2_dir}limited_dir_layout.sh 
	bash ${part_2_dir}set_env.sh

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

	#This is the second part executed once you leave lfs user right before
	#you enter the CHROOT part..	

	for dir in $LFS/sources/{sed-4.9/,tar-1.35/,xz-5.6.2/,file-5.45/,\
grep-3.11/,gzip-1.13/,m4-1.4.19/,gawk-5.3.0/,gcc-14.2.0/,\
glibc-2.40/,make-4.4.1/,bash-5.2.32/,ncurses-6.5/,patch-2.7.6/,\
linux-6.10.5/,coreutils-9.5/,diffutils-3.10/}
	do
		if [ ! -d "$dir" ]; then
			printf "${RED}MAIN_CALL.SH: Chapter 6 was not finished all the \
required directories are not there, $dir is missing...${NC}\n"
			exit 0;
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
	mountpoint -q "${LFS}/dev" || mount -v --bind /dev $LFS/dev
	mountpoint -q "${LFS}/dev/pts" || mount -vt devpts devpts \
		-o gid=5,mode=0620 $LFS/dev/pts
	mountpoint -q "${LFS}/proc" || mount -vt proc proc $LFS/proc
	mountpoint -q "${LFS}/sys" || mount -vt sysfs sysfs $LFS/sys
	mountpoint -q "${LFS}/run" || mount -vt tmpfs tmpfs $LFS/run

	if [ -h $LFS/dev/shm ]; then
		install -v -d -m 1777 $LFS$(realpath /dev/shm)
	else
		mountpoint -q "${LFS}/dev/shm" || mount -vt tmpfs \
			-o nosuid,nodev tmpfs $LFS/dev/shm
	fi

	cp -v .main_call_chroot.sh ${LFS}/main_call_chroot.sh
	mkdir -v ${LFS}/part4 || true
	cp -rvf .part4/* ${LFS}/part4/
	sed '/LFS=\|DISK=\|^ *$/d' .env > ${LFS}/.env

	printf "${RED}MAIN_CALL.SH: This next command sends you in the chroot \
you will have to call main_call_chroot.sh!${NC}\n"
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

	bash ${part_3_dir}5.2_Binutils_pass_1.sh
	bash ${part_3_dir}5.3_Gcc_pass_1.sh
	bash ${part_3_dir}5.4_Linux-6.10.5_api_headers.sh
	bash ${part_3_dir}5.5_Glibc-2.40.sh
	bash ${part_3_dir}5.6_Libstdc++_of_gcc.sh
	
	## chapter 6 Compiling with the cross toolchain more temp tools including \
	## gcc_pass_2 and binutils_pass_2

	bash ${part_3_dir}6.2_M4-1.4.19.sh
	bash ${part_3_dir}6.3_Ncurses-6.5.sh
	bash ${part_3_dir}6.4_Bash-5.2.32.sh
	bash ${part_3_dir}6.5_Coreutils-9.5.sh
	bash ${part_3_dir}6.6_Diffutils-3.10.sh
	bash ${part_3_dir}6.7_File-5.45.sh
	bash ${part_3_dir}6.8_Findutils-4.10.0.sh
	bash ${part_3_dir}6.9_Gawk-5.3.0.sh
	bash ${part_3_dir}6.10_Grep-3.11.sh
	bash ${part_3_dir}6.11_Gzip-1.13.sh
	bash ${part_3_dir}6.12_Make-4.4.1.sh
	bash ${part_3_dir}6.13_Patch-2.7.6.sh
	bash ${part_3_dir}6.14_Sed-4.9.sh
	bash ${part_3_dir}6.15_Tar-1.35.sh
	bash ${part_3_dir}6.16_Xz-5.6.2.sh
	bash ${part_3_dir}6.17_Binutils-2.43.1_pass_2.sh
	bash ${part_3_dir}6.18_Gcc-14.2.0_pass_2.sh
	printf "${RED}MAIN_CALL_LFS.SH: You need to switch to root, \
exit to return to root, the rest of the script should execute on its own...${NC}\n"

fi

#If test suites fail a lot... https://www.linuxfromscratch.org/lfs/faq.html#no-ptys
#Some know and discarded testsuite fails.. https://www.linuxfromscratch.org/lfs/build-logs/12.2/
