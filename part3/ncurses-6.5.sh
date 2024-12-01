source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}NCURSES-6.5.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/ncurses-6.5/" ]; then

	tar -xf ncurses-6.5.tar.gz
	cd ncurses-6.5/
	
	sed -i s/mawk// configure

	mkdir build
	pushd build
	  ../configure
	  make -C include
	  make -C progs tic
	popd

	./configure --prefix=/usr                \
				--host=$LFS_TGT              \
				--build=$(./config.guess)    \
				--mandir=/usr/share/man      \
				--with-manpage-format=normal \
				--with-shared                \
				--without-normal             \
				--with-cxx-shared            \
				--without-debug              \
				--without-ada                \
				--disable-stripping

	make
	make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
	ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
		-i $LFS/usr/include/curses.h

else
	printf "${RED}NCURSES-6.5.SH: The ncurses have already been built if this is not true, or you need to rebuild it \
rm the ncurses dir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}NCURSES-6.5.SH -- END${NC}\n"
