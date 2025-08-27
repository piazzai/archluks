#!/bin/bash
set -e

# input partition sizes
read -rp 'What is the target device? (default: /dev/nvme0n1) ' DEVICE
DEVICE=${DEVICE:-'/dev/nvme0n1'}
read -rp "What is your CPU make? (default: 'intel') " CPU
CPU=${CPU:-'intel'}
read -rp 'What is the size of the EFI partition? (default: 500M) ' EFI
EFI=${EFI:-'500M'}
read -rp 'What is the size of the swap partition? (default: 64G) ' SWAP
SWAP=${SWAP:-'64G'}

# prompt confirmation
echo "This will wipe $DEVICE and create a new partition table with $EFI for EFI, $SWAP for swap, and all remaining space for the filesystem."
read -rp "Data currently on $DEVICE will be overwritten. Proceed? (default: no) " PROCEED
if [[ "$PROCEED" == [Yy] || "$PROCEED" == [Yy][Ee][Ss] ]]; then
    echo "Proceeding."
else
    echo "Aborting."
    exit 0
fi

# wipe current signature
wipefs -a "$DEVICE"

# securely erase all data (optional)
read -rp "Do you want to securely erase all data on $DEVICE? (default: no) " ERASE
if [[ "$ERASE" == [Yy] || "$ERASE" == [Yy][Ee][Ss] ]]; then
    pv /dev/urandom -o "$DEVICE"
else
    echo "Skipping secure erasure."
fi

# create new partitions
printf '%s\n' 'label: gpt' ",$EFI,U," ',,L,' | sfdisk "$DEVICE"
mkfs.vfat -F32 "${DEVICE}p1"
cryptsetup luksFormat "${DEVICE}p2"
cryptsetup luksOpen "${DEVICE}p2" cryptroot

# create and format logical volumes
pvcreate /dev/mapper/cryptroot
vgcreate vg /dev/mapper/cryptroot
lvcreate -L "$SWAP" vg -n swap
lvcreate -l 100%FREE vg -n root
mkswap /dev/mapper/vg-swap
mkfs.ext4 /dev/mapper/vg-root

# mount volumes
mount /dev/mapper/vg-root /mnt
mkdir /mnt/boot
mount "${DEVICE}p1" /mnt/boot

# enable swap
swapon /dev/mapper/vg-swap

# bootstrap arch installation
pacstrap -K /mnt base base-devel "$CPU-ucode" linux linux-firmware lvm2 networkmanager sudo

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
