# Lumenara

Stapler-репозиторий с приложениями для Linux.

## Подключение

```bash
stplr repo add lumenara https://github.com/Cheviiot/Lumenara.git
```

## Пакеты

| Пакет | Версия | Описание |
|-------|--------|----------|
| happ-desktop | 2.4.0 | Happ — GUI-клиент для xray-core с поддержкой TUN/VPN |
| github-desktop-plus | 3.5.5.13 | GitHub Desktop Plus — улучшенный GUI-клиент для Git с интеграцией Bitbucket/GitLab |

## Установка пакета

```bash
stplr in happ-desktop
```

## Удаление пакета

```bash
stplr rm happ-desktop
```

## Структура

```
Lumenara/
├── stapler-repo.toml       # Конфигурация репозитория
├── happ-desktop/
│   ├── Staplerfile          # Сборочный скрипт пакета
│   ├── postinstall.sh       # Скрипт после установки
│   └── postremove.sh        # Скрипт после удаления
├── github-desktop-plus/
│   ├── Staplerfile          # Сборочный скрипт пакета
│   ├── postinstall.sh       # Скрипт после установки
│   └── postremove.sh        # Скрипт после удаления
└── README.md
```

## Требования

- [Stapler](https://stplr.dev/) >= v0.0.25
