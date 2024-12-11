#!/bin/bash
source .env #Sourcing .env for Shell and subShells variable...

function finish {
	echo
	printf "${RED}${msg_head//PART4\//} something has failed and the \
the script has been interupted...${NC}\n"
}
trap finish ERR

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

msg_head=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${msg_head//PART4\//} -- START${NC}\n"
pushd "sources/"
	package="util-linux-2.40.2.tar.xz"
	if [ ! -d "${package//.tar.xz/}/" ]; then
		tar -xf $package
		(
		cd "${package//.tar.xz/}/"
		mkdir -pv /var/lib/hwclock
		./configure --libdir=/usr/lib     \
					--runstatedir=/run    \
					--disable-chfn-chsh   \
					--disable-login       \
					--disable-nologin     \
					--disable-su          \
					--disable-setpriv     \
					--disable-runuser     \
					--disable-pylibmount  \
					--disable-static      \
					--disable-liblastlog2 \
					--without-python      \
					ADJTIME_PATH=/var/lib/hwclock/adjtime \
					--docdir=/usr/share/doc/util-linux-2.40.2
		make
		make install
		)
	else
		printf "${RED}${msg_head//PART4\//}: The ${package//.tar.xz/} dir \
has already been built if this is false or you want to rebuild it, \
rm -rf /sources/${package//.tar.xz/}. Run anew...${NC}\n"
		printf "${GREEN}${msg_head//PART4\//} -- END${NC}\n"
		exit 0;
	fi
popd

printf "${GREEN}${msg_head//PART4\//} -- END${NC}\n"
exit 0;
