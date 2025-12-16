#!/bin/bash

read -rp "Do you want to securely erase all data on /dev/nvme0n1? [y/N] " ERASE

if [[ "$ERASE" == [Yy] || "$ERASE" == [Yy][Ee][Ss] ]]; then
  wipefs -a "$DEVICE"
  pv /dev/urandom -o "$DEVICE"
fi
