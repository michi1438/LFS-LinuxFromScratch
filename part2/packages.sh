#!/bin/bash

source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}PACKAGES.SH -- START${NC}\n"

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

if [ ! -d "${LFS}/pkg_list" ]; then
	mkdir -v ${LFS}/pkg_list/
	curl -o ${LFS}/md5sums https://www.linuxfromscratch.org/lfs/view/stable/md5sums
	curl -o ${LFS}/pkg_list/wget-list-sysv https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv
else
	printf "${RED}PACKAGES.SH: Running with already existing ${LFS}/sources/pkg_list/ dir, \
if you want a fresh download from the book rm -rf ${LFS}/sources/pkg_list and restart the process...${NC}\n"
fi

pushd $LFS/sources
CHECK=$(md5sum -c ../md5sums | grep -o "OK" | wc -l)
	if [ "${CHECK}" != "$(cat ../md5sums | wc -l)" ]; then
		printf "${RED}PACKAGES.SH: The packages do not match the md5sums do you want to download packages anew? \"yes\", \"no\" or \"abort\"?${NC}\n"
		while [ 0 -ne 1 ]
		do
			read answer
			if [ "$answer" == "yes" ]; then
				wget --input-file=${LFS}/pkg_list/wget-list-sysv --continue --directory-prefix=$LFS/sources
				break
			elif [ "$answer" == "abort" ]; then 
				printf "${GREEN}LIMITED_DIR_LAYOUT.SH -- END${NC}\n\n"
				exit
			elif [ "$answer" == "no" ]; then
				break
			else
				printf "${RED}PACKAGES.SH: Answers can only be \"yes\", \"no\" or \"abort\" ?${NC}\n"
		fi
		done
	fi

CHECK=$(md5sum -c ../md5sums | grep -o "OK" | wc -l)
	if [ "${CHECK}" != "$(cat ../md5sums | wc -l)" ]; then
		printf "${RED}PACKAGES.SH: The md5-sums either aren't all OK or there is not the same number of packages and signatures...${NC}\n"
	else
		rm $LFS/md5sums
		rm -rf ${LFS}/pkg_list/
	fi
popd

if [ "$(whoami)" != "root" ]; then
	printf "${RED}PACKAGES.SH: Check the user if no \"root\" then the package's sources might be owned by unnamed UID... Mind this msg..${NC}\n"
fi

printf "${GREEN}PACKAGES.SH -- END${NC}\n\n"
