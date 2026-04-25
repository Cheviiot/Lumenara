#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

# 1) MIME: нужно для x-scheme-handler* из .desktop (OAuth из браузера)
if command -v update-mime-database &>/dev/null; then
    update-mime-database /usr/share/mime 2>/dev/null || true
fi

# 2) Кэш .desktop: регистрация обработчиков x-github-client, x-github-desktop-auth, …
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

# 3) hicolor: Icon=github-desktop-plus (иконки из .deb, имя не github-plus)
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

# 4) KDE: пересборка sycoca, иначе иконка/схемы иногда не подхватываются до перезахода
if command -v kbuildsycoca6 &>/dev/null; then
    kbuildsycoca6 --noincremental 2>/dev/null || true
elif command -v kbuildsycoca5 &>/dev/null; then
    kbuildsycoca5 --noincremental 2>/dev/null || true
fi

exit 0
