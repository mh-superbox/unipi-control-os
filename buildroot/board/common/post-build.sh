#!/bin/sh

set -u
set -e

mkdir -p "${TARGET_DIR}/boot"

# Copy U-Boot extlinux config file
install -m 0644 -D "${BR2_EXTERNAL_UNIPI_PATH}/board/common/extlinux.conf" "${BINARIES_DIR}/extlinux/extlinux.conf"

# Copy U-Boot boot txt
install -m 0664 -D "${BR2_EXTERNAL_UNIPI_PATH}/board/common/boot.txt" "${BINARIES_DIR}/boot.txt"

# Copy cmdline.txt file
install -m 0644 -D "${BR2_EXTERNAL_UNIPI_PATH}/board/common/cmdline.txt" "${BINARIES_DIR}/cmdline.txt"

# Init systemd
mkdir -p "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants"

# Enable resize root systemd service
ln -fs ../resize-root.service "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/resize-root.service"

# Enable monit systemd service
ln -fs ../resize-root.service "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/monit.service"

# Allow members of group whell to exectue any command
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' "${TARGET_DIR}/etc/sudoers"

# Update Systemd Journald
sed -i 's/#Storage=auto/Storage=volatile/g' "${TARGET_DIR}/etc/systemd/journald.conf"

# Set ZSH for root user
sed -i '/^root:/s,:/bin/dash$,:/bin/zsh,' "${TARGET_DIR}/etc/passwd"