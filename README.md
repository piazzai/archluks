# archluks

These are configuration files and scripts for an encrypted Arch Linux installation. The JSON files include instructions for the [archinstall](https://archlinux.org/packages/extra/any/archinstall/) script. They assume there is a 2 TB NVMe drive at `/dev/nvme0n1`, to be wiped and partitioned into a fat32 EFI boot module and an ext4 LUKS-encrypted root. The EFI module is allocated 500 MB and the root is allocated the rest.

The script installs the systemd boot manager, enables zram, and then configures a minimal OS with display server, audio server, connection manager, and bluetooth daemons, along with all available open-source graphics drivers. The timezone is set to `Europe/London`, the system language to `en_US.UTF-8`, and the keyboard layout to `us`. All of these settings, as well as the size of EFI and root partitions, can be changed within archinstall to suit your needs.

The repo also includes a script to securely erase all data from the drive prior to installation by overwriting it with pseudorandom numbers. This can be time-consuming, taking about 12 hours for a 2 TB NVMe drive, but because old data could be recovered if it is not overwritten, running the script is cryptographically safer. Obviously, there is no need to run the script if you're just refreshing the OS.

Please be aware that wiping and partitioning the drive, with or without secure erasure, can result in the irrevocable loss of existing data. Make sure you understand what the scripts are doing and are familiar with [The Arch Way](https://principles.design/examples/the-arch-way). I decline responsibility for any unintended loss.

## Usage

Before installing, you should read the official [installation guide](https://wiki.archlinux.org/title/Installation_guide) and prepare a bootable installation medium, such as a USB drive flashed with a verified [Arch ISO image](https://archlinux.org/download/).

After booting from the medium, connect to a network to download the JSON files in this repo and (optionally) the secure erasure script. If you have a wired connection it should work automatically; if you don't, you can authenticate into a wifi using [iwctl](https://man.archlinux.org/man/iwctl).

```bash
iwctl station wlan0 connect '<your-wifi>'
```

You can test your connection with `ping -c3 archlinux.org`. If it works, download the files.

```bash
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/erase.sh
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/user_configuration.json
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/user_credentials.json
```

You should edit `user_credentials.json` to include your desired encryption password.

```bash
nano user_credentials.json
```

```json
"encryption_password": "<your-password>"
```

If you want to securely erase the drive before proceeding, then type `bash erase.sh` and answer yes to the prompt. When that process is complete, launch archinstall passing the configuration and credential files.

```bash
archinstall --config user_configuration.json --creds user_credentials.json
```

The archinstall script will read these settings and prepare the installation accordingly. Review everything to make sure this is what you need. On top of what is already set up, you only have to create a user account by going to the authentication panel, adding a new user, typing the desired username and password, and confirming. Make sure you give this user sudo privileges.

After the script finishes installing the OS, exit and reboot. The installation medium can now be removed. You'll be prompted for your encryption password and user credentials. Once you've booted into the OS, connect to the internet using [networkmanager](https://archlinux.org/packages/extra/x86_64/networkmanager/).

```bash
sudo systemctl start NetworkManager
nmcli device wifi connect '<your-wifi>' --ask
```

You can now use [pacman](https://man.archlinux.org/man/pacman) to install anything else you want. The `packages.sh` script installs additional software based on my personal preferences, then builds [yay](https://aur.archlinux.org/packages/yay) and installs some extras from the [Arch User Repository](https://aur.archlinux.org/). This particular selection of packages is unlikely to be what you want, but it can be a helpful reference.

The `setup.sh` script configures the system you've just installed by enabling key services, installing extensions, configuring peripherals, etc. This is mostly for my own use and unlikely to be helpful to anyone else.
