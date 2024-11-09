#!/bin/bash

source .env #Sourcing .env for Shell and subShells variable...

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources


mkdir -v ./pkg_list/
curl -v -o pkg_list/md5sums https://www.linuxfromscratch.org/lfs/view/stable/md5sums
curl -v -o pkg_list/wget-list-sysv https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv

wget --input-file=pkg_list/wget-list-sysv --continue --directory-prefix=$LFS/sources

pushd $LFS/sources
  md5sum -c pkg_list/md5sums
popd
