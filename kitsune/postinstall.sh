#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

# Компилируем GSettings-схемы
if command -v glib-compile-schemas &>/dev/null; then
    glib-compile-schemas /usr/share/glib-2.0/schemas 2>/dev/null || true
fi

# Компилируем Python байткод
if command -v python3 &>/dev/null; then
    python3 -m compileall -q /usr/share/kitsune 2>/dev/null || true
fi

# Обновляем кэш иконок
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

# Обновляем desktop базу данных
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

exit 0
