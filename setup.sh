#!/bin/bash
set -e

read -rp "What is the name of your device again? [/dev/nvme0n1] " device
device=${device:-'/dev/nvme0n1'}

read -rp "What is the name of your CPU make again? [intel] " cpu
cpu=${cpu:-'intel'}

read -rp "Set timezone: [UTC] " tz
tz=${tz:-'UTC'}

read -rp "Set locale: [en_US] " locale
locale=${locale:-'en_US'}

read -rp "Set hostname: [arch] " hostname
hostname=${hostname:-'arch'}

read -rp "Set username: " username
if [ "$username" == '' ] ; then echo "Error: username required." && exit 1 ; fi

read -rp "Set password: " userpw
if [ "$userpw" == '' ] ; then echo "Error: password required." && exit 1 ; fi

printf '%s\n' "Device: $device" "CPU make: $cpu" "Timezone: $tz"  "Locale: $locale" "Hostname: $hostname" "Username: $username"
read -rp "Proceed (y/N)? " choice
if [[ "$choice" != [Yy] && "$choice" != [Yy][Ee][Ss] ]] ; then echo "Aborted." && exit 1 ; fi

# install bootloader
bootctl install

# create boot entry
uuid=$(blkid "${device}p2" | sed 's/.* UUID="\([^\"]\).*/\1/')
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
timedatectl set-timezone "$tz"
hwclock --systohc

# generate locale
sed -i "s/^#\($locale.UTF-8\)/\1/" /etc/locale.gen
locale-gen
printf '%s' "LANG=$locale.UTF-8" > /etc/locale.conf

# set hostname and add hosts entries
printf '%s' "$hostname" > /etc/hostname
printf '%s\n' '127.0.0.1 localhost' '::1 localhost' >> /etc/hosts

# create sudo user
useradd -m -G wheel "$username"
echo "$username:$userpw" | chpasswd
sed -i 's/^# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers
