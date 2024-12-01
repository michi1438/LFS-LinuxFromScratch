source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}COREUTILS-9.5 -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/coreutils-9.5/" ]; then

	tar -xf coreutils-9.5.tar.xz
	cd coreutils-9.5/


	./configure --prefix=/usr                      \
				--build=$(sh support/config.guess) \
				--host=$LFS_TGT                    \
				--without-bash-malloc              \
				bash_cv_strtold_broken=no

	make && make DESTDIR=$LFS install ;

	mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
	mkdir -pv $LFS/usr/share/man/man8
	mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
	sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

else
	printf "${RED}COREUTILS-9.5: The Coreutils have already been built if this is not true, or you need to rebuild it \
rm the coreutilsdir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}COREUTILS-9.5 -- END${NC}\n"
