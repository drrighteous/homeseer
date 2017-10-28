#!/bin/sh
trap exit 0 SIGTERM
export LANG=en_US.UTF-8

if [ -z "$TZ" ]; then
   echo $TZ > /etc/timezone
   dpkg-reconfigure -f noninteractive tzdata
fi

# Get current version
[ -f /data/HomeSeer/version.txt ] && VERSION=$(cat /data/HomeSeer/version.txt)

# Get remote version
HS_URL=$(curl -sL http://homeseer.com/current-downloads.html | grep -Po 'http://homeseer.com/updates3/hs3_linux_3[0-9_.]+.tar.gz')

# Download and untar if versions are not the same
if [ "$VERSION" != "$HS_URL" ]; then
  echo "Downloading $HS_URL ..."
  mkdir -p /data/HomeSeer && ln -s /data/HomeSeer /usr/local/HomeSeer
  wget -qO - "${HS_URL}" | tar -C /data/HomeSeer -zx --strip-components 1
  echo "$HS_URL" > /data/HomeSeer/version.txt
fi

chown -R root:root /data

# bug fix for case sensitive filesystems
# without this myhs.homeseer.com wont load icons
ln -sf /data/HomeSeer/html/images/homeseer /data/HomeSeer/html/images/HomeSeer

# Execute
cd /data/HomeSeer && exec mono HSConsole.exe --log
