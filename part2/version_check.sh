#! bin/bash
#version-check.sh

source .env #Sourcing .env for Shell and subShells variable...
printf "${GREEN}VERSION_CHECK.SH -- START${NC}\n"
LC_ALL=C
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/michael/.local/bin/

bail() { echo "Fatal: $1"; exit 1; }
grep --version > /dev/null 2> /dev/null || bail "grep does not work"
sed '' /dev/null || bail "sed does not work"
sort  /dev/null || bail "sort does not work"

ver_check()
{
	if ! type -p $2 &>/dev/null
	then 
		echo "Error: Cannot find $2 ($1)"; return 1;
	fi
	v=$($2 --version 2>&1 | grep -E -o '[0-9]+\.[0-9\.]+[a-z]*' | head -n1)
	if printf '%s\n' $3 $v | sort --version-sort --check &>/dev/null 
	then
		printf "Ok:		%-9s %-6s >= $3\n" "$1" "$v"; return 0;
	else
		printf "Error:	%-9s is TOO OLD ($3 or later required)\n"; exit;
	fi
}

ver_kernel()
{
	kver=$(uname -r | grep -E -o '^[0-9\.]+')
	if printf '%s\n' $1 $kver | sort --version-sort --check &>/dev/null
	then
		printf "Ok:		Linux Kernel $kver >= $1\n"; return 0;
	else
		printf "Error:		Linux Kernel ($kver) is TOO OLD ($1 or later required)\n"; exit;
	fi
}

# Coreutils first because --version-sort needs Coreutils >= 7.0
echo "Binary Version check:"
ver_check Coreutils      sort     8.1 || bail "Coreutils too old, stop"
ver_check Bash           bash     3.2
ver_check Binutils       ld       2.13.1
ver_check Bison          bison    2.7
ver_check Diffutils      diff     2.8.1
ver_check Findutils      find     4.2.31
ver_check Gawk           gawk     4.0.1
ver_check GCC            gcc      5.2
ver_check "GCC (C++)"    g++      5.2
ver_check Grep           grep     2.5.1a
ver_check Gzip           gzip     1.3.12
ver_check M4             m4       1.4.10
ver_check Make           make     4.0
ver_check Patch          patch    2.5.4
ver_check Perl           perl     5.8.8
ver_check Python         python3  3.4
ver_check Sed            sed      4.1.5
ver_check Tar            tar      1.22
ver_check Texinfo        texi2any 5.0
ver_check Xz             xz       5.0.0
ver_kernel 4.19

if mount | grep -q 'devpts on /dev/pts' && [ -e /dev/ptmx ]
then echo "Ok:		Linux Kernel supports Unix 98 PTY";
else echo "Error:	Linux Kernel does not support Unix 98 PTY"; exit; fi

alias_check()
{
	if $1 --version 2>&1 | grep -qi $2
	then printf "Ok:		%-4s is $2\n" "$1";
	else printf "Error:	%-4s is NOT $2\n" "$1"; exit; fi
}

echo "Aliases check:"
alias_check awk GNU
alias_check yacc Bison
alias_check sh Bash

echo "Compiler check:"
if printf "int main(){}" | g++ -x c++ -
then echo "Ok:		g++ works";
else echo "Error:	g++ does not work"; exit; fi
rm -f a.out

echo "Logical cores check:"
if [ "$(nproc)" = "" ]; then
	echo "Error:	nproc is not available or it produces empty output"
	exit
else
	echo "Ok:		nproc reports $(nproc) logical cores available"
fi

printf "${GREEN}VERSION_CHECK.SH -- END${NC}\n\n"
