FROM ubuntu:latest

ARG OVERLAY_VERSION="v2.2.0.3"
ARG OVERLAY_ARCH="amd64"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y software-properties-common curl apt-transport-https ca-certificates gnupg curl tar unzip git nginx php8.1 php8.1-common php8.1-cli php8.1-gd php8.1-mysql php8.1-mbstring php8.1-bcmath php8.1-xml php8.1-fpm php8.1-curl php8.1-zip && \
    rm -rf /var/lib/apt/lists/*
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${OVERLAY_ARCH}-installer && /tmp/s6-overlay-${OVERLAY_ARCH}-installer / && rm /tmp/s6-overlay-${OVERLAY_ARCH}-installer
RUN curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sSL https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzf - -C /var/www/html/ && \
    composer install --no-dev --optimize-autoloader -d /var/www/html/ && \
    chmod -R 755 /var/www/html/storage/* /var/www/html/bootstrap/cache/ && \
    chown -R www-data:www-data -R /var/www/
COPY root/ /
WORKDIR /var/www/html/
ENTRYPOINT ["/init"]