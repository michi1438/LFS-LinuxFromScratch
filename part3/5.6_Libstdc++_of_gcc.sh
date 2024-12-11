#!/bin/bash
source .env #Sourcing .env for Shell and subShells variable...

function finish {
	echo
	printf "${RED}${msg_head//PART3\//} something has failed and the \
the script has been interupted...${NC}\n"
}
trap finish ERR

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

msg_head=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${msg_head//PART3\//} -- START${NC}\n"
pushd "${LFS}/sources/"

package="gcc-14.2.0.tar.xz"

if [ ! -d "${package//.tar.xz/}/build2" ]; then
	pushd "${package//.tar.xz/}/"
		mkdir -v build
		mkdir -v build2
		cd       build
		(
			make distclean && rm ./config.cache ;
			../libstdc++-v3/configure           \
				--host=$LFS_TGT                 \
				--build=$(../config.guess)      \
				--prefix=/usr                   \
				--disable-multilib              \
				--disable-nls                   \
				--disable-libstdcxx-pch         \
				--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0
			make && make DESTDIR=$LFS install; 
			rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
		)
	popd	
else
	printf "${RED}${msg_head//PART3\//}: ${package//.tar.xz/}/ has already \
been built if this is not true, or you need to rebuild it \
rm the ${package//.tar.xz/}/ dir in $LFS/sources and run anew...${NC}\n"
	printf "${GREEN}${msg_head//PART3\//} -- END${NC}\n"
	exit 0;
fi
popd

printf "${GREEN}${msg_head//PART3\//} -- END${NC}\n"
exit 0;