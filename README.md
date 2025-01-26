# archluks

These are my scripts for an encrypted [Arch](https://www.archlinux.org) installation on a 64-bit UEFI system. The scripts take a target NVMe drive, wipe it, and partition it into an EFI boot and a LUKS-encrypted physical root. The physical root is further partitioned into two logical volumes, swap and (logical) root. The OS is installed on the logical root and the encryption key set during installation is always required for booting.

The scripts require you to specify a target drive and the desired size of EFI and swap partitions. All remaining space on the drive is allocated to the logical root. You are also given the option to securely erase all data from the drive by overwriting it with pseudorandom numbers. Depending on the size of the device this can be time-consuming, but because old data could be recoverable otherwise it is cryptographically safer.

Partitioning the drive, even without opting for secure erasure, can result in the irrevocable loss of existing data. Make sure you target the right drive and understand what the scripts are doing. Double-check everything. I decline responsibility for any unintended loss caused by these scripts.

The Arch installation will be a pure command-line environment with the packages [base](https://archlinux.org/packages/core/any/base/), [intel-ucode](https://archlinux.org/packages/extra/any/intel-ucode/), [linux](https://archlinux.org/packages/core/x86_64/linux/), [linux-firmware](https://archlinux.org/packages/core/any/linux-firmware/), [lvm2](https://archlinux.org/packages/core/x86_64/lvm2/), [networkmanager](https://archlinux.org/packages/extra/x86_64/networkmanager/), [sudo](https://archlinux.org/packages/core/x86_64/sudo/), and their dependencies. Everything else can be added later.

## Usage

Before installing, you should read the official [installation guide](https://wiki.archlinux.org/title/Installation_guide) and prepare a bootable installation medium, such as a USB drive flashed with a [verified Arch ISO image](https://archlinux.org/download/).

After booting from the medium, connect to a network to download the install script. If you have a wired connection it should work automatically; if you don't, you can authenticate into a wifi using [iwctl](https://man.archlinux.org/man/iwctl).

```sh
iwctl station wlan0 connect your-wifi
```

You can test your connection with `ping -c3 archlinux.org`. If it works, download the script and run it.

```sh
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/install.sh
bash install.sh
```

You will be prompted for input and encryption keys. When execution terminates, chroot into the logical volume to download and run the next script.

```sh
arch-chroot /mnt
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/chroot.sh
bash chroot.sh
```

When it terminates, you can remove the script, exit, unmount, and reboot into the OS.

```sh
rm chroot.sh
exit
umount -R /mnt
reboot
```

Once into the OS, you can access the wireless network through [nmcli](https://man.archlinux.org/man/nmcli).

```sh
sudo systemctl start NetworkManager
sudo nmcli device wifi connect your-wifi --ask
```

You can now use [pacman](https://man.archlinux.org/man/pacman) to install anything else you want. The `custom.sh` script installs additional software based on my needs, which is unlikely to be what you want, but it can be a helpful reference.
