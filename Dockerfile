FROM php:7.2-alpine

LABEL maintainer="minkbear@gmail.com"

ENV DEPLOYER_VERSION=6.3.0

RUN apk update --no-cache \
    && apk add --no-cache \
            bash \
            openssh-client \
            rsync

RUN curl -L https://deployer.org/releases/v$DEPLOYER_VERSION/deployer.phar > /usr/local/bin/deployer \
    && chmod +x /usr/local/bin/deployer

# Change default shell to bash (needed for conveniently adding an ssh key)
RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

COPY ssh-deactivate-key-checking ssh-start-entrypoint ssh-add-known-host /bin/

ENV LC_ALL=en_US.UTF-8

ENTRYPOINT ["ssh-start-entrypoint"]