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

	package="binutils-2.43.1.tar.xz"

	if [ ! -d "${package//.tar.xz/}/" ]; then

		printf "${RED}${msg_head//PART3\//}: The ${package//.tar.xz/} dir \
has not been built yet, contrary to most package this is not normal as this \
is the 2nd pass of ${package//.tar.xz/} in the $LFS/sources. Run anew...${NC}\n"
		exit 1;
	elif [ ! -d "${package//.tar.xz/}/build2/" ]; then

		pushd "${package//.tar.xz/}/"
			sed '6009s/$add_dir//' -i ltmain.sh
			mkdir -v build2
			(
				cd       build	#This is normal we only use build2 
								#as a reference or flag.	
				../configure                   \
					--prefix=/usr              \
					--build=$(../config.guess) \
					--host=$LFS_TGT            \
					--disable-nls              \
					--enable-shared            \
					--enable-gprofng=no        \
					--disable-werror           \
					--enable-64-bit-bfd        \
					--enable-new-dtags         \
					--enable-default-hash-style=gnu

				make && make DESTDIR=$LFS install ;
			)
			rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
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
