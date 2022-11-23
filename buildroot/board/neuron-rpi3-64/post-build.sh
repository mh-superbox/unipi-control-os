#!/bin/sh

set -u
set -e

# Disable owftpd
ln -fs /dev/null "${TARGET_DIR}/etc/systemd/system/owftpd.service"

# Update mosquitto listener
sed -i 's/#listener/listener 1883 0.0.0.0/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"

# Update mosquitto authentication
sed -i 's/#allow_anonymous false/allow_anonymous true/g' "${TARGET_DIR}/etc/mosquitto/mosquitto.conf"