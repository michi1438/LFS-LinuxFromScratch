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

		printf "${RED}${msg_head//PART3\//}: The ${package//.tar.xz/} dir \
has not been built yet, contrary to most package this is not normal as this \
is the 2nd pass of ${package//.tar.xz/} in the $LFS/sources. Run anew...${NC}\n"
		exit 1;
	elif [ ! -d "${package//.tar.xz/}/build3/" ]; then

		pushd "${package//.tar.xz/}/"
			mv -v mpfr-4.2.1/ mpfr
			mv -v gmp-6.3.0/ gmp
			mv -v mpc-1.3.1/ mpc

			case $(uname -m) in
			x86_64)
				sed -e '/m64=/s/lib64/lib/' \
					-i.orig gcc/config/i386/t-linux64
				;;
			esac
			echo "This is normal does dir should've \
been move earlier in pass_1 of gcc"
			sed '/thread_header =/s/@.*@/gthr-posix.h/' \
				-i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

			mkdir -v build3
			rm -rf build/
			mkdir -v build
			
			pushd "build" #This is normal we only use build2 as a reference or flag.	
				make distclean && rm ./config.cache ;
				../configure                                       \
					--build=$(../config.guess)                     \
					--host=$LFS_TGT                                \
					--target=$LFS_TGT                              \
					LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
					--prefix=/usr                                  \
					--with-build-sysroot=$LFS                      \
					--enable-default-pie                           \
					--enable-default-ssp                           \
					--disable-nls                                  \
					--disable-multilib                             \
					--disable-libatomic                            \
					--disable-libgomp                              \
					--disable-libquadmath                          \
					--disable-libsanitizer                         \
					--disable-libssp                               \
					--disable-libvtv                               \
					--enable-languages=c,c++
				make && make DESTDIR=$LFS install ;
				ln -sv gcc $LFS/usr/bin/cc	
			popd
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
