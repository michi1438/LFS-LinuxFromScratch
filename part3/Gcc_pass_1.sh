
source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}GCC_PASS_1.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/gcc-14.2.0/" ]; then

	tar -xf gcc-14.2.0.tar.xz
	cd gcc-14.2.0/

	tar -xf ../mpfr-4.2.1.tar.xz
	mv -v mpfr-4.2.1/ mpfr
	tar -xf ../gmp-6.3.0.tar.xz
	mv -v gmp-6.3.0/ gmp
	tar -xf ../mpc-1.3.1.tar.gz
	mv -v mpc-1.3.1/ mpc

	case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

	mkdir -v build
	cd       build

../configure --target=$LFS_TGT --prefix=$LFS/tools	\
    --with-glibc-version=2.40 --with-sysroot=$LFS	\
    --with-newlib --without-headers					\
    --enable-default-pie --enable-default-ssp		\
    --disable-nls --disable-shared					\
    --disable-multilib --disable-threads			\
    --disable-libatomic --disable-libgomp			\
    --disable-libquadmath --disable-libssp			\
    --disable-libvtv --disable-libstdcxx			\
    --enable-languages=c,c++ && make && make install;

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h 

else
	printf "${RED}GCC_PASS_1.SH: Binutils has already been built if this is not true, or you need to rebuild it \
rm the binutils dir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}GCC_PASS_1.SH -- END${NC}\n"
