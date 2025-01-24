#!/bin/bash
set -e

# input partition sizes
read -rp 'What is the target device? (default: /dev/nvme0n1) ' DEVICE
DEVICE=${DEVICE:-'/dev/nvme0n1'}
read -rp 'What is the size of the EFI partition? (default: 500M) ' EFI
EFI=${EFI:-'500M'}
read -rp 'What is the size of the swap partition? (default: 64G) ' SWAP
SWAP=${SWAP:-'64G'}

read -rp "This will wipe $DEVICE and repartition it with $EFI for the EFI system, \
  $SWAP for swap memory, and all remaining space for the filesystem. Data currently \
  on $DEVICE will be overwritten. Proceed? (default: no) " PROCEED
if [[ "$PROCEED" == [Yy] || "$PROCEED" == [Yy][Ee][Ss] ]]; then
    echo "Proceeding."
else
    echo "Aborting."
    exit 1
fi

# set clock
timedatectl set-ntp true

# wipe current signature and (optionally) securely erase all data
wipefs -a "$DEVICE"
read -rp "Do you want to securely erase all data on $DEVICE? (default: no) " ERASE
if [[ "$ERASE" == [Yy] || "$ERASE" == [Yy][Ee][Ss] ]]; then
    pv /dev/urandom -o "$DEVICE"
else
    echo "Skipping secure erasure."
fi

# create new partitions
printf '%s\n' 'label: gpt' ",$EFI,U," ',,L,' | sfdisk "$DEVICE"
mkfs.vfat -F 32 "${DEVICE}p1"
cryptsetup luksFormat "${DEVICE}p2"
cryptsetup luksOpen "${DEVICE}p2" crypt

# create logical volumes
pvcreate /dev/mapper/crypt
vgcreate vg /dev/mapper/crypt
lvcreate -L "$SWAP" vg -n swap
lvcreate -l 100%FREE vg -n root
mkswap /dev/mapper/vg-swap
mkfs.ext4 /dev/mapper/vg-root

# mount volumes
mount /dev/mapper/vg-root /mnt
mkdir /mnt/boot
mount "${DEVICE}p1" /mnt/boot
swapon /dev/mapper/vg-swap

# bootstrap arch installation
reflector --latest 10 --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist
pacstrap -K /mnt base intel-ucode linux linux-firmware lvm2 networkmanager sudo

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
