#!/bin/sh
set -eu

dbus-daemon --system --fork
avahi-daemon --daemonize

exec "$@"
