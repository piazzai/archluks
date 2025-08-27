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
sudo pacman -S nano
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

# install and update antivirus
sudo pacman -S clamav
sudo freshclam

# install and configure vpn
yay -S mullvad-vpn-bin
mullvad auto-connect set on
mullvad tunnel set wireguard --daita on
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
#sudo cp BOE_CQ_______NE135FBM_N41_01.icm /usr/share/color/icc/colord/
#colormgr device-add-profile xrandr-BOE "$(colormgr get-profiles | grep -A 1 BOE | grep ID | sed 's/^.*icc/icc/')"

# install window manager
sudo pacman -S i3
sudo pacman -S dunst
sudo pacman -S dmenu
sudo pacman -S rofi

# install compositor
sudo pacman -S picom

# install system monitor
sudo pacman -S btop

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

# install texlive
sudo pacman -S texlive
sudo pacman -S texlive-langgreek

# install conda
yay -S miniconda3

# install r and packages
sudo pacman -S r
sudo pacman -S gcc-fortran
R -e "dir.create(path = Sys.getenv('R_LIBS_USER'), showWarnings = FALSE, recursive = TRUE)"
R -e "install.packages('languageserver', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"
R -e "install.packages('renv', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"

# install vscodium and extensions
sudo pacman -S perl-yaml-tiny
sudo pacman -S perl-file-homedir
yay -S vscodium-bin
codium --install-extension James-Yu.latex-workshop
codium --install-extension ms-python.python
codium --install-extension REditorSupport.r
codium --install-extension timonwong.shellcheck

# install network editor
sudo pacman -S nm-connection-editor

# install disk manager
sudo pacman -S gnome-disk-utility

# install keepass and cryptomator
sudo pacman -S keepassxc
yay -S cryptomator-bin

# install file manager
sudo pacman -S gvfs
sudo pacman -S spf
sudo pacman -S thunar
sudo pacman -S xarchiver

# install text editor
sudo pacman -S l3afpad

# install pdf viewer
sudo pacman -S mupdf-gl

# install image viewer
sudo pacman -S viewnior

# install media player
sudo pacman -S vlc
sudo pacman -S vlc-plugins-all

# install character map
sudo pacman -S gucharmap

# install document scanner
sudo pacman -S simple-scan

# install office suite
sudo pacman -S libreoffice-fresh

# install signal
sudo pacman -S signal-desktop

# install web browser and mail client
sudo pacman -S firefox
sudo pacman -S thunderbird

# install graphics software
sudo pacman -S gimp
sudo pacman -S inkscape
sudo pacman -S imagemagick

# install dropbox
yay -S dropbox
yay -S dropbox-cli

# install spotify client
yay -S spotify

# install typefaces
sudo pacman -S noto-fonts
sudo pacman -S noto-fonts-cjk
sudo pacman -S noto-fonts-emoji
sudo pacman -S ttf-liberation
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
