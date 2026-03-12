#!/bin/bash
#
# Тестирование сборки всех пакетов Lumenara в Docker
#
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Путь к локальному stplr
STPLR_PATH="$(which stplr 2>/dev/null || echo "")"
if [[ -z "$STPLR_PATH" ]]; then
    echo -e "${RED}Ошибка: stplr не найден в системе${NC}"
    exit 1
fi

# Список пакетов
PACKAGES=(adwyra anidesk aya github-plus happ morewaita winboat winegui)

# Результаты тестирования
declare -A RESULTS

log_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Подготовка базового образа (проверка наличия alt:p11)
prepare_image() {
    log_info "Проверка Docker образа alt:p11..."
    if ! docker image inspect alt:p11 >/dev/null 2>&1; then
        log_info "Загрузка образа alt:p11..."
        docker pull alt:p11
    fi
}

# Тестирование одного пакета
test_package() {
    local pkg="$1"
    local pkg_dir="$REPO_ROOT/$pkg"
    
    if [[ ! -d "$pkg_dir" ]]; then
        log_error "Папка $pkg не найдена"
        RESULTS[$pkg]="NOT_FOUND"
        return 1
    fi
    
    if [[ ! -f "$pkg_dir/Staplerfile" ]]; then
        log_error "Staplerfile не найден в $pkg"
        RESULTS[$pkg]="NO_STAPLERFILE"
        return 1
    fi
    
    log_info "Тестирование пакета: $pkg"
    
    # Запуск сборки в Docker с монтированием локального stplr
    if docker run --rm \
        -v "$STPLR_PATH:/usr/local/bin/stplr:ro" \
        -v "$pkg_dir:/build:ro" \
        -w /build \
        alt:p11 \
        bash -c "
            apt-get update -qq >/dev/null 2>&1
            apt-get install -y -qq cpio tar gzip xz >/dev/null 2>&1
            /usr/local/bin/stplr build -c 2>&1
        " 2>&1 | tee "/tmp/lumenara-test-$pkg.log"; then
        log_success "$pkg: сборка успешна"
        RESULTS[$pkg]="OK"
        return 0
    else
        log_error "$pkg: ошибка сборки (см. /tmp/lumenara-test-$pkg.log)"
        RESULTS[$pkg]="FAILED"
        return 1
    fi
}

# Вывод итогов
print_summary() {
    echo ""
    echo "=========================================="
    echo "           ИТОГИ ТЕСТИРОВАНИЯ            "
    echo "=========================================="
    
    local passed=0
    local failed=0
    
    for pkg in "${PACKAGES[@]}"; do
        local status="${RESULTS[$pkg]:-SKIPPED}"
        case "$status" in
            OK)
                echo -e "${GREEN}✓${NC} $pkg"
                ((passed++))
                ;;
            FAILED)
                echo -e "${RED}✗${NC} $pkg - ошибка сборки"
                ((failed++))
                ;;
            NOT_FOUND)
                echo -e "${YELLOW}?${NC} $pkg - папка не найдена"
                ((failed++))
                ;;
            NO_STAPLERFILE)
                echo -e "${YELLOW}?${NC} $pkg - нет Staplerfile"
                ((failed++))
                ;;
            *)
                echo -e "${YELLOW}-${NC} $pkg - пропущен"
                ;;
        esac
    done
    
    echo "=========================================="
    echo "Успешно: $passed / ${#PACKAGES[@]}"
    echo "Ошибок:  $failed"
    echo "=========================================="
    
    [[ $failed -eq 0 ]]
}

# Основная логика
main() {
    local target_pkg="${1:-all}"
    
    # Проверка образа
    prepare_image
    
    if [[ "$target_pkg" == "all" ]]; then
        # Тестирование всех пакетов
        for pkg in "${PACKAGES[@]}"; do
            test_package "$pkg" || true
        done
    else
        # Тестирование конкретного пакета
        test_package "$target_pkg"
    fi
    
    print_summary
}

main "$@"
