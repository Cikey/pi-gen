#!/bin/bash -e

install -d ${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d
install -m 644 files/noclear.conf ${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/noclear.conf
install -m 744 files/policy-rc.d ${ROOTFS_DIR}/usr/sbin/policy-rc.d #TODO: Necessary in systemd?
install -v -m 644 files/fstab ${ROOTFS_DIR}/etc/fstab

on_chroot << EOF
if ! id -u pi >/dev/null 2>&1; then
	adduser --disabled-password --gecos "" ucowl
fi
echo "root:root" | chpasswd

passwd -d ucowl
chage -d0 ucowl
EOF

install -m 700 -d				${ROOTFS_DIR}/home/ucowl/.ssh
install -m 600 files/authorized_keys		${ROOTFS_DIR}/home/ucowl/.ssh/authorized_keys

on_chroot << EOF
chown -R ucowl:ucowl /home/ucowl/.ssh
EOF
