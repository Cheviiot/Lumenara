#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root
set -e

if [ -x "$(command -v update-mime-database)" ]; then
    update-mime-database /usr/share/mime || true
fi

if [ -x "$(command -v update-desktop-database)" ]; then
    update-desktop-database -q /usr/share/applications || true
fi

if [ -x "$(command -v gtk-update-icon-cache)" ]; then
    gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
fi

chmod +x /opt/happ/bin/Happ 2>/dev/null || true
chmod +x /opt/happ/bin/happ-tcping 2>/dev/null || true
chmod +x /opt/happ/bin/happd 2>/dev/null || true
chmod +x /opt/happ/bin/core/xray 2>/dev/null || true
chmod +x /opt/happ/bin/tun/sing-box 2>/dev/null || true
chmod +x /opt/happ/bin/tun2/tun2proxy-bin 2>/dev/null || true
chmod +x /opt/happ/bin/tun2/udpgw-server 2>/dev/null || true
chmod +x /opt/happ/bin/antifilter/antifilter 2>/dev/null || true

if [ -x "$(command -v systemctl)" ]; then
    systemctl daemon-reload || true
    systemctl enable happd.service || true
    systemctl start happd.service || true
fi

exit 0
