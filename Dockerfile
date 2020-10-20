FROM php:7.4-alpine

LABEL maintainer="minkbear@gmail.com"

ENV DEPLOYER_VERSION=6.8.0

RUN apk update --no-cache \
    && apk add --no-cache \
            bash \
            openssh-client \
            rsync \
            git zip

# Install mbstring extension
RUN apk add --no-cache \
    oniguruma-dev \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable mbstring \
    && rm -rf /tmp/*

RUN curl -L https://deployer.org/releases/v$DEPLOYER_VERSION/deployer.phar > /usr/local/bin/dep \
    && chmod +x /usr/local/bin/dep
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Change default shell to bash (needed for conveniently adding an ssh key)
RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

COPY ssh-deactivate-key-checking ssh-start-entrypoint ssh-add-known-host /bin/

ENV LC_ALL=en_US.UTF-8

ENTRYPOINT ["ssh-start-entrypoint"]
