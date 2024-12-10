#!/bin/bash

#Chapter 7. Entering chroot
source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

PART_4_DIR=part4/

function exit_if_failed ()
{
	bash ${PART_4_DIR}$1
	if [ $? != 0 ]; then
		printf "${RED}${MSG_HEAD}: The last command \"$1\" failed...${NC}\n"
		exit 1
	fi
}

if [ "$USER" = "" ] # no user are set yet so this is normal
then
	env
	ln -sv /usr/bin/bash /bin/sh
	bash ${PART_4_DIR}Creating_directories.sh
	bash ${PART_4_DIR}Essential_files_n_symlinks.sh
	
	
	exit_if_failed "7.7_Gettext-0.22.5.sh"
	exit_if_failed "7.8_Bison-3.8.2.sh"
	exit_if_failed "7.9_Perl-5.40.0.sh"
	exit_if_failed "7.10_Python-3.12.5.sh"
	exit_if_failed "7.11_Texinfo-7.1.sh"
	exit_if_failed "7.12_Util-linux-2.40.2.sh"

else
	printf "${RED}${MSG_HEAD}: \$USER = \"$USER\", not the right user \
users should'nt exist yet...${NC}\n"

fi
