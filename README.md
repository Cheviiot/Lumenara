<div align="center">

<img src="https://raw.githubusercontent.com/Cheviiot/Luma/main/.github/assets/banner.svg" alt="Luma" width="100%">


[![Stapler](https://img.shields.io/badge/Stapler-репозиторий-7C3AED?style=for-the-badge&logo=linux&logoColor=white)](https://stplr.dev)
&nbsp;
[![Packages](https://img.shields.io/badge/пакетов-6-22C55E?style=for-the-badge)](https://github.com/Cheviiot/Luma)
&nbsp;
[![License](https://img.shields.io/badge/лицензия-Mixed-F59E0B?style=for-the-badge)](https://github.com/Cheviiot/Luma)
&nbsp;
[![ALT](https://img.shields.io/badge/ALT_Linux-tested-3B82F6?style=for-the-badge)](https://github.com/Cheviiot/Luma)

</div>

<br>

## 🚀 Быстрый старт

```bash
stplr repo add luma https://github.com/Cheviiot/Luma.git
stplr refresh
stplr install <имя_пакета>
```

<br>

## 📦 Каталог пакетов

<table>
<tr><td colspan="4"><h4>🌐 Сеть и VPN</h4></td></tr>
<tr>
<th align="left">Пакет</th>
<th align="center">Версия</th>
<th align="left">Описание</th>
<th align="center">Лицензия</th>
</tr>
<tr>
<td><a href="https://github.com/Happ-proxy/happ-desktop"><b>happ</b></a></td>
<td align="center"><code>2.6.0</code></td>
<td>GUI для xray-core с поддержкой TUN/VPN</td>
<td align="center">Проприетарная</td>
</tr>
<tr>
<td><a href="https://www.freedownloadmanager.org"><b>fdm</b></a></td>
<td align="center"><code>6.33.1</code></td>
<td>Мощный менеджер загрузок с поддержкой торрентов</td>
<td align="center">Проприетарная</td>
</tr>
</table>

<table>
<tr><td colspan="4"><h4>🛠️ Разработка</h4></td></tr>
<tr>
<th align="left">Пакет</th>
<th align="center">Версия</th>
<th align="left">Описание</th>
<th align="center">Лицензия</th>
</tr>
<tr>
<td><a href="https://github.com/pol-rivero/github-desktop-plus"><b>github-plus</b></a></td>
<td align="center"><code>3.5.7.2</code></td>
<td>Улучшенный GUI-клиент для Git с интеграцией Bitbucket/GitLab</td>
<td align="center">MIT</td>
</tr>
</table>

<table>
<tr><td colspan="4"><h4>🎬 Медиа и развлечения</h4></td></tr>
<tr>
<th align="left">Пакет</th>
<th align="center">Версия</th>
<th align="left">Описание</th>
<th align="center">Лицензия</th>
</tr>
<tr>
<td><a href="https://altlinux.space/alt-gnome/Kitsune"><b>kitsune</b></a></td>
<td align="center"><code>0.8.4</code></td>
<td>Libadwaita-клиент для просмотра аниме от AniLiberty</td>
<td align="center">GPL-3.0</td>
</tr>
</table>

<table>
<tr><td colspan="4"><h4>🎮 Игры и Steam</h4></td></tr>
<tr>
<th align="left">Пакет</th>
<th align="center">Версия</th>
<th align="left">Описание</th>
<th align="center">Лицензия</th>
</tr>
<tr>
<td><a href="https://github.com/Cheviiot/Vual"><b>vual</b></a></td>
<td align="center"><code>0.3.1</code></td>
<td>Запуск Cheat Engine для Steam/Proton игр</td>
<td align="center">GPL-3.0</td>
</tr>
</table>

<table>
<tr><td colspan="4"><h4>🎨 Персонализация</h4></td></tr>
<tr>
<th align="left">Пакет</th>
<th align="center">Версия</th>
<th align="left">Описание</th>
<th align="center">Лицензия</th>
</tr>
<tr>
<td><a href="https://github.com/cheviiot/adwyra"><b>adwyra</b></a></td>
<td align="center"><code>0.5.0</code></td>
<td>Элегантный лаунчер приложений для GNOME</td>
<td align="center">GPL-3.0</td>
</tr>
</table>

<br>

## 💻 Использование

| Команда | Описание |
|:--------|:---------|
| `stplr install <пакет>` | Установить пакет |
| `stplr remove <пакет>` | Удалить пакет |
| `stplr upgrade` | Обновить все пакеты |
| `stplr search <запрос>` | Поиск пакетов |

<br>

## 🔄 Автообновление версий

Версии пакетов проверяются автоматически через **GitHub Actions** (ежедневно в 6:00 UTC). При обнаружении обновлений создаётся Pull Request.

<details>
<summary><b>Локальное использование</b></summary>

<br>

```bash
# Проверить все пакеты (без изменений)
./.github/scripts/update-versions.sh -n

# Обновить все пакеты
./.github/scripts/update-versions.sh

# Обновить конкретный пакет
./.github/scripts/update-versions.sh happ
```

</details>

<br>

## 🔧 Требования

- [**Stapler**](https://stplr.dev) — универсальный менеджер пакетов для Linux

| Дистрибутив | Поддержка |
|:------------|:---------:|
| ALT Linux | ✅ |
| Fedora | ✅ |
| Debian | ✅ |
| Ubuntu | ✅ |
| Arch Linux | ✅ |
| openSUSE | ✅ |

<br>

## 📄 Лицензия

Каждый пакет распространяется под собственной лицензией.  
Подробности — в директории соответствующего пакета.

---

<div align="center">

<sub>Сделано с ❤️ для Linux-сообщества</sub>

</div>

