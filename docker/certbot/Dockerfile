FROM certbot/dns-cloudflare:latest
COPY renew.cron /etc/cron.d/renew
RUN chmod 0644 /etc/cron.d/renew
RUN crontab /etc/cron.d/renew

ENTRYPOINT []
CMD crond -f -d 8
