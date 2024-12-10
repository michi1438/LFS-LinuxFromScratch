#!/bin/bash
source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART4\//} -- START${NC}\n"
cd sources/

PACKAGE="Python-3.12.5.tar.xz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${PACKAGE//.tar.xz/}/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.xz/}/"

	./configure --prefix=/usr   \
		--enable-shared \
		--without-ensurepip

	make
	[ $? != 0 ]
		exit 1;

	make install;

else

	printf "${RED}${MSG_HEAD//PART4\//}: The ${PACKAGE//.tar.xz/} dir \
has already been built if this is false or you want to rebuild it, \
rm -rf /sources/${PACKAGE//.tar.xz/}. Run anew...${NC}\n"

fi

printf "${GREEN}${MSG_HEAD//PART4\//} -- END${NC}\n"
