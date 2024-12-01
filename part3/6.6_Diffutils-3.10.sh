source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}DIFFUTILS-3.10.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/diffutils-3.10/" ]; then


	tar -xf diffutils-3.10.tar.xz
	cd diffutils-3.10/

	./configure --prefix=/usr   \
				--host=$LFS_TGT \
				--build=$(./build-aux/config.guess)

	make && make DESTDIR=$LFS install ;

else
	printf "${RED}DIFFUTILS-3.10.SH: The Coreutils have already been built if this is not true, or you need to rebuild it \
rm the coreutilsdir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}DIFFUTILS-3.10.SH -- END${NC}\n"
