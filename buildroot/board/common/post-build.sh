#!/bin/sh

set -u
set -e

mkdir -p ${TARGET_DIR}/boot

# Init systemd
mkdir -p ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants

# Enable resize root systemd service
ln -fs ../resize-root.service ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/resize-root.service

# Enable monit systemd service
ln -fs ../resize-root.service ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/monit.service

# Update boot arguments
grep -qE ' loglevel=3' ${BINARIES_DIR}/rpi-firmware/cmdline.txt || sed -i '$ s/$/ loglevel=3/' ${BINARIES_DIR}/rpi-firmware/cmdline.txt
grep -qE ' zram.enabled=1' ${BINARIES_DIR}/rpi-firmware/cmdline.txt || sed -i '$ s/$/ zram.enabled=1/' ${BINARIES_DIR}/rpi-firmware/cmdline.txt

# Update Systemd Journald
sed -i 's/#Storage=auto/Storage=volatile/g' ${TARGET_DIR}/etc/systemd/journald.conf

# Set ZSH for root user
sed -i '/^root:/s,:/bin/dash$,:/bin/zsh,' ${TARGET_DIR}/etc/passwd
