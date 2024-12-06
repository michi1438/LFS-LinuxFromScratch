source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART3\//} -- START${NC}\n"
cd $LFS/sources/

PACKAGE="xz-5.6.2.tar.xz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${LFS}/sources/${PACKAGE//.tar.xz/}/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.xz/}/"

	./configure --prefix=/usr                     \
				--host=$LFS_TGT                   \
				--build=$(build-aux/config.guess) \
				--disable-static                  \
				--docdir=/usr/share/doc/xz-5.6.2

	make && make DESTDIR=$LFS install ;

	rm -v $LFS/usr/lib/liblzma.la

else
	printf "${RED}${MSG_HEAD//PART3\//}: The ${PACKAGE//.tar.xz/} have already \
been built if this is not true, or you need to rebuild it \
rm the ${PACKAGE//.tar.xz/} in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}${MSG_HEAD//PART3\//} -- END${NC}\n"
