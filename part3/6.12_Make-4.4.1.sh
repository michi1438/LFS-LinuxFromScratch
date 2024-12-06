source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART3\//} -- START${NC}\n"
cd $LFS/sources/

PACKAGE="make-4.4.1.tar.gz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${LFS}/sources/${PACKAGE//.tar.gz/}/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.gz/}/"

	./configure --prefix=/usr   \
				--without-guile \
				--host=$LFS_TGT \
				--build=$(build-aux/config.guess)

	make && make DESTDIR=$LFS install ;

else
	printf "${RED}${MSG_HEAD//PART3\//}: The ${PACKAGE//.tar.gz/} have already \
been built if this is not true, or you need to rebuild it \
rm the ${PACKAGE//.tar.gz/} in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}${MSG_HEAD//PART3\//} -- END${NC}\n"
