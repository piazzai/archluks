#!/bin/bash
set -e

# firewall
sudo pacman -S ufw
sudo ufw enable

# aur helper
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay

# vpn
yay -S mullvad-vpn-bin
mullvad auto-connect set on
mullvad tunnel set wireguard --daita on
mullvad relay set ownership owned
mullvad relay set tunnel wireguard --use-multihop on
mullvad dns set default --block-ads --block-trackers --block-malware
mullvad relay set location ch
mullvad lan set allow

# pacman
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
sudo pacman -S reflector
sudo systemctl enable reflector.timer
sudo pacman -S pacman-contrib
sudo systemctl enable paccache.timer

# hardware information
sudo pacman -S acpi
sudo pacman -S fastfetch
sudo pacman -S sysstat

# fingerprint reader
sudo pacman -S fprintd

# git utilities
sudo pacman -S git
sudo pacman -S git-lfs
sudo pacman -S github-cli

# screenshot utility
sudo pacman -S maim

# text editor
sudo pacman -S micro
sudo pacman -S mousepad

# greeter
sudo pacman -S ly
sudo sed -i 's/^\(animation =\) none/\1 doom/' /etc/ly/config.ini
sudo sed -i 's/^\(brightness_down_key =\) F5/\1 null/' /etc/ly/config.ini
sudo sed -i 's/^\(brightness_up_key =\) F6/\1 null/' /etc/ly/config.ini
sudo sed -i 's/^\(clear_password =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(clock =\) null/\1 %Y-%m-%d %H:%M:%S %Z/' /etc/ly/config.ini
sudo sed -i 's/^\(default_input =\) login/\1 password/' /etc/ly/config.ini
sudo sed -i 's/^\(hide_borders =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(initial_info_text =\) null/\1 arch linux/' /etc/ly/config.ini
sudo systemctl enable ly

# file system trimming
sudo systemctl enable fstrim.timer

# network manager
sudo systemctl enable NetworkManager

# battery saver
sudo pacman -S tlp
sudo systemctl enable tlp

# bluetooth
sudo pacman -S blueman
sudo pacman -S bluez
sudo pacman -S bluez-utils
sudo systemctl enable bluetooth.service

# openssh agent
sudo pacman -S openssh
systemctl --user enable ssh-agent.service
systemctl --user start ssh-agent.service

# antivirus
sudo pacman -S clamav
sudo freshclam
sudo touch /var/log/clamav/freshclam.log
sudo chown clamav:clamav /var/log/clamav/freshclam.log
sudo systemctl enable clamav-freshclam

# display server
sudo pacman -S xcalib
sudo pacman -S xclip
sudo pacman -S xdotool
sudo pacman -S xiccd
sudo pacman -S xorg

# window manager
sudo pacman -S i3
sudo pacman -S dunst
sudo pacman -S dmenu
sudo pacman -S rofi

# compositor
sudo pacman -S picom

# system monitor
sudo pacman -S bottom
sudo pacman -S resources

# audio server
sudo pacman -S pipewire
sudo pacman -S pipewire-alsa
sudo pacman -S pipewire-pulse
sudo pacman -S pipewire-jack

# volume controls
sudo pacman -S alsa-utils
sudo pacman -S pavucontrol

# audio equalizer
sudo pacman -S easyeffects

# color and audio profiles
curl -fsSLO https://www.notebookcheck.net/uploads/tx_nbc2/BOE_CQ_______NE135FBM_N41_01.icm \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0'
curl -fsSLO https://github.com/FrameworkComputer/linux-docs/raw/refs/heads/main/easy-effects/fw13-easy-effects.json

# brightness manager
sudo pacman -S brightnessctl

# terminal emulator
sudo pacman -S alacritty

# ruby and gems
sudo pacman -S ruby
sudo pacman -S ruby-bundler
sudo pacman -S ruby-erb
gem install --user-install jekyll

# npm
sudo pacman -S nodejs
sudo pacman -S npm

