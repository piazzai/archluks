#!/bin/bash
set -e

# install terminal utilities
sudo pacman -S acpi
sudo pacman -S fastfetch
sudo pacman -S feh
sudo pacman -S fprintd
sudo pacman -S git
sudo pacman -S git-lfs
sudo pacman -S github-cli
sudo pacman -S maim
sudo pacman -S micro
sudo pacman -S net-tools
sudo pacman -S openssh
sudo pacman -S reflector
sudo pacman -S rsync
sudo pacman -S sysstat
sudo pacman -S tree
sudo pacman -S udisks2

# install aur helper
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay

# configure pacman
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

# enable pacman mirror optimization
sudo systemctl enable reflector.timer

# install, configure, and enable greeter
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

# enable file system trimming
sudo systemctl enable fstrim.timer

# enable network manager
sudo systemctl enable NetworkManager

# install and enable pacman cache clearing
sudo pacman -S pacman-contrib
sudo systemctl enable paccache.timer

# install and enable battery saver
sudo pacman -S tlp
sudo systemctl enable tlp

# install and enable bluetooth
sudo pacman -S bluez
sudo pacman -S bluez-utils
sudo systemctl enable bluetooth.service

# enable openssh agent
systemctl --user enable ssh-agent.service
systemctl --user start ssh-agent.service

# install and enable firewall
sudo pacman -S ufw
sudo ufw enable

# install antivirus and enable updating
sudo pacman -S clamav
sudo freshclam
sudo touch /var/log/clamav/freshclam.log
sudo chown clamav:clamav /var/log/clamav/freshclam.log
sudo systemctl enable clamav-freshclam

# install and configure vpn
yay -S mullvad-vpn-bin
mullvad auto-connect set on
mullvad tunnel set wireguard --daita on
mullvad relay set ownership owned
mullvad relay set tunnel wireguard --use-multihop on
mullvad dns set default --block-ads --block-trackers --block-malware
mullvad relay set location ch

# install display server
sudo pacman -S xcalib
sudo pacman -S xclip
sudo pacman -S xdotool
sudo pacman -S xiccd
sudo pacman -S xorg

# download color profile
curl -fsSLO https://www.notebookcheck.net/uploads/tx_nbc2/BOE_CQ_______NE135FBM_N41_01.icm \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0'

# install window manager
sudo pacman -S i3
sudo pacman -S dunst
sudo pacman -S dmenu
sudo pacman -S rofi

# install compositor
sudo pacman -S picom

# install system monitor
sudo pacman -S bottom

# install audio server
sudo pacman -S pipewire
sudo pacman -S pipewire-alsa
sudo pacman -S pipewire-pulse
sudo pacman -S pipewire-jack

# install volume controls
sudo pacman -S alsa-utils
sudo pacman -S pavucontrol

# install audio equalizer
sudo pacman -S easyeffects

# download audio profile
curl -fsSLO https://github.com/FrameworkComputer/linux-docs/raw/refs/heads/main/easy-effects/fw13-easy-effects.json

# install brightness manager
sudo pacman -S brightnessctl

# install terminal emulator
sudo pacman -S alacritty

# install ruby bundler and gems
sudo pacman -S ruby
sudo pacman -S ruby-bundler
gem install --user-install jekyll

# install npm
sudo pacman -S nodejs
sudo pacman -S npm

# install texlive and dependencies
sudo pacman -S texlive
sudo pacman -S texlive-langgreek
sudo pacman -S perl-yaml-tiny
sudo pacman -S perl-file-homedir

# install pandoc
yay -S pandoc-bin

# install dbeaver
sudo pacman -S dbeaver

# install uv
sudo pacman -S uv

# install docker, enable service, and add user to docker group
sudo pacman -S docker docker-compose
sudo systemctl enable docker
sudo usermod -aG docker "$USER"

# install r and packages
sudo pacman -S r
sudo pacman -S gcc-fortran
R -e "dir.create(path = Sys.getenv('R_LIBS_USER'), showWarnings = FALSE, recursive = TRUE)"
R -e "install.packages('languageserver', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"
R -e "install.packages('renv', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"

# install vscodium and extensions
yay -S vscodium-bin
codium --install-extension James-Yu.latex-workshop
codium --install-extension ms-python.python
codium --install-extension REditorSupport.r
codium --install-extension timonwong.shellcheck
codium --install-extension yzhang.markdown-all-in-one

# install network editor
sudo pacman -S nm-connection-editor

# install disk manager
sudo pacman -S gnome-disk-utility

# install keyring
sudo pacman -S gnome-keyring
sudo pacman -S libsecret
sudo pacman -S seahorse

# install bluetooth manager
sudo pacman -S blueman

# install printer software
sudo pacman -S cups
sudo pacman -s hplip
sudo pacman -S system-config-printer

# configure printer
sudo hp-setup -i

# install text editor
sudo pacman -S mousepad
gsettings set org.xfce.mousepad.preferences.view font-name 'Monaspace Radon 10'
gsettings set org.xfce.mousepad.preferences.view auto-indent true

# install keepass and cryptomator
sudo pacman -S keepassxc
yay -S cryptomator-cli

# install file manager
sudo pacman -S gvfs
sudo pacman -S thunar
sudo pacman -S xarchiver

# install pdf viewer
sudo pacman -S mupdf-gl

# install image viewer
sudo pacman -S viewnior

# install media player
sudo pacman -S vlc
sudo pacman -S vlc-plugins-ffmpeg

# install character map
sudo pacman -S gucharmap

# install document scanner
sudo pacman -S simple-scan

# install office suite
sudo pacman -S libreoffice-fresh

# install signal
sudo pacman -S signal-desktop

# install browsers and mail client
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
yay -S mullvad-browser-bin
yay -S ungoogled-chromium-bin
sudo pacman -S evolution
sudo pacman -S evolution-ews

# install graphics software
sudo pacman -S gimp
sudo pacman -S inkscape
sudo pacman -S imagemagick

# install dropbox
yay -S dropbox

# install spotify client
yay -S spotify

# install typefaces
sudo pacman -S noto-fonts
sudo pacman -S noto-fonts-cjk
sudo pacman -S noto-fonts-emoji
sudo pacman -S noto-fonts-extra
sudo pacman -S otf-monaspace
sudo pacman -S ttf-nerd-fonts-symbols
sudo pacman -S ttf-nerd-fonts-symbols-mono

# enable tap to click
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee << 'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf > /dev/null
Section "InputClass"
  Identifier "touchpad"
  Driver "libinput"
  MatchIsTouchpad "on"
  Option "Tapping" "on"
EndSection
EOF

# enable usevia.app configuration of peripherals
sudo tee << 'EOF' /etc/udev/rules.d/99-keychron.rules > /dev/null
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="wheel", TAG+="uaccess", TAG+="udev-acl"
EOF
sudo tee << 'EOF' /etc/udev/rules.d/99-ploopy.rules > /dev/null
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="5043", ATTRS{idProduct}=="5c47", MODE="0660", GROUP="wheel", TAG+="uaccess", TAG+="udev-acl"
EOF
sudo udevadm control --reload-rules
sudo udevadm trigger

# after rebooting and restoring home

sudo cp BOE_CQ_______NE135FBM_N41_01.icm /usr/share/color/icc/colord/
colormgr device-add-profile xrandr-BOE "$(colormgr get-profiles | grep -A 1 BOE | grep ID | sed 's/^.*icc/icc/')"
