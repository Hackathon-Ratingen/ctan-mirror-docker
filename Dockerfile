FROM debian:bookworm-slim

ENV CTAN_SYNC_CRON="21 * * * *" \
    APACHE_SERVER_NAME="localhost"

RUN apt-get update && \
    apt-get install -y \
      apache2 \
      rsync \
      cron \
      tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite headers && \
    a2dissite 000-default.conf

RUN mkdir -p /var/www/html/tex-archive && \
    chown -R www-data:www-data /var/www/html/tex-archive

COPY sync-ctan.sh /usr/local/bin/sync-ctan.sh
RUN chmod +x /usr/local/bin/sync-ctan.sh

COPY ctan-site.conf /etc/apache2/sites-available/ctan.conf
RUN a2ensite ctan.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
