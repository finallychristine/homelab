#!/bin/sh
apt update
apt install wget gpg
#
#mkdir -p /etc/apt/keyrings/
#wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
#echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
#
#apt update
#apt install alloy

