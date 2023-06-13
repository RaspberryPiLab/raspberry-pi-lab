#!/bin/bash
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
