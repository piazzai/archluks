#!/bin/bash
set -e

# prompt partition details
read -rp 'Type the desired size of the EFI partition: [500M] ' efisize
efisize=${efisize:-'500M'}
read -rsp 'Type the desired size of the swap partition: [64G] ' swapsize
swapsize=${swapsize:-'64G'}

# set clock
timedatectl set-ntp true

# wipe current signature and (optionally) securely erase all data
wipefs -a /dev/nvme0n1
read -rp "Do you want to securely erase all data on the device? (Type 'yes' in capital letters): " choice
if [[ "$choice" == 'YES' ]] ; then pv /dev/urandom -o /dev/nvme0n1 ; fi

# create new partitions
printf '%s\n' 'label: gpt' ",$efisize,U," ',,L,' | sfdisk /dev/nvme0n1
mkfs.vfat -F 32 /dev/nvme0n1p1
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup luksOpen /dev/nvme0n1p2 crypt

# create logical volumes
pvcreate /dev/mapper/crypt
vgcreate vg /dev/mapper/crypt
lvcreate -L "$swapsize" vg -n swap
lvcreate -l 100%FREE vg -n root
mkswap /dev/mapper/vg-swap
mkfs.ext4 /dev/mapper/vg-root

# mount volumes
mount /dev/mapper/vg-root /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
swapon /dev/mapper/vg-swap

# bootstrap arch installation
reflector --latest 10 --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist
pacstrap -K /mnt base intel-ucode linux linux-firmware lvm2 networkmanager sudo

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
