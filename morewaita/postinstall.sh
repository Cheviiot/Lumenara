#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

# Обновляем кэш иконок MoreWaita
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/MoreWaita 2>/dev/null || true
fi

if command -v gtk4-update-icon-cache &>/dev/null; then
    gtk4-update-icon-cache -f -q /usr/share/icons/MoreWaita 2>/dev/null || true
fi

exit 0
