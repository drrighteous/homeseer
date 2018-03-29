#!/bin/sh
trap exit 0 SIGTERM
export LANG=en_US.UTF-8

if [ -z "$TZ" ]; then
   echo $TZ > /etc/timezone
   dpkg-reconfigure -f noninteractive tzdata
fi

# Get current version
[ -f /opt/homeseer/version.txt ] && VERSION=$(cat /opt/homeseer/version.txt)

# Get remote version
#HS_URL=$(curl -sL https://homeseer.com/current-downloads.html | grep -Po 'https://homeseer.com/updates3/hs3_linux_3[0-9_.]+.tar.gz')

# Force specific BETA version
HS_URL='https://homeseer.com/updates3/hs3_linux_3_0_0_423.tar.gz'

# Download and untar if versions are not the same
 if [ "$VERSION" != "$HS_URL" ]; then
  echo "Downloading $HS_URL ..."
  mkdir -p /data/HomeSeer && ln -s /opt/homeseer /usr/local/homeseer
  wget -qO - "${HS_URL}" | tar -C /opt/homeseer -zx --strip-components 1
  echo "$HS_URL" > /opt/homeseer/version.txt
fi


chown -R root:root /opt/homeseer

# bug fix for case sensitive filesystems
# without this myhs.homeseer.com wont load icons
ln -sf /opt/homeseer/html/images/homeseer /opt/homeseer/html/images/HomeSeer

# Execute
cd /opt/homeseer && exec mono HSConsole.exe --log
