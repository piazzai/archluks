#!/bin/bash
source <(grep '=' config.ini) && set -e

# install bootloader
bootctl install

# create boot entry
uuid=$(blkid ${dev}p2 | sed 's/.* UUID="\([^\"]\).*/\1/')
printf '%s\n' 'title Arch Linux' \
  'linux /vmlinuz-linux' \
  "initrd /$cpu-ucode.img" \
  'initrd /initramfs-linux.img' \
  "options cryptdevice=UUID=$uuid:vg root=/dev/mapper/vg-root rw" > /boot/loader/entries/arch.conf

# add modules and hooks to initial ramdisk
sed -i 's/^MODULES=()/MODULES=(nvme)/' /etc/mkinitcpio.conf
sed -i 's/^\(HOOKS.*\)block\(.*\)/\1block encrypt lvm2\2/' /etc/mkinitcpio.conf
mkinitcpio -p linux

# set hardware clock
hwclock --systohc

# generate en_US locale
sed -i "s/^#\(en_US.UTF-8\)/\1/" /etc/locale.gen && locale-gen
printf '%s' "LANG=en_US.UTF-8" > /etc/locale.conf

# set hostname and add hosts entries
printf '%s' arch > /etc/hostname
printf '%s\n' '127.0.0.1 localhost' '::1 localhost' >> /etc/hosts

# create sudo user
useradd -m -G wheel $user
echo "$user:$userpw" | chpasswd
sed -i 's/^# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers

# exit arch-chroot
exit
