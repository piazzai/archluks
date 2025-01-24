#!/bin/bash
source <(grep '=' config.ini) && set -e

# connect to wifi network and set clock
iwctl --passphrase "$wifipw" station wlan0 connect "$wifi"
timedatectl set-ntp true

# wipe current drive signature and (optionally) overwrite all data
wipefs -a $dev
if $overwrite ; then pv /dev/urandom -o $dev ; fi

# create new partitions
printf '%s\n' 'label: gpt' ",$efi,U," ',,L,' | sfdisk $dev
mkfs.vfat -F 32 ${dev}p1
cryptsetup luksFormat ${dev}p2
cryptsetup luksOpen ${dev}p2 crypt

# create logical volumes
pvcreate /dev/mapper/crypt
vgcreate vg /dev/mapper/crypt
lvcreate -L $swap vg -n swap
lvcreate -l 100%FREE vg -n root
mkswap /dev/mapper/vg-swap
mkfs.ext4 /dev/mapper/vg-root

# mount volumes
mount /dev/mapper/vg-root /mnt
mkdir /mnt/boot
mount ${dev}p1 /mnt/boot
swapon /dev/mapper/vg-swap

# bootstrap arch installation
reflector --latest 10 --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist
pacstrap -K /mnt base linux linux-firmware lvm2 $cpu-ucode sudo networkmanager

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# run chroot.sh
mkdir /mnt/archluks
cp -r ./* /mnt/archluks/
arch-chroot /mnt bash /archluks/chroot.sh
rm -rf /mnt/archluks

# unmount and reboot
umount -R /mnt
reboot
