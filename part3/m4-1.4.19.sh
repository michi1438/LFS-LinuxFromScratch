source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}M4-1.4.19.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/m4-1.4.19/" ]; then

	tar -xf m4-1.4.19.tar.xz 
	cd m4-1.4.19/

	./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

	make && make DESTDIR=$LFS install;

else
	printf "${RED}M4-1.4.19.SH: The linux headers have already been built if this is not true, or you need to rebuild it \
rm the The linux headers have dir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}M4-1.4.19.SH -- END${NC}\n"
