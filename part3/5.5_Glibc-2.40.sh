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

package="glibc-2.40.tar.xz"
if [ ! -d "${package//.tar.xz/}/" ]; then
	tar --extract --file $package
		pushd "${package//.tar.xz/}/"
			case $(uname -m) in
				i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
				;;
				x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
						ln -sfv ../lib/ld-linux-x86-64.so.2 \
						$LFS/lib64/ld-lsb-x86-64.so.3
				;;
			esac
			
			patch -Np1 -i ../glibc-2.40-fhs-1.patch
			mkdir -v build/
			(
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
			)
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
