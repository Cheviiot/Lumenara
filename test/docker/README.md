# Тестирование пакетов Lumenara в Docker

Тестирование сборки пакетов в изолированном окружении ALT Linux p11.

## Требования

- Docker
- Docker Compose (опционально)
- Образ `alt:p11` (скачается автоматически)
- **Локально установленный `stplr`** — монтируется в контейнер

## Быстрый старт

```bash
# Тестировать все пакеты
./test-all.sh

# Тестировать один пакет
./test-all.sh winegui

# Или индивидуально с подробным выводом
./test-install.sh winegui
```

## Файлы

| Файл | Описание |
|------|----------|
| `Dockerfile.altlinux` | Базовый образ ALT Linux p11 |
| `Dockerfile.package` | Универсальный Dockerfile для пакетов |
| `docker-compose.yml` | Конфигурация для всех пакетов |
| `test-all.sh` | Скрипт тестирования всех пакетов |
| `test-install.sh` | Скрипт тестирования одного пакета с зависимостями |

## Использование docker-compose

```bash
# Установить переменную окружения
export STPLR_PATH=$(which stplr)

# Собрать все образы
docker compose build

# Запустить все тесты
docker compose up

# Тестировать конкретный пакет
docker compose up winegui
docker compose up happ

# Просмотр логов
docker compose logs -f winegui
```

## Использование test-install.sh

Скрипт `test-install.sh` дополнительно пытается установить зависимости из `deps_altlinux`:

```bash
./test-install.sh winegui
./test-install.sh happ
```

## Как это работает

1. Локальный `stplr` монтируется в контейнер как `/usr/local/bin/stplr`
2. Папка пакета монтируется как `/build` (read-only)
3. Контейнер устанавливает базовые зависимости (`cpio`, `tar`, `gzip`, `xz`)
4. Выполняется `stplr build -c` для сборки пакета
5. Результат выводится в консоль

## Логи

Логи тестирования сохраняются в `/tmp/lumenara-test-<package>.log`
