# archluks

These are my scripts for an encrypted [Arch](https://www.archlinux.org) installation on a 64-bit UEFI system. The scripts expect a NVMe drive in Channel 0 (`/dev/nvme0n1`), which is wiped and partitioned into an EFI system and a LUKS-encrypted physical root. The physical root is further partitioned into two logical volumes, swap and root. The OS is installed on the logical root and the encryption key is always required to boot into it.

The scripts require you to specify the desired size of the EFI and swap partitions, allocating all remaining space to the logical root. They also require you to specify the username and password of a sudo account. You are also given the option to securely erase all data from the target drive by overwriting it with pseudorandom numbers. Depending on the size of the drive, this option can be time-consuming, but because old data could be readable if not overwritten it is cryptographically safer.

**Attention!** Partitioning the drive, even without securely erasing, requires overwriting existing data and can result in irrevocable loss. Make sure you have the right drive in Channel 0. Make sure you understand what the scripts are doing and double-check everything before running them. I decline responsibility for any unintended losses caused by your use of these scripts.

The Arch installation will be a pure command-line environment with the packages [base](https://archlinux.org/packages/core/any/base/), [linux](https://archlinux.org/packages/core/x86_64/linux/), [linux-firmware](https://archlinux.org/packages/core/any/linux-firmware/), [lvm2](https://archlinux.org/packages/core/x86_64/lvm2/), [intel-ucode](https://archlinux.org/packages/extra/any/intel-ucode/) or [amd-ucode](https://archlinux.org/packages/core/any/amd-ucode/) (depending on CPU make), [sudo](https://archlinux.org/packages/core/x86_64/sudo/), [networkmanager](https://archlinux.org/packages/extra/x86_64/networkmanager/), and their dependencies. Everything else can be added afterward.

## Usage

Before installing, you should read the official [installation guide](https://wiki.archlinux.org/title/Installation_guide) and prepare a bootable installation medium, such as a USB drive flashed with a [verified Arch ISO image](https://archlinux.org/download/).

After booting from the medium, connect to a network to download the install script. If you have a wired connection it should work automatically; if you don't, you can authenticate into a wifi using [iwctl](https://man.archlinux.org/man/iwctl).

```sh
iwctl station wlan0 connect your-wifi
```

You can test your connection with `ping -c 3 archlinux.org`. If it works, download the script:

```sh
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/install.sh
```

Type `bash install.sh` to start the installation process. You will be prompted for input and encryption passwords. When it's done, chroot into the logical volume to download and run the next script:

```sh
arch-chroot /mnt
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/setup.sh
bash setup.sh
```

When it terminates, you can remove the script, exit, unmount, and reboot into the OS:

```sh
rm setup.sh
exit
umount -R /mnt
reboot
```

Once into the OS, you can access the wireless network through [nmcli](https://man.archlinux.org/man/nmcli):

```sh
sudo systemctl start NetworkManager
sudo nmcli device wifi connect your-wifi --ask-password
```

You can now use [pacman](https://man.archlinux.org/man/pacman) to install anything else you want. The `custom.sh` script installs additional software based on my needs, which is unlikely to be what you also want, but can be a helpful reference.