# tex
sudo pacman -S texlive
sudo pacman -S texlive-langgreek
sudo pacman -S perl-yaml-tiny
sudo pacman -S perl-file-homedir

# pandoc
sudo pacman -S pandoc

# dbeaver
sudo pacman -S dbeaver

# uv
sudo pacman -S uv

# docker
sudo pacman -S docker
sudo pacman -S docker-compose
sudo systemctl enable docker
sudo usermod -aG docker "$USER"

# r
sudo pacman -S r
sudo pacman -S gcc-fortran
R -e "dir.create(path = Sys.getenv('R_LIBS_USER'), showWarnings = FALSE, recursive = TRUE)"
R -e "install.packages('languageserver', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"
R -e "install.packages('renv', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"

# vscodium
yay -S vscodium-bin
codium --install-extension foam.foam-vscode
codium --install-extension James-Yu.latex-workshop
codium --install-extension ms-python.python
codium --install-extension REditorSupport.r
codium --install-extension timonwong.shellcheck
codium --install-extension yzhang.markdown-all-in-one

# network tools
sudo pacman -S net-tools
sudo pacman -S nm-connection-editor

# disk managers
sudo pacman -S udisks2
sudo pacman -S gnome-disk-utility

# keyring
sudo pacman -S gnome-keyring
sudo pacman -S libsecret
sudo pacman -S seahorse

# monitor manager
sudo pacman -S arandr

# printer
sudo pacman -S cups
sudo pacman -s hplip
sudo pacman -S system-config-printer
sudo hp-setup -i

# password manager
sudo pacman -S keepassxc

# cryptomator
yay -S cryptomator-cli

# file management
sudo pacman -S gvfs
sudo pacman -S rsync
sudo pacman -S thunar
sudo pacman -S tree
sudo pacman -S xarchiver

# pdf viewer
sudo pacman -S mupdf-gl

# image viewers
sudo pacman -S feh
sudo pacman -S viewnior

# media player
sudo pacman -S vlc
sudo pacman -S vlc-plugins-ffmpeg

# character map
sudo pacman -S gucharmap

# scanner
sudo pacman -S simple-scan

# office suite
sudo pacman -S libreoffice-fresh

# signal
sudo pacman -S signal-desktop

# browsers and mail
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
yay -S davmail
yay -S mullvad-browser-bin
yay -S ungoogled-chromium-bin
sudo pacman -S thunderbird

# graphics
sudo pacman -S gimp
sudo pacman -S inkscape
sudo pacman -S imagemagick

# dropbox
yay -S dropbox

# spotify
yay -S spotify

# typefaces
sudo pacman -S noto-fonts
sudo pacman -S noto-fonts-cjk
sudo pacman -S noto-fonts-emoji
sudo pacman -S ttc-iosevka
sudo pacman -S ttc-iosevka-aile
sudo pacman -S ttc-iosevka-etoile
sudo pacman -S ttc-iosevka-slab
sudo pacman -S ttf-nerd-fonts-symbols
sudo pacman -S ttf-nerd-fonts-symbols-mono

# tap to click
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee << 'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf > /dev/null
Section "InputClass"
  Identifier "touchpad"
  Driver "libinput"
  MatchIsTouchpad "on"
  Option "Tapping" "on"
EndSection
EOF

# usevia.app configuration
sudo tee << 'EOF' /etc/udev/rules.d/99-keychron.rules > /dev/null
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="wheel", TAG+="uaccess", TAG+="udev-acl"
EOF
sudo tee << 'EOF' /etc/udev/rules.d/99-ploopy.rules > /dev/null
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="5043", ATTRS{idProduct}=="5c47", MODE="0660", GROUP="wheel", TAG+="uaccess", TAG+="udev-acl"
EOF
sudo udevadm control --reload-rules
sudo udevadm trigger

# post-reboot
# sudo cp BOE_CQ_______NE135FBM_N41_01.icm /usr/share/color/icc/colord/
# colormgr device-add-profile xrandr-BOE "$(colormgr get-profiles | grep -A 1 BOE | grep ID | sed 's/^.*icc/icc/')"
