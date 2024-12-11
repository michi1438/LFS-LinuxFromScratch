#!/bin/bash
source .env #Sourcing .env for Shell and subShells variable...

function finish {
	echo
	printf "${RED}${msg_head//PART3\//} something has failed and the \
the script has been interupted...${NC}\n"
}
trap finish ERR

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

msg_head=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${msg_head//PART3\//} -- START${NC}\n"
pushd "${LFS}/sources/"
	package="gcc-14.2.0.tar.xz"
	if [ ! -d "${package//.tar.xz/}/" ]; then
		tar --extract --file $package
			pushd "${package//.tar.xz/}/"
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
				(
					cd "build/"
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
				)
				cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
				  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h 
			popd	
	else
		printf "${RED}${msg_head//PART3\//}: ${package//.tar.xz/}/ has already \
been built if this is not true, or you need to rebuild it \
rm the ${package//.tar.xz/}/ dir in $LFS/sources and run anew...${NC}\n"
		printf "${GREEN}${msg_head//PART3\//} -- END${NC}\n"
		exit 0;
	fi
popd

printf "${GREEN}${msg_head//PART3\//} -- END${NC}\n"
exit 0;
