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

		tar --extract --file $package
		(
			cd "${package//.tar.xz/}/"
			mkdir -v build
				(
					cd build
					time { ../configure --prefix=$LFS/tools				\
										--with-sysroot=$LFS				\
										--target=$LFS_TGT				\
										--disable-nls					\
										--enable-gprofng=no				\
										--disable-werror				\
										--enable-new-dtags				\
										--enable-default-hash-style=gnu	\
										&& make && make install; }
				)
		)
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
