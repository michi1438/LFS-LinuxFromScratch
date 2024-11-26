
source .env #Sourcing .env for Shell and subShells variable...

printf "${GREEN}GCC_PASS_1.SH -- START${NC}\n"
cd $LFS/sources/

if [ ! -d "${LFS}/sources/gcc-14.2.0/" ]; then

	tar -xf gcc-14.2.0.tar.xz
----


else
	printf "${RED}GCC_PASS_1.SH: Binutils has already been built if this is not true, or you need to rebuild it \
rm the binutils dir in $LFS/sources and run anew...${NC}\n"
fi

printf "${GREEN}GCC_PASS_1.SH -- END${NC}\n"
