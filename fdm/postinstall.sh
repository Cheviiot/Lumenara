#!/bin/bash
# Скрипт после установки/обновления
# Запускается как root

# Устанавливаем права на исполнение
chmod +x /opt/freedownloadmanager/fdm 2>/dev/null || true
chmod +x /opt/freedownloadmanager/wenativehost 2>/dev/null || true

# --- Обёртка wenativehost для ALT Linux (pam_mktemp + firejail) ---
# Браузеры в firejail не видят pam_mktemp overlay (/tmp → /tmp/.private/$USER/).
# FDM создаёт сокет в /tmp/.private/$USER/fdm6fs<UID>, а wenativehost внутри
# firejail ищет /tmp/fdm6fs<UID>. Выставляем TMPDIR, чтобы Qt нашёл сокет.
REAL_BIN="/opt/freedownloadmanager/wenativehost"
if [ -f "$REAL_BIN" ] && file "$REAL_BIN" | grep -q "ELF"; then
    mv -f "$REAL_BIN" "${REAL_BIN}.bin"
    cat > "$REAL_BIN" << 'WRAPPER'
#!/bin/sh
PRIVATE_TMP="/tmp/.private/$(id -un)"
if [ -d "$PRIVATE_TMP" ]; then
    export TMPDIR="$PRIVATE_TMP"
fi
exec /opt/freedownloadmanager/wenativehost.bin "$@"
WRAPPER
    chmod +x "$REAL_BIN"
fi

# Обновляем desktop базу данных
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

# Регистрируем FDM как обработчик magnet-ссылок и .torrent по умолчанию
MIMEAPPS="/usr/share/applications/mimeapps.list"
for mime in x-scheme-handler/magnet application/x-bittorrent; do
    if [ -f "$MIMEAPPS" ] && grep -q "^${mime}=" "$MIMEAPPS"; then
        sed -i "s|^${mime}=.*|${mime}=freedownloadmanager.desktop|" "$MIMEAPPS"
    else
        if [ ! -f "$MIMEAPPS" ] || ! grep -q '^\[Default Applications\]' "$MIMEAPPS"; then
            printf '%s\n' '[Default Applications]' >> "$MIMEAPPS"
        fi
        sed -i "/^\[Default Applications\]/a ${mime}=freedownloadmanager.desktop" "$MIMEAPPS"
    fi
done

# Обновляем кэш иконок
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q /usr/share/icons/hicolor 2>/dev/null || true
fi

# --- Native Messaging Host для браузерной интеграции ---

NATIVE_HOST_NAME="org.freedownloadmanager.fdm5.cnh"
HOST_PATH="/opt/freedownloadmanager/wenativehost"

# Chrome/Chromium-манифест
CHROME_MANIFEST='{
  "name": "'"$NATIVE_HOST_NAME"'",
  "description": "Free Download Manager browser integration",
  "path": "'"$HOST_PATH"'",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://ahmpjcflkgiildlgicmcieglgoilbfdp/",
    "chrome-extension://mdfcjfioplkdchnhcpcobaheocanedjg/"
  ]
}'

# Firefox-манифест
FIREFOX_MANIFEST='{
  "name": "'"$NATIVE_HOST_NAME"'",
  "description": "Free Download Manager browser integration",
  "path": "'"$HOST_PATH"'",
  "type": "stdio",
  "allowed_extensions": [
    "fdm_ffext@freedownloadmanager.org",
    "fdm_ffext2@freedownloadmanager.org"
  ]
}'

MANIFEST_FILE="${NATIVE_HOST_NAME}.json"

# Системные каталоги Chrome/Chromium
for dir in \
    /etc/chromium/native-messaging-hosts \
    /etc/opt/chrome/native-messaging-hosts; do
    mkdir -p "$dir" 2>/dev/null || true
    echo "$CHROME_MANIFEST" > "${dir}/${MANIFEST_FILE}"
done

# Системный каталог Firefox
mkdir -p /usr/lib/mozilla/native-messaging-hosts 2>/dev/null || true
echo "$FIREFOX_MANIFEST" > "/usr/lib/mozilla/native-messaging-hosts/${MANIFEST_FILE}"

# Пользовательские каталоги для каждого пользователя с домашним каталогом
for user_home in /home/*; do
    [ -d "$user_home" ] || continue
    user_name=$(basename "$user_home")

    # Chrome-based браузеры (пользовательские)
    for subdir in \
        ".config/google-chrome/NativeMessagingHosts" \
        ".config/chromium/NativeMessagingHosts" \
        ".config/BraveSoftware/Brave-Browser/NativeMessagingHosts" \
        ".config/yandex-browser/NativeMessagingHosts" \
        ".config/yandex-browser-beta/NativeMessagingHosts" \
        ".config/vivaldi/NativeMessagingHosts" \
        ".config/microsoft-edge/NativeMessagingHosts"; do
        target_dir="${user_home}/${subdir}"
        # Ставим только если каталог браузера существует
        browser_dir=$(dirname "$target_dir")
        if [ -d "$browser_dir" ]; then
            mkdir -p "$target_dir" 2>/dev/null || true
            echo "$CHROME_MANIFEST" > "${target_dir}/${MANIFEST_FILE}"
            chown "${user_name}:${user_name}" "${target_dir}/${MANIFEST_FILE}" 2>/dev/null || true
        fi
    done

    # Firefox (пользовательский)
    if [ -d "${user_home}/.mozilla" ]; then
        target_dir="${user_home}/.mozilla/native-messaging-hosts"
        mkdir -p "$target_dir" 2>/dev/null || true
        echo "$FIREFOX_MANIFEST" > "${target_dir}/${MANIFEST_FILE}"
        chown "${user_name}:${user_name}" "${target_dir}/${MANIFEST_FILE}" 2>/dev/null || true
    fi
done

exit 0
