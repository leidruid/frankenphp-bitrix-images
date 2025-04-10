FROM dunglas/frankenphp:php8.2

WORKDIR /opt
RUN groupadd -g 1000 appuser && useradd -r -u 1000 -g appuser appuser
RUN curl -sL $(curl -s https://api.github.com/repos/mattn/goreman/releases/latest | awk '/browser_download_url.*linux_amd64/ {print $2}' | sed -r 's/\"//g') -o goreman.tar.gz && tar zxf goreman.tar.gz && find . -type f -name goreman -exec cp {} /usr/local/bin/ \; && rm -rf goreman* && \
    curl -sL $(curl -s https://api.github.com/repos/aptible/supercronic/releases/latest | awk '/browser_download_url.*linux-amd64/ {print $2}' | sed -r 's/\"//g') -o /usr/local/bin/supercronic && chmod +x /usr/local/bin/supercronic
RUN apt update && \
    apt upgrade -y && \
    apt install libfreetype6 msmtp -y && \
    apt clean && \
    install-php-extensions mysqli gd intl zip opcache memcache
COPY Caddyfile /etc/caddy/Caddyfile
COPY php.ini /usr/local/etc/php/php.ini
COPY Procfile /
USER appuser
WORKDIR /app
EXPOSE 8080
CMD ["goreman", "-f", "/Procfile", "start"]