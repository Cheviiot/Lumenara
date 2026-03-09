FROM alt:p11

# Устанавливаем stplr, сертификаты и зависимости для сборки
RUN apt-get update -qq && \
    apt-get install -y -qq stplr rpm-build ca-certificates ca-trust \
    meson python3 blueprint-compiler libgtk4-devel libadwaita-devel \
    gettext desktop-file-utils libappstream-glib glib2-devel 2>/dev/null && \
    update-ca-trust

WORKDIR /repo
COPY . /repo/

# Скрипт для тестов
COPY .github/test/test-packages.sh /test-packages.sh
RUN chmod +x /test-packages.sh

ENTRYPOINT ["/test-packages.sh"]
