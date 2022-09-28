#!/bin/sh

#Xray版本
PORT=8080

VER=`wget -qO- "https://api.github.com/repos/XTLS/Xray-core/releases/latest" | sed -n -r -e 's/.*"tag_name".+?"([vV0-9\.]+?)".*/\1/p'`
mkdir /xraybin && cd /xraybin
XRAY_URL="https://github.com/XTLS/Xray-core/releases/download/${VER}/Xray-linux-64.zip"
wget --quiet --no-check-certificate ${XRAY_URL}
unzip -qq Xray-linux-64.zip
rm -f Xray-linux-64.zip
chmod +x ./xray

# caddy-configs
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt

#CADDYIndexPage-configs
wget --quiet $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
cat /Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
cat /config.json | sed -e "s/\$AUUID/$AUUID/g" >/xraybin/config.json
# 启动tor程序
tor &

# 启动xray程序
/xraybin/xray -config /xraybin/config.json &

# 启动caddy程序
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
