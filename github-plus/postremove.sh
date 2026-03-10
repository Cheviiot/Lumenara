#!/bin/bash
# Скрипт после удаления
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

exit 0
