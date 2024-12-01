source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}${0//part3\//} -- START${NC}\n" | awk '{ print toupper($0) }'
cd $LFS/sources/

PACKAGE="diffutils-3.10.tar.xz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${LFS}/sources/diffutils-3.10/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.xz/}/"

	./configure --prefix=/usr   \
				--host=$LFS_TGT \
				--build=$(./build-aux/config.guess)

	make && make DESTDIR=$LFS install ;

else
	printf "${RED}${MSG_HEAD//PART3\//}: The ${PACKAGE//.tar.xz/} have already been built if this is not true, or you need to rebuild it \
rm the ${PACKAGE//.tar.xz/} in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}${0//part3\//} -- END${NC}\n" | awk '{ print toupper($0) }'
