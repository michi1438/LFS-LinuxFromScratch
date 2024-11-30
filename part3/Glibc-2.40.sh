
source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}GLIBC-2.40.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/glibc-2.40/" ]; then

	tar -xf glibc-2.40.tar.xz
	cd glibc-2.40/

	case $(uname -m) in
		i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
		;;
		x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
				ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
		;;
	esac
	
	patch -Np1 -i ../glibc-2.40-fhs-1.patch

	mkdir -v build/
	cd build

	echo "rootsbindir=/usr/sbin" > configparms

	../configure                             \
		  --prefix=/usr                      \
		  --host=$LFS_TGT                    \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=4.19               \
		  --with-headers=$LFS/usr/include    \
		  --disable-nscd                     \
		  libc_cv_slibdir=/usr/lib

	make && make DESTDIR=$LFS install;
	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

else
	printf "${RED}GLIBC-2.40.SH The linux headers have already been built if this is not true, or you need to rebuild it \
rm the The Glibc-2.40 dir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}GLIBC-2.40.SH -- END${NC}\n"
