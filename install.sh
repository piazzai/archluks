#!/bin/bash
set -e

read -rp "What is the name of your device? [/dev/nvme0n1]" device
device=${device:-'/dev/nvme0n1'}

read -rp "What is the name of your cpu make? [intel]" cpu
cpu=${cpu:-'intel'}

read -rp "Set EFI partition size: [1G]" efi
efi=${efi:-'1G'}

read -rp "Set swap partition size: [4G]" swap
swap=${swap:-'4G'}

read -rp "What is the name of your wifi network?" wifiname
if [ "$wifiname" == '' ] ; then echo "error: network name required" && exit 1 ; fi

read -rp "What is the password of your wifi network?" wifipw
if [ "$wifipw" == '' ] ; then echo "error: network password required" && exit 1 ; fi

read -rp "Repeat password for $wifiname:" check
if [ "$check" != "$wifipw" ] ; then echo "error: passwords do not match" && exit 1 ; fi

printf '%ś\n' "device: $device" "cpu make: $cpu" "efi partition size: $efi" \
    "swap partition size: $swap" "network name: $wifiname"
read -rp "Proceed (y/N)?" choice
if [[ "$choice" != [Yy] && "$choice" != [Yy][Ee][Ss] ]] ; then echo "Aborted." && exit 1 ; fi

# connect to wifi network 
iwctl --passphrase "$wifipw" station wlan0 connect "$wifi"

# set clock
timedatectl set-ntp true

# wipe current drive signature and (optionally) overwrite all data
wipefs -a "$device"
read -rp "Do you want to overwrite all data on $device (y/N)?" choice
if [[ "$choice" == [Yy] || "$choice" == [Yy][Ee][Ss] ]] ; then pv /dev/urandom -o "$device" ; fi

# create new partitions
printf '%s\n' 'label: gpt' ",$efi,U," ',,L,' | sfdisk "$device"
mkfs.vfat -F 32 "${device}p1"
cryptsetup luksFormat "${device}p2"
cryptsetup luksOpen "${device}p2" crypt

# create logical volumes
pvcreate /dev/mapper/crypt
vgcreate vg /dev/mapper/crypt
lvcreate -L "$swap" vg -n swap
lvcreate -l 100%FREE vg -n root
mkswap /dev/mapper/vg-swap
mkfs.ext4 /dev/mapper/vg-root

# mount volumes
mount /dev/mapper/vg-root /mnt
mkdir /mnt/boot
mount "${device}p1" /mnt/boot
swapon /dev/mapper/vg-swap

# bootstrap arch installation
reflector --latest 10 --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist
pacstrap -K /mnt base "$cpu-ucode" linux linux-firmware lvm2 networkmanager sudo

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
