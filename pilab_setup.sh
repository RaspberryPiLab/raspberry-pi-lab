#!/bin/bash
# Installing updates
/usr/bin/apt-get update -y && /usr/bin/apt-get upgrade -y && /usr/bin/apt-get dist-upgrade -y
# install the locales tool
/usr/bin/apt install locales -y -q
# edit locale.gen file to remove en_GB.UTF-8 and activate en_US.UTF-8
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/en_GB.UTF-8 UTF-8/# en_GB.UTF-8 UTF-8/' /etc/locale.gen
# if this tool is run multiple times then make sure there are not multiple # # in front of en_GB.UTF-8 line
sed -i -e 's/# # en_GB.UTF-8 UTF-8/# en_GB.UTF-8 UTF-8/' /etc/locale.gen
# reconfigure locale using Debian system  tool
/usr/sbin/dpkg-reconfigure --frontend noninteractive locales
# set timezone to America/Chicago
echo "America/Chicago" > /etc/timezone
# reconfigure timezone using Debian system tool
dpkg-reconfigure -f noninteractive tzdata


# Installing utility to save configurations after reboot
/usr/bin/apt-get install iptables-persistent -y
# Editing sysctl.conf to enable routing
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
#######################
# Overview of command
#######################
#  iptables - The command-line utility for configuring the rules
#  -t nat - Configuration of NAT rules.
#  -A POSTROUTING - Append (-A) a rule to the POSTROUTING chain
#  -o wlan0 - The rules apply for packets that leave the Wi-Fi interface (-o stands for 'output')
#  -j MASQUERADE - The action that should take place is to 'masquerade' (NATing) the packets.
#########################
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

# Accept traffic from eth0
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
# Return traffic from internet
iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT 