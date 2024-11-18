#!/bin/bash

# Определите параметры
INTERFACE="enp0s3"
IP_ADDRESS="192.168.3.82/24"
GATEWAY="192.168.3.1"
DNS_SERVERS=("8.8.8.8" "8.8.4.4")

# Настройка статического IP через Netplan
cat <<EOL | sudo tee /etc/netplan/50-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses:
        - $IP_ADDRESS
      routes:
        - to: 0.0.0.0/0
          via: $GATEWAY
      nameservers:
        addresses:
          - ${DNS_SERVERS[0]}
          - ${DNS_SERVERS[1]}
EOL

# Применить настройки
sudo netplan --debug apply

# Вывести текущие настройки сети
echo "Текущие настройки сети:"
ip a