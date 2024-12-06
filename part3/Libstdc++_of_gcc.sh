source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}LIBSTDC++_OF_GCC.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/gcc-14.2.0/build2" ]; then

	cd gcc-14.2.0/

	mkdir -v build
	mkdir -v build2
	cd       build

	make distclean && rm ./config.cache ;

	../libstdc++-v3/configure           \
		--host=$LFS_TGT                 \
		--build=$(../config.guess)      \
		--prefix=/usr                   \
		--disable-multilib              \
		--disable-nls                   \
		--disable-libstdcxx-pch         \
		--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0

	make && make DESTDIR=$LFS install; 


	rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la

else
	printf "${RED}LIBSTDC++_OF_GCC.SH: LIBSTDC++ has already been built if this is not true, or you need to rebuild it \
rm the build2 in $LFS/sources/gcc-14.2.0/ and run anew...${NC}\n"
fi

printf "${GREEN}LIBSTDC++_OF_GCC.SH -- END${NC}\n"
