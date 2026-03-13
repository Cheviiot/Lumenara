<div align="center">

# ✨ Lumenara

**Stapler-репозиторий с приложениями для Linux**

[![Stapler](https://img.shields.io/badge/Stapler-репозиторий-blue?style=for-the-badge&logo=linux)](https://stplr.dev)
[![Packages](https://img.shields.io/badge/пакетов-7-green?style=for-the-badge)](https://github.com/Cheviiot/Lumenara)
[![License](https://img.shields.io/badge/license-Mixed-orange?style=for-the-badge)](https://github.com/Cheviiot/Lumenara)

</div>

---

## 🚀 Быстрый старт

```bash
# Добавить репозиторий
stplr repo add lumenara https://github.com/Cheviiot/Lumenara.git

# Обновить индекс
stplr refresh

# Установить пакет
stplr install <имя_пакета>
```

---

## 📦 Каталог пакетов

### 🌐 Сеть и VPN

| Пакет | Версия | Описание | Лицензия |
|:------|:------:|:---------|:--------:|
| [**happ**](https://github.com/Happ-proxy/happ-desktop) | `2.4.0` | GUI для xray-core с поддержкой TUN/VPN | Проприетарная |

### 🛠️ Разработка

| Пакет | Версия | Описание | Лицензия |
|:------|:------:|:---------|:--------:|
| [**github-plus**](https://github.com/pol-rivero/github-desktop-plus) | `3.5.7.0` | Улучшенный GUI-клиент для Git с интеграцией Bitbucket/GitLab | MIT |
| [**aya**](https://github.com/liriliri/aya) | `1.14.2` | Приложение для управления Android устройствами через ADB | AGPL-3.0 |

###  Медиа и развлечения

| Пакет | Версия | Описание | Лицензия |
|:------|:------:|:---------|:--------:|
| [**anidesk**](https://github.com/theDesConnet/AniDesk) | `0.0.1-beta.6` | Десктоп-клиент Anixart для просмотра аниме | GPL-2.0 |
| [**winboat**](https://github.com/TibixDev/winboat) | `0.9.0` | Запуск Windows-приложений с бесшовной интеграцией | MIT |

### 🎨 Персонализация

| Пакет | Версия | Описание | Лицензия |
|:------|:------:|:---------|:--------:|
| [**morewaita**](https://github.com/somepaulo/MoreWaita) | `49` | Расширенная тема иконок в стиле Adwaita для GNOME | GPL-3.0 |
| [**adwyra**](https://github.com/cheviiot/adwyra) | `0.4.0` | Элегантный лаунчер приложений для Gnome | GPL-3.0 |

---

## 💻 Использование

### Установка пакета
```bash
stplr install happ
```

### Обновление всех пакетов
```bash
stplr upgrade
```

### Удаление пакета
```bash
stplr remove happ
```

### Поиск пакетов
```bash
stplr search git
```

---

## � Автообновление версий

Репозиторий автоматически проверяет новые версии пакетов через GitHub Actions:

- **Ежедневная проверка** — workflow запускается каждый день в 6:00 UTC
- **Ручной запуск** — можно запустить проверку в любое время через Actions
- **Автоматические PR** — при обнаружении обновлений создаётся Pull Request

### Локальное использование

```bash
# Проверить все пакеты (без изменений)
./scripts/update-versions.sh -n

# Обновить все пакеты
./scripts/update-versions.sh

# Обновить конкретный пакет
./scripts/update-versions.sh happ
```

---

## �🔧 Требования

- [Stapler](https://stplr.dev) — универсальный менеджер пакетов для Linux
- Поддерживаемые дистрибутивы: **ALT Linux**, **Fedora**, **Debian**, **Ubuntu**, **Arch Linux**, **openSUSE**

---

## 📄 Лицензия

Каждый пакет распространяется под собственной лицензией. Подробности в директории соответствующего пакета.

---

<div align="center">

**Сделано с ❤️ для Linux-сообщества**

</div>

