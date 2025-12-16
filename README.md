# archluks

These are my configuration files and scripts for an encrypted Arch Linux installation. The files `user_configuration.json` and `user_credentials.json` include settings for the [archinstall](https://archlinux.org/packages/extra/any/archinstall/) script. These files instruct the script to take a 2 TB NVMe drive at `/dev/nvme0n1`, wipe it, and partition it into a fat32 EFI boot module and an ext4 LUKS-encrypted root module. The EFI module size is set to 500 MB and the root partition takes all remaining space.

The script installs systemd-boot as the boot manager, enables zram, and then installs and configures a X11 display server, a pipewire server, bluetooth daemons, a connection manager, and bluetooth daemons, along with all open-source graphics drivers. It also sets the timezone to `Europe/London`, the system language to `en_US.UTF-8`, and the keyboard layout to `us`.

There is also a script to securely erase all data from the drive by overwriting it with pseudorandom numbers prior to installation. This can be time-consuming, but because old data could be recovered if not overwritten, it is cryptographically safer.

Please be aware that wiping and partitioning the drive, with or without secure erasure, can result in the irrevocable loss of existing data. Make sure you understand what the scripts are doing. _I decline responsibility for any unintended loss caused by these scripts._

## Usage

Before installing, you should read the official [installation guide](https://wiki.archlinux.org/title/Installation_guide) and prepare a bootable installation medium, such as a USB drive flashed with a [verified Arch ISO image](https://archlinux.org/download/).

After booting from the medium, connect to a network to download the json files and (optionally) the secure erasure script. If you have a wired connection it should work automatically; if you don't, you can authenticate into a wifi using [iwctl](https://man.archlinux.org/man/iwctl).

```bash
iwctl station wlan0 connect '<your-wifi>'
```

You can test your connection with `ping -c3 archlinux.org`. If it works, download the files and edit `user_credentials.json`.

```bash
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/erase.sh # optional
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/user_configuration.json
curl -fsSLO https://github.com/piazzai/archluks/raw/refs/heads/master/user_credentials.json
nano user_credentials.json
```

Write your desired encryption password in double quotes after the colon.

```json
"encryption_password": "<your-password>"
```

If you want to securely wipe the drive before proceeding, then run `erase.sh`. Then, start archinstall and pass the configuration and credential files.

```bash
archinstall --config user_configuration.json --creds user_credentials.json
```

The script will read these settings and prepare the installation accordingly. You only have to create a sudo user by going to the authentication panel, adding a new user, and confirming. You'll be prompted for a username and password.

After the script finishes, exit archinstall and reboot. The installation medium can be removed at this point. Once you've booted into the new OS, connect to the internet using [networkmanager](https://archlinux.org/packages/extra/x86_64/networkmanager/).

```bash
sudo systemctl start NetworkManager
nmcli device wifi connect '<your-wifi>' --ask
```

You can now use [pacman](https://man.archlinux.org/man/pacman) to install anything else you want. The `packages.sh` script installs additional software based on my needs, builds [yay](https://aur.archlinux.org/packages/yay), and then installs some additional software from AUR. This selection of packages is unlikely to be what you want, but it can be a helpful reference.

The `setup.sh` script configures the system you've just installed by enabling key services, installing extensions, etc. This is mostly for my own reference and very unlikely to be useful to anyone else.
