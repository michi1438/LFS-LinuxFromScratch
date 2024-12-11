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
	package="make-4.4.1.tar.gz"
	if [ ! -d "${package//.tar.gz/}/" ]; then
		tar --extract --file $package
			pushd "${package//.tar.gz/}/"
				./configure --prefix=/usr   \
							--without-guile \
							--host=$LFS_TGT \
							--build=$(build-aux/config.guess)
				make && make DESTDIR=$LFS install ;
			popd
	else
		printf "${RED}${msg_head//PART3\//}: ${package//.tar.gz/}/ has already \
been built if this is not true, or you need to rebuild it \
rm the ${package//.tar.gz/}/ dir in $LFS/sources and run anew...${NC}\n"
		printf "${GREEN}${msg_head//PART3\//} -- END${NC}\n"
		exit 0;
	fi
popd

printf "${GREEN}${msg_head//PART3\//} -- END${NC}\n"
exit 0;
