#!/usr/bin/env bash
docker compose run certbot \
  certbot certonly \
  --non-interactive --agree-tos --dns-cloudflare \
  --dns-cloudflare-credentials /run/secrets/cloudflare_credentials \
  --domains '*.beartree.me'
