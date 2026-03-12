#!/bin/bash
#
# Тестирование установки пакета в Docker
# Использование: ./test-install.sh <package_name>
#
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Путь к локальному stplr
STPLR_PATH="$(which stplr 2>/dev/null || echo "")"
if [[ -z "$STPLR_PATH" ]]; then
    echo -e "${RED}Ошибка: stplr не найден в системе${NC}"
    exit 1
fi

PKG="${1:-}"

if [[ -z "$PKG" ]]; then
    echo "Использование: $0 <package_name>"
    echo "Доступные пакеты:"
    for dir in "$REPO_ROOT"/*/; do
        [[ -f "$dir/Staplerfile" ]] && echo "  - $(basename "$dir")"
    done
    exit 1
fi

PKG_DIR="$REPO_ROOT/$PKG"

if [[ ! -f "$PKG_DIR/Staplerfile" ]]; then
    echo -e "${RED}Ошибка: Staplerfile не найден в $PKG${NC}"
    exit 1
fi

echo -e "${CYAN}======================================${NC}"
echo -e "${CYAN}  Тестирование установки: $PKG${NC}"
echo -e "${CYAN}======================================${NC}"

# Извлекаем зависимости для ALT Linux из Staplerfile
get_deps() {
    grep -E "^deps_altlinux=" "$PKG_DIR/Staplerfile" | \
        sed "s/deps_altlinux=(//" | \
        sed "s/)$//" | \
        tr -d "'" | \
        tr -d '"' | \
        tr ' ' '\n' | \
        grep -v '^$'
}

DEPS=$(get_deps | tr '\n' ' ')
echo -e "${YELLOW}Зависимости:${NC} $DEPS"
echo -e "${YELLOW}stplr:${NC} $STPLR_PATH"
echo ""

# Запуск теста через docker run с монтированием локального stplr
echo -e "${YELLOW}Запуск сборки в Docker...${NC}"
echo ""

docker run --rm \
    -v "$STPLR_PATH:/usr/local/bin/stplr:ro" \
    -v "$PKG_DIR:/build:ro" \
    -w /build \
    alt:p11 \
    bash -c "
        set -e
        echo '=== Установка базовых зависимостей ==='
        apt-get update -qq
        apt-get install -y -qq cpio tar gzip xz >/dev/null 2>&1
        
        if [[ -n '$DEPS' ]]; then
            echo '=== Установка зависимостей пакета ==='
            apt-get install -y $DEPS 2>&1 || echo 'Некоторые зависимости недоступны'
        fi
        
        echo ''
        echo '=== Сборка пакета ==='
        /usr/local/bin/stplr build -c
        
        echo ''
        echo '=== BUILD SUCCESS ==='
    " && {
    echo ""
    echo -e "${GREEN}✓ Пакет $PKG успешно собран!${NC}"
    exit 0
} || {
    echo ""
    echo -e "${RED}✗ Ошибка сборки пакета $PKG${NC}"
    exit 1
}
