# archluks

These are my shell scripts for an encrypted [Arch](https://www.archlinux.org) installation on a 64-bit UEFI system on a NVMe drive. The `archluks.sh` script takes a target drive, wipes it, and partitions it into an EFI system and a LUKS-encrypted Linux filesystem. It then further partitions the encrypted filesystem into two logical volumes, swap and root, and installs the OS. The encryption key set during this process will be required every time the user boots into the OS.

The `config.ini` file allows you to specify the target drive, space for EFI and swap, CPU make, wifi credentials, hostname, timezone, locale, and the username and password of a sudo account. You can also specify whether you want to overwrite all data on the target drive with pseudorandom numbers before partitioning. Depending on the size of the drive, this option can be time-consuming, but it is cryptographically more secure because old data may be readable otherwise.

> Attention! Partitioning the drive, with or without overwriting, can result in the irrevocable loss of data. Make sure you specify the right drive in `config.ini`. Proceed with caution and make sure you understand what the scripts are doing. I decline all responsibility for unintended losses that may result.

The Arch installation will be a pure command-line environment with the packages [base](https://archlinux.org/packages/core/any/base/), [linux](https://archlinux.org/packages/core/x86_64/linux/), [linux-firmware](https://archlinux.org/packages/core/any/linux-firmware/), [lvm2](https://archlinux.org/packages/core/x86_64/lvm2/), [intel-ucode](https://archlinux.org/packages/extra/any/intel-ucode/) or [amd-ucode](https://archlinux.org/packages/core/any/amd-ucode/) (depending on CPU make), [sudo](https://archlinux.org/packages/core/x86_64/sudo/), [networkmanager](https://archlinux.org/packages/extra/x86_64/networkmanager/), and their dependencies. Everything else can be added afterward.

## Usage

Before installing, you should read the official [installation guide](https://wiki.archlinux.org/title/Installation_guide) and make sure you understand what the scripts are doing. You should also have a bootable installation medium.

In order to use these scripts after booting from the medium, you should connect to a network and download them. If you have a wired connection, it should work automatically; if you don't, you can authenticate into a wifi using [iwctl](https://man.archlinux.org/man/iwctl).

```sh
iwctl station wlan0 connect <wifi-name> -P <wifi-password>
```

You can test your connection with `ping -c 3 archlinux.org`. If it works, download the repository and access the scripts:

```sh
wget https://github.com/piazzai/archluks/archive/refs/heads/master.zip
unzip master.zip
cd archluks-master
```

You can use [nano](https://man.archlinux.org/man/nano) to open `config.ini` and edit it according to your needs. When you are ready, type `bash archluks.sh` to start the installation process. The script will prompt you for an encryption key and will automatically reboot at the end, allowing you to disconnect the installation medium and boot into the OS.

After typing the encryption key and logging in with your username and password, access the wireless network through [nmcli](https://man.archlinux.org/man/nmcli):

```sh
sudo systemctl start NetworkManager
sudo nmcli device wifi connect <wifi-name> password <wifi-password>
```

You can now use [pacman](https://man.archlinux.org/man/pacman) to install whatever you need. The script `custom.sh` scripts installs additional software according to my own needs and preferences.
