# archluks

These are my scripts for an encrypted [Arch](https://www.archlinux.org) installation on a 64-bit UEFI NVMe drive. The scripts take a target drive, wipe it, and partition it into an EFI system and a LUKS-encrypted Linux root. The encrypted (physical) root is further partitioned into two logical volumes, swap and (logical) root. The OS is installed on the logical root and the LUKS encryption key is always required to boot into it.

The `config.ini` file allows you to specify the target drive, desired space for EFI and swap, CPU make, wifi credentials, hostname, timezone, locale, and the username and password of a sudo account. You can also specify whether you want to overwrite all data on the target drive with pseudorandom numbers before partitioning. This can be time-consuming, but it is cryptographically more secure.

**Attention!** Partitioning the drive, with or without overwriting, can result in the irrevocable loss of data. Make sure you specify the right drive the configuration file. Double-check everything and make sure you understand what the scripts are doing. I decline all responsibility for unintended losses that may result from misuse.

The Arch installation will be a pure command-line environment with the packages [base](https://archlinux.org/packages/core/any/base/), [linux](https://archlinux.org/packages/core/x86_64/linux/), [linux-firmware](https://archlinux.org/packages/core/any/linux-firmware/), [lvm2](https://archlinux.org/packages/core/x86_64/lvm2/), [intel-ucode](https://archlinux.org/packages/extra/any/intel-ucode/) or [amd-ucode](https://archlinux.org/packages/core/any/amd-ucode/) (depending on CPU make), [sudo](https://archlinux.org/packages/core/x86_64/sudo/), [networkmanager](https://archlinux.org/packages/extra/x86_64/networkmanager/), and their dependencies. Everything else can be added afterward.

## Usage

Before installing, you should read the official [installation guide](https://wiki.archlinux.org/title/Installation_guide) and make sure you understand what the scripts are doing. You should also have a bootable installation medium, like a USB drive flashed with a [verified Arch ISO image](https://archlinux.org/download/).

After booting from the medium, you should connect to a network and download these scripts. If you have a wired connection, it should work automatically; if you don't, you can authenticate into a wifi using [iwctl](https://man.archlinux.org/man/iwctl).

```sh
iwctl station wlan0 connect "your-wifi" -P "wifi-password"
```

You can test your connection with `ping -c 3 archlinux.org`. If it works, download the repository:

```sh
curl -fsSLO https://raw.githubusercontent.com/piazzai/archluks/refs/heads/master/archluks.sh
curl -fsSLO https://raw.githubusercontent.com/piazzai/archluks/refs/heads/master/chroot.sh
curl -fsSLO https://raw.githubusercontent.com/piazzai/archluks/refs/heads/master/config.ini
```

You can use [nano](https://man.archlinux.org/man/nano) to open `config.ini` and edit it according to your needs. When you are ready, type `bash archluks.sh` to start the installation process. The script will automatically reboot at the end, allowing you to disconnect the installation medium and boot into the OS.

Once into the OS, you can access the wireless network through [nmcli](https://man.archlinux.org/man/nmcli):

```sh
sudo systemctl start NetworkManager
sudo nmcli device wifi connect "your-wifi" password "wifi-password"
```

You can now use [pacman](https://man.archlinux.org/man/pacman) to install anything else you need. The `custom.sh` script installs additional software based on my tastes and workflow. This is most likely not what you need, but it can be a helpful reference.
