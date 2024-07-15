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

# Fungsi untuk mendeteksi sistem operasi
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        OS=$(uname -s)
        VERSION=$(uname -r)
    fi
    echo "Sistem Operasi Terdeteksi: $OS $VERSION"
}

# Fungsi untuk mendeteksi antarmuka jaringan utama
detect_network_interface() {
    interface=$(ip -o -4 route show to default | awk '{print $5}' | head -n1)
    echo $interface
}

# Periksa hak akses root
if [ "$(id -u)" != "0" ]; then
   echo "Skrip ini harus dijalankan sebagai root" 1>&2
   exit 1
fi

# Deteksi OS dan antarmuka jaringan
detect_os
NET=$(detect_network_interface)

# ===================
clear
# // Exporint IP AddressInformation
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
    echo -e "${OK} Arsitektur Anda Didukung ( ${green}$( uname -m )${NC} )"
else
    echo -e "${EROR} Arsitektur Anda Tidak Didukung ( ${YELLOW}$( uname -m )${NC} )"
    exit 1
fi

# // Checking System
if [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "ubuntu" ]]; then
    echo -e "${OK} Sistem Operasi Anda Didukung ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
elif [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "debian" ]]; then
    echo -e "${OK} Sistem Operasi Anda Didukung ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
else
    echo -e "${EROR} Sistem Operasi Anda Tidak Didukung ( ${YELLOW}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
    exit 1
fi

# // IP Address Validating
if [[ $IP == "" ]]; then
    echo -e "${EROR} IP Address ( ${YELLOW}Not Detected${NC} )"
else
    echo -e "${OK} IP Address ( ${green}$IP${NC} )"
fi

# // Validate Successfull
echo ""
read -p "$( echo -e "Tekan ${GRAY}[ ${NC}${green}Enter${NC} ${GRAY}]${NC} untuk memulai instalasi") "
echo ""
clear

# Fungsi first_setup
first_setup(){
    timedatectl set-timezone Asia/Jakarta
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    print_success "Pengaturan Awal"
    
    # Setup dependensi
    apt-get update
    apt-get install -y software-properties-common
    
    if [ "$OS" = "ubuntu" ]; then
        add-apt-repository ppa:vbernat/haproxy-2.0 -y
        apt-get update
        apt-get -y install haproxy=2.0.\*
    elif [ "$OS" = "debian" ]; then
        echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/buster-backports.list
        apt-get update
        apt-get -t buster-backports install -y haproxy
    else
        echo "OS tidak didukung"
        exit 1
    fi
}

# Fungsi nginx_install
nginx_install() {
    print_install "Nginx"
    apt-get install -y nginx
    print_success "Nginx"
}

# Sisanya dari fungsi-fungsi Anda tetap sama
# ...

# Fungsi utama instalasi
instal(){
    clear
    first_setup
    nginx_install
    base_package
    make_folder_xray
    pasang_domain
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

# Jalankan fungsi utama
instal

echo ""
history -c
rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
rm -rf /root/domain
echo -e "${green} Skrip Berhasil Diinstal"
echo ""
read -p "$( echo -e "Tekan ${YELLOW}[ ${NC}${YELLOW}Enter${NC} ${YELLOW}]${NC} untuk reboot") "
reboot