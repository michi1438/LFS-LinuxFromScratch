source .env #Sourcing .env for Shell and subShells variable...

MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${MSG_HEAD//PART3\//} -- START${NC}\n"
cd $LFS/sources/

PACKAGE="file-5.45.tar.gz"
MSG_HEAD=$(echo $0 | awk '{ print toupper($0) }')

if [ ! -d "${LFS}/sources/${PACKAGE//.tar.gz/}/" ]; then

	tar -xf $PACKAGE
	cd "${PACKAGE//.tar.gz/}/"

	mkdir build
	pushd build
	  ../configure --disable-bzlib      \
				   --disable-libseccomp \
				   --disable-xzlib      \
				   --disable-zlib
	  make
	popd
	./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
	make FILE_COMPILE=$(pwd)/build/src/file && make DESTDIR=$LFS install ;
	
	rm -v $LFS/usr/lib/libmagic.la

else
	printf "${RED}${MSG_HEAD//PART3\//}: The ${PACKAGE//.tar.xz/} have already \
been built if this is not true, or you need to rebuild it \
rm the ${PACKAGE//.tar.xz/} in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}${MSG_HEAD//PART3\//} -- END${NC}\n"
