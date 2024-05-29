#!/bin/bash

# Load the script
loading...

# Set the variables
USERNAME=$(curl https://raw.githubusercontent.com/Dhii719/izin/main/ip | grep $MYIP | awk '{print $2}')
EXP=$(curl https://raw.githubusercontent.com/Dhii719/izin/main/ip | grep $MYIP | awk '{print $3}')
DATE=$(date +'%Y-%m-%d')

# Function to check certificate status
datediff() {
  d1=$(date -d "$1" +%s)
  d2=$(date -d "$2" +%s)
  echo -e "Expiry In : $(( (d1 - d2) / 86400 )) Days"
}

# Check certificate status
if [[ $DATE < $EXP ]]; then
  sts="Active"
else
  sts="Expired"
fi

# Telegram notification
TEXT=" <code>────────────────────</code> <b>⚡AUTOSCRIPT PREMIUM⚡</b> <code>────────────────────</code> <code>User :</code><code>$USERNAME</code> <code>Domain :</code><code>$domain</code> <code>IPVPS :</code><code>$MYIP</code> <code>ISP :</code><code>$ISP</code> <code>Exp Sc. :</code><code>$exp</code> <code>────────────────────</code> <i>Automatic Notifications From Github</i> "
curl -s --max-time 10 -d "chat_id=324500970&disable_web_page_preview=1&text=$TEXT&parse_mode=html" https://api.telegram.org/bot6816227855:AAGq7RztcpTyEtVj05dfu4tKstqLVTQYvWg/sendMessage >/dev/null

# Install Xray
install_xray() {
  clear
  print_install "Core Xray 1.8.1 Latest Version"
  domainSock_dir="/run/xray"
  if [ ! -d $domainSock_dir ]; then
    mkdir $domainSock_dir
  fi
  chown www-data.www-data $domainSock_dir
  latest_version=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)
  bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
  wget -O /etc/xray/config.json "${REPO}config/config.json" >/dev/null 2>&1
  wget -O /etc/systemd/system/runn.service "${REPO}files/runn.service" >/dev/null 2>&1
  chmod +x /usr/local/bin/xray
  domain=$(cat /etc/xray/domain)
  IPVS=$(cat /etc/xray/ipvps)
  print_success "Core Xray 1.8.1 Latest Version"
}

# Install Dropbear
install_dropbear() {
  clear
  print_install "Menginstall Dropbear"
  apt-get install dropbear -y > /dev/null 2>&1
  wget -q -O /etc/default/dropbear "${REPO}config/dropbear" >/dev/null 2>&1
  chmod 700 /etc/default/dropbear
  /etc/init.d/dropbear restart
  systemctl restart dropbear
  /etc/init.d/dropbear status
  print_success "Dropbear"
}

# Install SlowDNS
install_slowdns() {
  clear
  print_install "Memasang modul SlowDNS Server"
  wget -q -O /tmp/nameserver "${REPO}files/nameserver" >/dev/null 2>&1
  chmod +x /tmp/nameserver
  bash /tmp/nameserver | tee /root/install.log
  print_success "SlowDNS"
}

# Install SSH
install_ssh() {
  clear
  print_install "Memasang SSHD"
  wget -q -O /etc/ssh/sshd_config "${REPO}files/sshd" >/dev/null 2>&1
  chmod 700 /etc/ssh/sshd_config
  /etc/init.d/ssh restart
  systemctl restart ssh
  /etc/init.d/ssh status
  print_success "SSHD"
}

# Install UDP Mini
install_udpmini() {
  clear
  print_install "Memasang Service Limit IP & Quota"
  wget -q https://raw.githubusercontent.com/Dhii719/mod/ku/config/fv-tunnel && chmod +x fv-tunnel && ./fv-tunnel
  mkdir -p /usr/local/kyt/
  wget -q -O /usr/local/kyt/udp-mini "${REPO}files/udp-mini" >/dev/null 2>&1
  chmod +x /usr/local/kyt/udp-mini
  wget -q -O /etc/systemd/system/udp-mini-1.service "${REPO}files/udp-mini-1.service" >/dev/null 2>&1
  wget -q -O /etc/systemd/system/udp-mini-2.service "${REPO}files/udp-mini-2.service" >/dev/null 2>&1
  wget -q -O /etc/systemd/system/udp-mini-3.service "${REPO}files/udp-mini-3.service" >/dev/null 2>&1
  systemctl disable udp-mini-1
  systemctl stop udp-mini-1
  systemctl enable udp-mini-1
  systemctl start udp-mini-1
  systemctl disable udp-mini-2
  systemctl stop udp-mini-2
  systemctl enable udp-mini-2
  systemctl start udp-mini-2
  systemctl disable udp-mini-3
  systemctl stop udp-mini-3
  systemctl enable udp-mini-3
  systemctl start udp-mini-3
  print_success "Limit IP Service"
}

# Install SSL
install_ssl() {
  clear
  print_install "Memasang SSL Pada Domain"
  rm -rf /etc/xray/xray.key
  rm -rf /etc/xray/xray.crt
  domain=$(cat /root/domain)
  STOPWEBSERVER=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
  rm -rf /root/.acme.sh
  mkdir /root/.acme.sh
  systemctl stop $STOPWEBSERVER
  systemctl stop nginx
  curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
  chmod +x /root/.acme.sh/acme.sh
  /root/.acme.sh/acme.sh --upgrade --auto-upgrade
  /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
  /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
  chmod 777 /etc/xray/xray.key
  print_success "SSL Certificate"
}

# Main function
main() {
  clear
  print_install "AUTOSCRIPT PREMIUM"
  install_xray
  install_dropbear
  install_slowdns
  install_ssh
  install_udpmini
  install_ssl
}

# Run the main function
main
