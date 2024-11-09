#!/bin/bash

source .env #Sourcing .env for Shell and subShells variable...

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources


mkdir -v ./pkg_list/
curl -o $LFS/md5sums https://www.linuxfromscratch.org/lfs/view/stable/md5sums
curl -o pkg_list/wget-list-sysv https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv

wget --input-file=pkg_list/wget-list-sysv --continue --directory-prefix=$LFS/sources

pushd $LFS/sources
CHECK=$(md5sum -c ../md5sums | grep -o "OK" | wc -l)
	if [ "${CHECK}" != "$(cat ../md5sums | wc -l)" ]; then
		printf "${RED}PACKAGES.SH: The md5-sums either aren't all OK or there is not the same number of packages and signatures...${NC}\n"
	fi
	rm $LFS/sources/md5sums
popd

rm -rf ./pkg_list/
if [ "$(whoami)" != "root" ]; then
	printf "${RED}PACKAGES.SH: Check the user if no \"root\" then the package's sources might be owned by unnamed UID... Mind this msg..${NC}\n"
fi
