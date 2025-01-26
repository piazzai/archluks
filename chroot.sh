#!/bin/bash
set -e

# prompt sudo user credentials
read -rp 'What was the target device again? (default: /dev/nvme0n1) ' DEVICE
DEVICE=${DEVICE:-'/dev/nvme0n1'}
read -rp 'What is your timezone? (default: UTC) ' TIMEZONE
TIMEZONE=${TIMEZONE:-'UTC'}
read -rp 'What is your locale? (default: en_US) ' LOCALE
LOCALE=${LOCALE:-'en_US'}
read -rp 'What should be the hostname? (default: arch) ' HOSTNAME
HOSTNAME=${HOSTNAME:-'arch'}
read -rp 'What should be the username? ' USERNAME
if [ "$USERNAME" == '' ] ; then echo 'Username required. Aborting.' && exit 1 ; fi
read -rsp 'Set a user password... ' PASSWORD
if [ "$PASSWORD" == '' ] ; then echo 'Password required. Aborting.' && exit 1 ; fi
read -rsp 'Repeat the password... ' CHECK
if [ "$CHECK" != "$PASSWORD" ] ; then echo 'Passwords do not match. Aborting.' && exit 1 ; fi

# install bootloader
bootctl install

# create boot entry
UUID=$(blkid "${DEVICE}p2" | sed 's/.* UUID="\([^\"]*\).*/\1/')
printf '%s\n' 'title Arch Linux' \
  'linux /vmlinuz-linux' \
  'initrd /intel-ucode.img' \
  'initrd /initramfs-linux.img' \
  "options cryptdevice=UUID=$UUID:vg root=/dev/mapper/vg-root rw" \
  > /boot/loader/entries/arch.conf

# add modules and hooks to initial ramdisk
sed -i 's/^MODULES=()/MODULES=(nvme)/' /etc/mkinitcpio.conf
sed -i 's/^\(HOOKS.*\)block\(.*\)/\1block encrypt lvm2\2/' /etc/mkinitcpio.conf
mkinitcpio -p linux

# set clocks
timedatectl set-ntp true
timedatectl set-timezone "$TIMEZONE"
hwclock --systohc

# generate locale
sed -i "s/^#\($LOCALE.UTF-8\)/\1/" /etc/locale.gen
locale-gen
printf '%s' "LANG=$LOCALE.UTF-8" > /etc/locale.conf

# set hostname and add hosts entries
printf '%s' "$HOSTNAME" > /etc/hostname
printf '%s\n' '127.0.0.1 localhost' '::1 localhost' >> /etc/hosts

# create sudo user
useradd -m -G wheel "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
sed -i 's/^# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers
