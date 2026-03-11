#!/bin/bash
# Скрипт после установки/обновления
set -e

if [ -x "$(command -v gtk-update-icon-cache)" ]; then
    gtk-update-icon-cache -q -t -f /usr/share/icons/MoreWaita || true
fi

if [ -x "$(command -v gtk4-update-icon-cache)" ]; then
    gtk4-update-icon-cache -q -t -f /usr/share/icons/MoreWaita || true
fi

exit 0
