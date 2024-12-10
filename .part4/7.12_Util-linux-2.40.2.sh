#!/bin/bash
source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART4\//} -- START${NC}\n"
cd sources/

PACKAGE="util-linux-2.40.2.tar.xz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${PACKAGE//.tar.xz/}/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.xz/}/"

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
	[ $? != 0 ]
		exit 1;
	
	make install

else

	printf "${RED}${MSG_HEAD//PART4\//}: The ${PACKAGE//.tar.xz/} dir \
has already been built if this is false or you want to rebuild it, \
rm -rf /sources/${PACKAGE//.tar.xz/}. Run anew...${NC}\n"

fi

printf "${GREEN}${MSG_HEAD//PART4\//} -- END${NC}\n"
