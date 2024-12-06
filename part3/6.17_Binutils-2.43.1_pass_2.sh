source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART3\//} -- START${NC}\n"
cd $LFS/sources/

PACKAGE="binutils-2.43.1.tar.xz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${LFS}/sources/${PACKAGE//.tar.xz/}/" ]; then

	printf "${RED}${MSG_HEAD//PART3\//}: The ${PACKAGE//.tar.xz/} dir \
has not been built yet, contrary to most package this is not normal as this \
is the 2nd pass of ${PACKAGE//.tar.xz/} in the $LFS/sources. Run anew...${NC}\n"


elif [ ! -d "${LFS}/sources/${PACKAGE//.tar.xz/}/build2/" ]; then

	cd "${PACKAGE//.tar.xz/}/"

	sed '6009s/$add_dir//' -i ltmain.sh

	mkdir -v build2
	cd       build #This is normal we only use build2 as a reference or flag.	

	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--enable-gprofng=no        \
		--disable-werror           \
		--enable-64-bit-bfd        \
		--enable-new-dtags         \
		--enable-default-hash-style=gnu

	make && make DESTDIR=$LFS install ;

	rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
	
else

	printf "${RED}${MSG_HEAD//PART3\//}: The ${PACKAGE//.tar.xz/}/build2/ has \
already been built if this is not true, or you need to rebuild it \
rm the ${PACKAGE//.tar.xz/}/build2/ dir in $LFS/sources and run anew...${NC}\n"

fi

printf "${GREEN}${MSG_HEAD//PART3\//} -- END${NC}\n"
