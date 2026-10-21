#!/bin/bash
set -euo pipefail

DEVICE=/dev/nvme0n1

command -v pv >/dev/null || pacman -Sy --noconfirm pv

read -rp "Do you want to securely erase all data on $DEVICE? [y/N] " ERASE

if [[ "$ERASE" == [Yy] || "$ERASE" == [Yy][Ee][Ss] ]]; then
  wipefs -a "$DEVICE"
  pv /dev/urandom -o "$DEVICE"
fi
