#!/bin/bash
source .env #Sourcing .env for Shell and subShells variable...

function finish {
	echo
	printf "${RED}${msg_head//PART4\//} something has failed and the \
the script has been interupted...${NC}\n"
}
trap finish ERR

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

msg_head=$(echo $0 | awk '{ print toupper($0) }')
printf "${GREEN}${msg_head//PART4\//} -- START${NC}\n"

rm --recursive --force /usr/share/{info,man,doc}/* || true
find /usr/{lib,libexec} -name \*.la -delete || true
rm -rf /tools || true


printf "${GREEN}${msg_head//PART4\//} -- END${NC}\n"
exit 0;
