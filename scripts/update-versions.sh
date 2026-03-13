#!/bin/bash
# Скрипт автоматической проверки и обновления версий пакетов
# Проверяет GitHub releases и обновляет Staplerfile

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Конфигурация пакетов: имя_пакета -> owner/repo
declare -A PACKAGE_REPOS=(
    ["happ"]="Happ-proxy/happ-desktop"
    ["github-plus"]="pol-rivero/github-desktop-plus"
    ["aya"]="liriliri/aya"
    ["anidesk"]="theDesConnet/AniDesk"
    ["winboat"]="TibixDev/winboat"
    ["morewaita"]="somepaulo/MoreWaita"
    ["adwyra"]="cheviiot/adwyra"
)

# Специальные обработчики версий (для нестандартных форматов)
declare -A VERSION_TRANSFORMS=(
    # github-plus использует формат vX.Y.Z.N
    ["github-plus"]="strip_v"
    # anidesk использует формат v0.0.1-beta.6 -> 0.0.1.beta.6
    ["anidesk"]="beta_format"
)

# Флаги
DRY_RUN=false
VERBOSE=false
UPDATE_ALL=false
SPECIFIC_PACKAGE=""

usage() {
    cat << EOF
Использование: $(basename "$0") [опции] [пакет]

Проверяет и обновляет версии пакетов из GitHub releases.

Опции:
    -n, --dry-run     Только показать изменения, не применять
    -v, --verbose     Подробный вывод
    -a, --all         Обновить все пакеты (по умолчанию)
    -h, --help        Показать эту справку

Примеры:
    $(basename "$0")                    # Проверить все пакеты
    $(basename "$0") -n                 # Проверить без изменений
    $(basename "$0") happ               # Проверить только happ
    $(basename "$0") -v --all           # Обновить все с подробным выводом

EOF
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_verbose() {
    if $VERBOSE; then
        echo -e "${BLUE}[DEBUG]${NC} $*"
    fi
}

# Получить последнюю версию с GitHub
get_latest_version() {
    local repo="$1"
    local version
    local api_response
    
    # Используем GitHub API для получения последнего релиза
    api_response=$(curl -sL \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/$repo/releases/latest" \
        2>/dev/null)
    
    version=$(echo "$api_response" | jq -r '.tag_name // empty' 2>/dev/null)
    
    # Если releases пусто, пробуем tags
    if [[ -z "$version" ]]; then
        api_response=$(curl -sL \
            -H "Accept: application/vnd.github+json" \
            "https://api.github.com/repos/$repo/tags" \
            2>/dev/null)
        version=$(echo "$api_response" | jq -r '.[0].name // empty' 2>/dev/null)
    fi
    
    echo "$version"
}

# Трансформации версий
strip_v() {
    local ver="$1"
    echo "${ver#v}"
}

beta_format() {
    local ver="$1"
    ver="${ver#v}"
    # v0.0.1-beta.6 -> 0.0.1.beta.6
    echo "${ver//-/.}"
}

# Применить трансформацию версии
transform_version() {
    local package="$1"
    local version="$2"
    local result
    
    if [[ -n "${VERSION_TRANSFORMS[$package]:-}" ]]; then
        local transform="${VERSION_TRANSFORMS[$package]}"
        result=$("$transform" "$version")
    else
        # По умолчанию просто убираем 'v' в начале
        result="${version#v}"
    fi
    
    echo "$result"
}

# Получить текущую версию из Staplerfile
get_current_version() {
    local package="$1"
    local staplerfile="$REPO_ROOT/$package/Staplerfile"
    
    if [[ ! -f "$staplerfile" ]]; then
        log_error "Staplerfile не найден: $staplerfile"
        return 1
    fi
    
    grep -E "^version=" "$staplerfile" | head -1 | cut -d"'" -f2 | cut -d'"' -f2
}

# Обновить версию в Staplerfile
update_staplerfile_version() {
    local package="$1"
    local new_version="$2"
    local staplerfile="$REPO_ROOT/$package/Staplerfile"
    
    if $DRY_RUN; then
        log_info "[DRY-RUN] Обновил бы $package до версии $new_version"
        return 0
    fi
    
    # Обновляем version='...' или version="..."
    sed -i -E "s/^version=['\"][^'\"]+['\"]/version='$new_version'/" "$staplerfile"
    
    log_success "Обновлён $package: $new_version"
}

# Проверить и обновить один пакет
check_package() {
    local package="$1"
    local repo="${PACKAGE_REPOS[$package]:-}"
    
    if [[ -z "$repo" ]]; then
        log_error "Неизвестный пакет: $package"
        return 1
    fi
    
    log_verbose "Проверка пакета: $package ($repo)"
    
    local current_version
    current_version=$(get_current_version "$package") || return 1
    
    local latest_raw
    latest_raw=$(get_latest_version "$repo")
    
    if [[ -z "$latest_raw" ]]; then
        log_warning "$package: не удалось получить версию с GitHub"
        return 1
    fi
    
    local latest_version
    latest_version=$(transform_version "$package" "$latest_raw")
    
    log_verbose "$package: текущая=$current_version, последняя=$latest_version (raw: $latest_raw)"
    
    if [[ "$current_version" == "$latest_version" ]]; then
        log_success "$package: актуальная версия ($current_version)"
        return 0
    fi
    
    log_warning "$package: $current_version -> $latest_version"
    update_staplerfile_version "$package" "$latest_version"
}

# Проверить все пакеты
check_all_packages() {
    local has_updates=false
    
    echo ""
    log_info "Проверка версий пакетов..."
    echo ""
    
    for package in "${!PACKAGE_REPOS[@]}"; do
        check_package "$package" || true
    done
    
    echo ""
}

# Проверка зависимостей
check_dependencies() {
    local missing=()
    
    if ! command -v curl &>/dev/null; then
        missing+=("curl")
    fi
    
    if ! command -v jq &>/dev/null; then
        missing+=("jq")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Отсутствуют зависимости: ${missing[*]}"
        log_info "Установите: sudo apt install ${missing[*]}"
        exit 1
    fi
}

# Парсинг аргументов
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -a|--all)
                UPDATE_ALL=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                log_error "Неизвестная опция: $1"
                usage
                exit 1
                ;;
            *)
                SPECIFIC_PACKAGE="$1"
                shift
                ;;
        esac
    done
}

main() {
    parse_args "$@"
    check_dependencies
    
    if $DRY_RUN; then
        log_info "Режим dry-run: изменения не будут применены"
    fi
    
    if [[ -n "$SPECIFIC_PACKAGE" ]]; then
        check_package "$SPECIFIC_PACKAGE"
    else
        check_all_packages
    fi
}

main "$@"
