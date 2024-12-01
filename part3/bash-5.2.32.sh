source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}BASH-5.2.32.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/bash-5.2.32/" ]; then

	tar -xf bash-5.2.32.tar.gz
	cd bash-5.2.32/

	./configure --prefix=/usr                      \
				--build=$(sh support/config.guess) \
				--host=$LFS_TGT                    \
				--without-bash-malloc              \
				bash_cv_strtold_broken=no

	make && make DESTDIR=$LFS install ;
	ln -sv bash ${LFS}bin/sh
else
	printf "${RED}BASH-5.2.32.SH: The bash have already been built if this is not true, or you need to rebuild it \
rm the bash dir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}BASH-5.2.32.SH -- END${NC}\n"
