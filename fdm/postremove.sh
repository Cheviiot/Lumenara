#!/bin/bash
# Скрипт после удаления
# Запускается как root

# Обновляем desktop базу данных
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

# Обновляем кэш иконок
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

# --- Удаляем обёртку wenativehost ---
rm -f /opt/freedownloadmanager/wenativehost.bin 2>/dev/null || true

# --- Удаляем Native Messaging Host манифесты ---

MANIFEST_FILE="org.freedownloadmanager.fdm5.cnh.json"

# Системные
rm -f "/etc/chromium/native-messaging-hosts/${MANIFEST_FILE}" 2>/dev/null || true
rm -f "/etc/opt/chrome/native-messaging-hosts/${MANIFEST_FILE}" 2>/dev/null || true
rm -f "/usr/lib/mozilla/native-messaging-hosts/${MANIFEST_FILE}" 2>/dev/null || true

# Пользовательские
for user_home in /home/*; do
    [ -d "$user_home" ] || continue
    for subdir in \
        ".config/google-chrome/NativeMessagingHosts" \
        ".config/chromium/NativeMessagingHosts" \
        ".config/BraveSoftware/Brave-Browser/NativeMessagingHosts" \
        ".config/yandex-browser/NativeMessagingHosts" \
        ".config/yandex-browser-beta/NativeMessagingHosts" \
        ".config/vivaldi/NativeMessagingHosts" \
        ".config/microsoft-edge/NativeMessagingHosts"; do
        rm -f "${user_home}/${subdir}/${MANIFEST_FILE}" 2>/dev/null || true
    done
    rm -f "${user_home}/.mozilla/native-messaging-hosts/${MANIFEST_FILE}" 2>/dev/null || true
done

exit 0
