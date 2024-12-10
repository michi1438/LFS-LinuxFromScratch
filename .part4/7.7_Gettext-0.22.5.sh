#!/usr/bin/bash
source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART4\//} -- START${NC}\n"
cd sources/

PACKAGE="gettext-0.22.5.tar.xz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${PACKAGE//.tar.xz/}/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.xz/}/"
		
	./configure --disable-shared

	make;
	[ $? != 0 ]
		exit 1;

	cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin 

else

	printf "${RED}${MSG_HEAD//PART4\//}: The ${PACKAGE//.tar.xz/} dir \
has already been built if this is false or you want to rebuild it, \
rm -rf /sources/${PACKAGE//.tar.xz/}. Run anew...${NC}\n"

fi

printf "${GREEN}${MSG_HEAD//PART4\//} -- END${NC}\n"
