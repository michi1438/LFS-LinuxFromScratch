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
