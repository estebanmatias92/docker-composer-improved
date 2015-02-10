FROM estebanmatias92/composer-hhvm

MAINTAINER "Matias Esteban" <estebanmatias92@gmail.com>

# Install runtime dependencies
RUN deps=' \
        wget \
        unzip \
    ' \
    && apt-get -y update \
    && apt-get install -y --no-install-recommends $deps \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y

# Copy entrypoint inside container.
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

WORKDIR /var/www

ENTRYPOINT ["/entrypoint.sh"]

CMD ["--help"]
