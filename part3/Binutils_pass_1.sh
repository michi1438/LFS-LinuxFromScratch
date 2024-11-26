
source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}BINUTILS_PASS_1.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/binutils-2.43.1/" ]; then

	tar -xf binutils-2.43.1.tar.xz
	cd binutils-2.43.1/


	mkdir -v build
	cd build
	time { ../configure --prefix=$LFS/tools --with-sysroot=$LFS				\
						--target=$LFS_TGT --disable-nls						\
						--enable-gprofng=no --disable-werror				\
						--enable-new-dtags --enable-default-hash-style=gnu	\
						&& make && make install; }
else
	printf "${RED}BINUTILS_PASS_1.SH: Binutils has already been built if this is not true, or you need to rebuild it \
rm the binutils dir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}BINUTILS_PASS_1.SH -- END${NC}\n"
