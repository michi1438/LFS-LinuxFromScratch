#!/bin/bash

source .env

printf "${GREEN}LIMITED_DIR_LAYOUT.SH -- START${NC}\n"
mkdir -p -v $LFS/{etc,var} $LFS/usr/{bin,var,lib}

for i in bin lib sbin; do
	ln -sv usr/$i $LFS/$i
done 

case $(uname -m) in
	x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools

#Create new user lfs and group lfs in the aim of not f**ng up my computer
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

printf "${GREEN}LIMITED_DIR_LAYOUT.SH -- END${NC}\n\n"
