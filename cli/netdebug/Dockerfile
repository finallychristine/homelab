FROM nicolaka/netshoot
RUN apk add --no-cache avahi avahi-tools dbus && \
  mkdir -p /run/dbus

COPY entrypoint.sh /usr/local/bin/netdebug-entrypoint
RUN chmod +x /usr/local/bin/netdebug-entrypoint

ENTRYPOINT ["/usr/local/bin/netdebug-entrypoint"]
CMD ["zsh"]
