influxdb3 create database --token "$(cat /var/run/secrets/influxdb-admin-token-text)" --retention-period 90d telegraf
influxdb3 create database --token "$(cat /var/run/secrets/influxdb-admin-token-text)" --retention-period 90d homeassistant
