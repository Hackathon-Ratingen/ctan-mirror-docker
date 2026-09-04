FROM debian:bookworm-slim

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
# Change the cron schedule to a custom time. See README.md for more information.
RUN chmod +x /usr/local/bin/sync-ctan.sh && \
    echo "21 * * * * /usr/local/bin/sync-ctan.sh >> /var/log/ctan-sync.log 2>&1" \
      | crontab -

COPY ctan-site.conf /etc/apache2/sites-available/ctan.conf
RUN a2ensite ctan.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]