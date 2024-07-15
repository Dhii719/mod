#!/bin/bash
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'

# Determine OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
elif [ -f /etc/centos-release ]; then
    OS=centos
else
    echo "Unsupported OS"
    exit 1
fi

# Set package manager and commands based on OS
case $OS in
    ubuntu|debian)
        PKG_MANAGER="apt"
        UPDATE_CMD="apt update"
        INSTALL_CMD="apt install -y"
        ;;
    centos)
        PKG_MANAGER="yum"
        UPDATE_CMD="yum update -y"
        INSTALL_CMD="yum install -y"
        # Enable EPEL repository
        $INSTALL_CMD epel-release
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# ===================
clear
# // Exporting IP Address Information
export IP=$(curl -sS icanhazip.com)

# // Clear Data
clear
clear && clear && clear
clear;clear;clear

# // Banner
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "  Auther : ${green}VPN - XPRESS® ${NC}${YELLOW}(${NC} ${green} XPRESS ${NC}${YELLOW})${NC}"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
sleep 2

# // Checking Os Architecture
if [[ $( uname -m | awk '{print $1}' ) == "x86_64" ]]; then
    echo -e "${OK} Your Architecture Is Supported ( ${green}$( uname -m )${NC} )"
else
    echo -e "${EROR} Your Architecture Is Not Supported ( ${YELLOW}$( uname -m )${NC} )"
    exit 1
fi

# // Checking System
echo -e "${OK} Your OS Is Supported ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"

# // IP Address Validating
if [[ $IP == "" ]]; then
    echo -e "${EROR} IP Address ( ${YELLOW}Not Detected${NC} )"
else
    echo -e "${OK} IP Address ( ${green}$IP${NC} )"
fi

# // Validate Successfull
echo ""
read -p "$( echo -e "Press ${GRAY}[ ${NC}${green}Enter${NC} ${GRAY}]${NC} For Starting Installation") "
echo ""
clear

# Check if running as root
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    exit 1
fi

# Check if OpenVZ
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    exit 1
fi

# IZIN SCRIPT
MYIP=$(curl -sS ipv4.icanhazip.com)
echo -e "\e[32mloading...\e[0m"
clear

# Install required packages
$INSTALL_CMD ruby -y
gem install lolcat
$INSTALL_CMD wondershaper -y

clear
# REPO
REPO="https://raw.githubusercontent.com/Dhii719/v3/main/"

# ... (rest of the script remains mostly the same)

# Function definitions with OS-specific modifications

function base_package() {
    clear
    print_install "Menginstall Paket Yang Dibutuhkan"
    case $OS in
        ubuntu|debian)
            $INSTALL_CMD zip pwgen openssl netcat socat cron bash-completion figlet
            ;;
        centos)
            $INSTALL_CMD zip pwgen openssl nc socat cronie bash-completion figlet
            ;;
    esac
    
    $UPDATE_CMD
    $INSTALL_CMD curl jq wget
    
    case $OS in
        ubuntu|debian)
            $INSTALL_CMD gnupg gnupg2 chrony
            ;;
        centos)
            $INSTALL_CMD gnupg2 chrony
            ;;
    esac
    
    systemctl enable chronyd
    systemctl restart chronyd
}

function nginx_install() {
    case $OS in
        ubuntu|debian)
            $INSTALL_CMD nginx
            ;;
        centos)
            $INSTALL_CMD epel-release
            $INSTALL_CMD nginx
            ;;
    esac
    
    systemctl enable nginx
    systemctl start nginx
}

function install_xray() {
    clear
    print_install "Core Xray 1.8.1 Latest Version"
    domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir $domainSock_dir
    chown www-data.www-data $domainSock_dir
    
    latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    
    case $OS in
        ubuntu|debian)
            bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
            ;;
        centos)
            bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --version $latest_version
            ;;
    esac

    # Continue with Xray configuration...
}

function ssh(){
    clear
    print_install "Memasang Password SSH"
    
    case $OS in
        ubuntu|debian)
            wget -O /etc/pam.d/common-password "${REPO}files/password"
            chmod +x /etc/pam.d/common-password
            ;;
        centos)
            # CentOS uses /etc/pam.d/system-auth
            sed -i 's/password    requisite     pam_pwquality.so try_first_pass local_users_only/password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 minlen=8/' /etc/pam.d/system-auth
            ;;
    esac

    # Continue with SSH configuration...
}

function ins_dropbear(){
    clear
    print_install "Menginstall Dropbear"
    
    case $OS in
        ubuntu|debian)
            $INSTALL_CMD dropbear
            ;;
        centos)
            $INSTALL_CMD dropbear
            ;;
    esac
    
    wget -q -O /etc/default/dropbear "${REPO}config/dropbear.conf"
    chmod +x /etc/default/dropbear
    systemctl restart dropbear
    systemctl enable dropbear
}

# ... (continue modifying other functions similarly)

# Main installation function
function instal(){
    clear
    first_setup
    nginx_install
    base_package
    make_folder_xray
    pasang_domain
    password_default
    pasang_ssl
    install_xray
    ssh
    udp_mini
    ssh_slow
    ins_SSHD
    ins_dropbear
    ins_vnstat
    ins_openvpn
    ins_backup
    ins_swab
    ins_Fail2ban
    ins_epro
    ins_restart
    menu
    profile
    enable_services
    restart_system
}

# Run installation
instal

echo ""
history -c
rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
rm -rf /root/domain
secs_to_human "$(($(date +%s) - ${start}))"
echo -e "${green} Script Successfull Installed"
echo ""
read -p "$( echo -e "Press ${YELLOW}[ ${NC}${YELLOW}Enter${NC} ${YELLOW}]${NC} For reboot") "
reboot