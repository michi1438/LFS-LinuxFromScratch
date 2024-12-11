#!/bin/bash

#Chapter 7. Entering chroot
source .env #Sourcing .env for Shell and subShells variable...

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

USER=${USER-default}
msg_head=$(echo $0 | awk '{ print toupper($0) }')

part_4_dir=part4/

if [ "${USER}" = "default" ] # no user are set yet so this is normal
then
	ln --symbolic --verbose /usr/bin/bash /bin/sh || true
	bash "${part_4_dir}Creating_directories.sh"
	bash "${part_4_dir}Essential_files_n_symlinks.sh"
	
	
	bash "${part_4_dir}7.7_Gettext-0.22.5.sh"
	bash "${part_4_dir}7.8_Bison-3.8.2.sh"
	bash "${part_4_dir}7.9_Perl-5.40.0.sh"
	bash "${part_4_dir}7.10_Python-3.12.5.sh"
	bash "${part_4_dir}7.11_Texinfo-7.1.sh"
	bash "${part_4_dir}7.12_Util-linux-2.40.2.sh"

	bash "${part_4_dir}Cleaning_up.sh"

else
	printf "${RED}${msg_head}: \${USER} = \"${USER}\", not the right user \
users should'nt exist yet...${NC}\n"
	exit 1;

fi
exit
