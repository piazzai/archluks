#!/bin/bash
set -e

# install terminal utilities
sudo pacman -S acpi fprintd git ranger reflector rsync tree sysstat vim

# configure pacman
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

# install and configure greeter
sudo pacman -S ly
sudo sed -i 's/^\(animation =\) none/\1 doom/' /etc/ly/config.ini
sudo sed -i 's/^\(clock =\) null/\1 %Y-%m-%d %H:%M:%S %Z/' /etc/ly/config.ini
sudo sed -i 's/^\(clear_password =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(initial_info_text =\) null/\1 Arch Linux/' /etc/ly/config.ini
sudo sed -i 's/^\(hide_borders =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(default_input =\) login/\1 password/' /etc/ly/config.ini

# install and enable services
sudo pacman -S pacman-contrib tlp ufw
sudo systemctl enable fstrim.timer
sudo systemctl enable ly
sudo systemctl enable NetworkManager
sudo systemctl enable paccache.timer
sudo systemctl enable tlp
sudo ufw enable

# install display server
sudo pacman -S xorg

# install color manager and download color profile
sudo pacman -S xcalib xiccd
curl -fsSLO https://www.notebookcheck.net/uploads/tx_nbc2/BOE_CQ_______NE135FBM_N41_01.icm \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0'

# apply color profile
colormgr import-profile BOE_CQ_______NE135FBM_N41_01.icm
ICM=$(colormgr get-profiles | grep -A 1 BOE | grep ID | sed 's/^.*icc/icc/')
colormgr device-add-profile xrandr-BOE "$ICM"

# install window manager and dependencies
sudo pacman -S i3 dunst dmenu xss-lock

# install audio server
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack

# install volume controls
sudo pacman -S alsa-utils pavucontrol

# install equalizer and download audio profile
sudo pacman -S easyeffects
curl -fsSLO https://github.com/FrameworkComputer/linux-docs/raw/refs/heads/main/easy-effects/fw13-easy-effects.json

# install terminal emulator
sudo pacman -S alacritty

# install ruby bundler and gems
sudo pacman -S ruby-bundler
gem install --user-install jekyll
gem install --user-install neocities

# install texlive
sudo pacman -S texlive

# install r and packages
sudo pacman -S r
RLIBS="Sys.getenv('R_LIBS_USER')"
CRAN="c(CRAN = 'https://cran.r-project.org')"
R -e "dir.create(path = $RLIBS, showWarnings = FALSE, recursive = TRUE)"
R -e "install.packages('languageserver', lib = $RLIBS, repos = $CRAN)"
R -e "install.packages('tidyverse', lib = $RLIBS, repos = $CRAN)"
R -e "install.packages('renv', lib = $RLIBS, repos = $CRAN)"

# install vscodium and extensions
yay -S vscodium-bin
codium --install-extension James-Yu.latex-workshop
codium --install-extension jeanp413.open-remote-ssh
codium --install-extension REditorSupport.r

# install aur helper
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay

# install vpn software
yay -S mullvad-vpn-bin globalprotect-openconnect-git
mullvad tunnel set wireguard --daita on
mullvad relay set tunnel wireguard --use-multihop on
mullvad auto-connect set on
mullvad dns set default --block-ads --block-trackers --block-malware
mullvad relay set location ch

# initialize git lfs
sudo pacman -S git-lfs
git lfs install

# install image viewer
sudo pacman -S viewnior

# install media player
sudo pacman -S vlc

# install office suite
yay -S onlyoffice-bin

# install keepass and cryptomator
sudo pacman -S keepassxc
yay -S cryptomator-bin

# install signal
sudo pacman -S signal-desktop

# install web browser and mail client
yay -s mullvad-browser-bin ungoogled-chromium-bin
sudo pacman -S thunderbird

# install graphics software
sudo pacman -S gimp inkscape

# install spotify
sudo pacman -S spotify-launcher

# install fira fonts
sudo pacman -S nerd-fonts

# enable tap to click
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee << 'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf > /dev/null
Section "InputClass"
  Identifier "touchpad"
  MatchIsTouchpad "on"
  Driver "libinput"
  Option "Tapping" "on"
EndSection
EOF
