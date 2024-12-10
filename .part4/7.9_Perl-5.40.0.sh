#!/bin/bash
source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART4\//} -- START${NC}\n"
cd sources/

PACKAGE="perl-5.40.0.tar.xz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${PACKAGE//.tar.xz/}/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.xz/}/"
		
	sh Configure -des                                         \
				 -D prefix=/usr                               \
				 -D vendorprefix=/usr                         \
				 -D useshrplib                                \
				 -D privlib=/usr/lib/perl5/5.40/core_perl     \
				 -D archlib=/usr/lib/perl5/5.40/core_perl     \
				 -D sitelib=/usr/lib/perl5/5.40/site_perl     \
				 -D sitearch=/usr/lib/perl5/5.40/site_perl    \
				 -D vendorlib=/usr/lib/perl5/5.40/vendor_perl \
				 -D vendorarch=/usr/lib/perl5/5.40/vendor_perl

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
