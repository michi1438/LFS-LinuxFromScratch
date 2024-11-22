#!/bin/bash

source .env

mkdir -p -v $LSF/{etc,var} $LSF/usr/{bin,var,lib}

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
