# archluks

These are my scripts for an encrypted [Arch](https://www.archlinux.org) installation on a 64-bit UEFI NVMe drive. The scripts take a target drive, wipe it, and partition it into an EFI system and a LUKS-encrypted Linux root. The encrypted (physical) root is further partitioned into two logical volumes, swap and (logical) root. The OS is installed on the logical root and the LUKS encryption key is always required to boot into it.

The scripts allow you to specify the target drive, desired space for EFI and swap partitions, CPU make, wifi credentials, hostname, timezone, locale, and the username and password of a sudo account. You can also specify whether you want to replace all data on the target drive with pseudorandom numbers before partitioning. This can be time-consuming, but it is cryptographically more secure.

**Attention!** Partitioning the drive, even without securely erasing, requires overwriting and can result in the irrevocable loss of data. Make sure you specify the right drive when prompted. Double-check everything before proceeding and make sure you understand what the scripts are doing. I decline all responsibility for unintended losses that may result from misuse of the scripts.

The Arch installation will be a pure command-line environment with the packages [base](https://archlinux.org/packages/core/any/base/), [linux](https://archlinux.org/packages/core/x86_64/linux/), [linux-firmware](https://archlinux.org/packages/core/any/linux-firmware/), [lvm2](https://archlinux.org/packages/core/x86_64/lvm2/), [intel-ucode](https://archlinux.org/packages/extra/any/intel-ucode/) or [amd-ucode](https://archlinux.org/packages/core/any/amd-ucode/) (depending on CPU make), [sudo](https://archlinux.org/packages/core/x86_64/sudo/), [networkmanager](https://archlinux.org/packages/extra/x86_64/networkmanager/), and their dependencies. Everything else can be added afterward.

## Usage

Before installing, you should read the official [installation guide](https://wiki.archlinux.org/title/Installation_guide) and make sure you understand what the scripts are doing. You should also have a bootable installation medium, like a USB drive flashed with a [verified Arch ISO image](https://archlinux.org/download/).

After booting from the medium, you should connect to a network and download these scripts. If you have a wired connection, it should work automatically; if you don't, you can authenticate into a wifi using [iwctl](https://man.archlinux.org/man/iwctl).

```sh
iwctl station wlan0 connect <ssid> -P <password>
```

You can test your connection with `ping -c 3 archlinux.org`. If it works, download the files:

```sh
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/install.sh
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/setup.sh
```

Type `bash install.sh` to start the installation process. The script will prompt you for input. When it's done, chroot into the logical volume and run the next script:

```sh
arch-chroot /mnt
bash setup.sh
```

When it terminates, you can exit, unmount, and reboot into the OS:

```sh
exit
umount -R /mnt
reboot
```

Once into the OS, you can access the wireless network through [nmcli](https://man.archlinux.org/man/nmcli):

```sh
sudo systemctl start NetworkManager
sudo nmcli device wifi connect <ssid> password <password>
```

You can now use [pacman](https://man.archlinux.org/man/pacman) to install anything else you want. The `postinstall.sh` script installs additional software based on my needs. It is unlikely to be what you also want, but it can be a helpful reference.
