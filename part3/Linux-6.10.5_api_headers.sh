source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}LINUX-6.10.5_API_HEADERS.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/linux-6.10.5/" ]; then

	tar -xf linux-6.10.5.tar.xz
	cd linux-6.10.5/

	make mrproper

	make headers
	find usr/include -type f ! -name '*.h' -delete
	cp -rv usr/include $LFS/usr

else
	printf "${RED}LINUX-6.10.5_API_HEADERS.SH: The linux headers have already \
been built if this is not true, or you need to rebuild it \
rm the The linux headers have dir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}LINUX-6.10.5_API_HEADERS.SH -- END${NC}\n"
