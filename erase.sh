#!/bin/bash

DEVICE=/dev/nvme0n1

read -rp "Do you want to securely erase all data on $DEVICE? [y/N] " ERASE

if [[ "$ERASE" == [Yy] || "$ERASE" == [Yy][Ee][Ss] ]]; then
  wipefs -a "$DEVICE"
  pv /dev/urandom -o "$DEVICE"
fi
