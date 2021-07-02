FROM php:7.4-fpm

ENV APP_ROOT /var/www

ENV APP_HOME $APP_ROOT/html

# build related
COPY .docker $APP_HOME/.docker

ARG INSTALL_NODE=true

ARG INSTALL_XDEBUG=false

ARG INSTALL_OPCACHE=true

ARG INSTALL_SSH=true

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update -y && \
    pecl channel-update pecl.php.net && \
    apt-get install -y --no-install-recommends \
    libmagickwand-dev \
    ca-certificates \
    lsb-release \
    gnupg2 \
    nano \
    cron \
    apt-utils \
    curl \
    vim \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libzip-dev \
    libmcrypt-dev \
    zip \
    git \
    unzip \
    supervisor \
    libgmp-dev \
    re2c \
    libmhash-dev \
    file \
    && pecl install imagick && docker-php-ext-enable imagick \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
    --with-freetype --with-jpeg \
    && docker-php-ext-configure exif \
    --enable-exif \
    && docker-php-ext-configure gmp \
    && docker-php-ext-install \
    pgsql \
    pdo_pgsql \
    zip \
    pcntl \
    bcmath \
    gd \
    exif \
    gmp \
    && php -m | grep -q 'zip'

# ###########################################################################
# # Nginx:
# ###########################################################################

RUN echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt-key fingerprint ABF5BD827BD9BF62
RUN apt-get update -y && apt-get install -y nginx


# ###########################################################################
# # NodeJs:
# ###########################################################################

RUN if [ ${INSTALL_NODE} = true ]; then \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    npm i -g yarn \
    ;fi

# ###########################################################################
# # xDebug:
# ###########################################################################
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    cp ${APP_HOME}/.docker/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini \
    ;fi


# ###########################################################################
# # SSH:
# ###########################################################################
COPY .docker/ssh/insecure_id_rsa.pub /tmp/id_rsa.pub

RUN if [ ${INSTALL_SSH} = true ]; then \
  apt-get install -y openssh-server && \
  mkdir /var/run/sshd && \
  mkdir /root/.ssh && \
  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && \
  rm -f /tmp/id_rsa* && \
  chmod 644 /root/.ssh/authorized_keys \
;fi

# ###########################################################################
# # OPCACHE:
# ###########################################################################

RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache && \
    cp ${APP_HOME}/.docker/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini \
    ;fi

# ###########################################################################
# # Composer:
# ###########################################################################

# # Install composer and add its bin to the PATH.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# #
# #--------------------------------------------------------------------------
# # Final Touch
# #--------------------------------------------------------------------------
# #

# # Configure PHP & PHP-FPM
COPY .docker/php/laravel.ini /usr/local/etc/php/conf.d/
RUN rm /usr/local/etc/php-fpm.d/*
COPY .docker/php/fpm.pool.conf /usr/local/etc/php-fpm.d/

# # Configure NGINX
COPY .docker/nginx/nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf

# # Configure supervisord
COPY .docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN if [ ${INSTALL_SSH} = true ]; then \
    echo "\n" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "[program:sshd]" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "stdout_logfile=/dev/stdout" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "stdout_logfile_maxbytes=0" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "stderr_logfile=/dev/stderr" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "stderr_logfile_maxbytes=0" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "autorestart=false" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "startretries=0" >> /etc/supervisor/conf.d/supervisord.conf \
    ;fi

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

WORKDIR $APP_HOME

COPY --chown=www-data:www-data .docker $APP_HOME

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
