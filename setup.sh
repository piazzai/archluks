#!/bin/bash
set -e

# prompt sudo user credentials
read -rp 'Set a name for the sudo user: ' username
if [ "$username" == '' ] ; then echo 'Username required. Aborting.' && exit 1 ; fi
read -rsp 'Set a password for the sudo user: ' password
if [ "$password" == '' ] ; then echo 'Password required. Aborting.' && exit 1 ; fi
read -rsp 'Repeat the password: ' check
if [ "$check" != "$password" ] ; then echo 'Passwords do not match. Aborting.' && exit 1 ; fi

# install bootloader
bootctl install

# create boot entry
uuid=$(blkid /dev/nvme0n1p2 | sed 's/.* UUID="\([^\"]\).*/\1/')
printf '%s\n' 'title Arch Linux' \
  'linux /vmlinuz-linux' \
  'initrd /intel-ucode.img' \
  'initrd /initramfs-linux.img' \
  "options cryptdevice=UUID=$uuid:vg root=/dev/mapper/vg-root rw" \
  > /boot/loader/entries/arch.conf

# add modules and hooks to initial ramdisk
sed -i 's/^MODULES=()/MODULES=(nvme)/' /etc/mkinitcpio.conf
sed -i 's/^\(HOOKS.*\)block\(.*\)/\1block encrypt lvm2\2/' /etc/mkinitcpio.conf
mkinitcpio -p linux

# set hardware clock
timedatectl set-timezone UTC
hwclock --systohc

# generate locale
sed -i 's/^#\(en_US.UTF-8\)/\1/' /etc/locale.gen
locale-gen
printf '%s' LANG=en_US.UTF-8 > /etc/locale.conf

# set hostname and add hosts entries
printf '%s' arch > /etc/hostname
printf '%s\n' '127.0.0.1 localhost' '::1 localhost' >> /etc/hosts

# create sudo user
useradd -m -G wheel "$username"
echo "$username:$password" | chpasswd
sed -i 's/^# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers
