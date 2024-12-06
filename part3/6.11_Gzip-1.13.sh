source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART3\//} -- START${NC}\n"
cd $LFS/sources/

PACKAGE="grep-3.11.tar.xz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${LFS}/sources/${PACKAGE//.tar.xz/}/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.xz/}/"

	./configure --prefix=/usr --host=$LFS_TGT

	make && make DESTDIR=$LFS install ;

else
	printf "${RED}${MSG_HEAD//PART3\//}: The ${PACKAGE//.tar.xz/} have already \
been built if this is not true, or you need to rebuild it \
rm the ${PACKAGE//.tar.xz/} in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}${MSG_HEAD//PART3\//} -- END${NC}\n"
