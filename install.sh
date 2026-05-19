#!/usr/bin/env bash

# COLORS
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# installation paths
LMD_PATH="$HOME/.local/bin/linumd"
ALIAS_FILE="$HOME/.bashrc"

# show PC info
show_pc() {
    echo -e "${GREEN}=== PC INFO ===${NC}"
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo "Kernel: $(uname -r)"
    echo "OS: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/redhat-release 2>/dev/null || echo 'Unknown')"
    echo "CPU: $(lscpu | grep 'Model name' | head -1 | cut -d':' -f2 | xargs)"
    echo "RAM total: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "RAM used: $(free -h | awk '/^Mem:/ {print $3}')"
    echo "Disk used/total: $(df -h / | awk 'NR==2 {print $3"/"$2}')"
    echo "Disk usage %: $(df -h / | awk 'NR==2 {print $5}')"
}

# show IP info
show_ip() {
    echo -e "${GREEN}=== IP INFO ===${NC}"
    INTERNAL_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)
    if [ -z "$INTERNAL_IP" ]; then
        INTERNAl_IP="Not found"
    fi
    echo "Internal IP: $INTERNAL_IP"
    
    EXTERNAL_IP=$(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo "Not reachable")
    echo "External IP: $EXTERNAL_IP"
    
    GATEWAY=$(ip route | grep default | awk '{print $3}' | head -1)
    echo "Default gateway: ${GATEWAY:-Not found}"
    
    # DNS servers from systemd-resolve or /etc/resolv.conf
    DNS=$(grep -v '^#' /etc/resolv.conf | grep nameserver | awk '{print $2}' | head -2 | tr '\n' ' ')
    echo "DNS servers: ${DNS:-Not specified}"
}

# check internet via DNS
check_internet() {
    echo -e "${GREEN}=== INTERNET CHECK ===${NC}"
    echo -n "Pinging google.com... "
    if ping -c 1 -W 2 google.com &> /dev/null; then
        echo -e "${GREEN}OK${NC}"
        echo -e "${GREEN}✅ Internet is WORKING${NC}"
    else
        echo -e "${RED}FAILED${NC}"
        echo -n "Checking via curl... "
        if curl -s --max-time 3 http://httpbin.org/status/200 &> /dev/null; then
            echo -e "${GREEN}OK${NC}"
            echo -e "${GREEN}✅ Internet is WORKING (HTTP)${NC}"
        else
            echo -e "${RED}FAILED${NC}"
            echo -e "${RED}❌ No internet connection${NC}"
        fi
    fi
}

# update linumd itself
self_update() {
    echo -e "${GREEN}=== UPDATE LINUMD ===${NC}"
    echo "Run one of these commands to update:"
    echo ""
    echo -e "${YELLOW}# Universal (recommended):${NC}"
    echo "curl -sL https://ip4.icu/softs/linumd.sh -o ~/.local/bin/linumd && chmod +x ~/.local/bin/linumd"
    echo ""
    echo -e "${YELLOW}# Then reload alias:${NC}"
    echo "source ~/.bashrc"
    echo ""
    echo -e "${BLUE}Note: Your config/aliases will be preserved${NC}"
}

# uninstall linumd
uninstall_linumd() {
    echo -e "${RED}=== UNINSTALL LINUMD ===${NC}"
    echo -e "${YELLOW}This will remove:${NC}"
    echo "  - Script file: $LMD_PATH"
    echo "  - Alias 'lmd' from $ALIAS_FILE"
    echo ""
    echo -e "${RED}Are you sure? (type 'yes' to confirm)${NC}"
    read -r CONFIRM
    
    if [ "$CONFIRM" != "yes" ]; then
        echo -e "${GREEN}Uninstall cancelled.${NC}"
        return 0
    fi
    
    echo -n "Removing script file... "
    if [ -f "$LMD_PATH" ]; then
        rm -f "$LMD_PATH"
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${YELLOW}Not found${NC}"
    fi
    
    echo -n "Removing alias from bashrc... "
    if [ -f "$ALIAS_FILE" ]; then
        # remove line with 'alias lmd=' or 'alias linumd='
        sed -i '/alias lmd=/d' "$ALIAS_FILE"
        sed -i '/alias linumd=/d' "$ALIAS_FILE"
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${YELLOW}No bashrc found${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}✅ LINUMD has been removed from your system${NC}"
    echo -e "${YELLOW}Please run 'source ~/.bashrc' or restart your terminal${NC}"
}

# main
case "$1" in
    pc)
        show_pc
        ;;
    ip)
        show_ip
        ;;
    dns)
        check_internet
        ;;
    update)
        self_update
        ;;
    del)
        uninstall_linumd
        ;;
    --version|-v)
        echo "LINUMD v1.0.0"
        ;;
    help|--help|-h)
        echo "Usage: lmd {pc|ip|dns|update|del}"
        echo ""
        echo "Commands:"
        echo "  pc      - show PC hardware & OS info"
        echo "  ip      - show network IP info (internal, external, gateway, DNS)"
        echo "  dns     - check if internet works"
        echo "  update  - show how to update LINUMD"
        echo "  del     - uninstall LINUMD (asks for confirmation)"
        echo "  --version - show version"
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        echo "Usage: lmd {pc|ip|dns|update|del}"
        echo "Try 'lmd help' for more info"
        ;;
esac