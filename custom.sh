#!/bin/bash
set -e

# install terminal utilities
sudo pacman -S fprintd git github-cli nano rsync reflector

# configure pacman
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i '/^Color/a ILoveCandy' pacman.conf

# install and configure greeter
sudo pacman -S ly
sudo sed -i 's/^\(animation =\) none/\1 doom/' /etc/ly/config.ini
sudo sed -i 's/^\(clock =\) null/\1 %Y-%m-%d %H:%M %Z/' /etc/ly/config.ini
sudo sed -i 's/^\(clear_password =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(initial_info_text =\) null/\1 Arch Linux/' /etc/ly/config.ini
sudo sed -i 's/^\(hide_borders =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(default_input =\) login/\1 password/' /etc/ly/config.ini

# enable services
sudo pacman -S pacman-contrib tlp
sudo systemctl enable fstrim.timer
sudo systemctl enable ly
sudo systemctl enable NetworkManager
sudo systemctl enable paccache.timer
sudo systemctl enable tlp

# enable firewall
sudo pacman -S ufw gufw
sudo ufw enable

# install aur helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# install vpn software
yay -S mullvad-vpn-bin globalprotect-openconnect-git

# initialize git lfs
sudo pacman -S git-lfs
git lfs install

# install desktop environment
sudo pacman -S gvfs network-manager-applet nm-connection-editor pavucontrol pipewire-pulse xfce4 xfce4-battery-plugin xfce4-notes-plugin xfce4-notifyd xfce4-places-plugin xfce4-pulseaudio-plugin xfce4-screensaver xfce4-screenshooter xfce4-sensors-plugin xfce4-taskmanager xfce4-whiskermenu-plugin xorg-server
yay -S menulibre mugshot

# install text editor
sudo pacman -S vim

# install image viewer
sudo pacman -S viewnior

# install media player
sudo pacman -S vlc pipewire-jack

# install office suite
sudo pacman -S libreoffice-fresh

# install color manager and download color profile
sudo pacman -S xcalib xiccd
curl -fsSLO https://www.notebookcheck.net/uploads/tx_nbc2/BOE_CQ_______NE135FBM_N41_01.icm \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0'

# install equalizer and download audio profile
sudo pacman -S easyeffects
curl -fsSLO https://github.com/FrameworkComputer/linux-docs/raw/refs/heads/main/easy-effects/fw13-easy-effects.json

# install ruby, bundler, and gems
sudo pacman -S ruby ruby-bundler
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
codium --install-extension reditorsupport.r

# install keepass and cryptomator
sudo pacman -S keepassxc
yay -S cryptomator-bin

# install signal
sudo pacman -S signal-desktop

# install web browser and mail client
sudo pacman -S firefox thunderbird

# install graphics editors
sudo pacman -S gimp inkscape

# install spotify
sudo pacman -S spotify-launcher

# install dropbox
sudo pacman -S python-gpgme
yay -S dropbox
install -dm0 .dropbox-dist
yay -S thunar-dropbox

# set bash variables
printf '%s\n' '' '# Add GPG_TTY for gh authentication' "export GPG_TTY=\$(tty)" \
  '' '# Make user-installed gems executable' "export PATH=\$PATH:\$(ruby -e 'puts Gem.user_dir')/bin" \
  '' '# Include custom scripts' "export PATH=\$HOME/.bin:\$PATH" >> ~/.bashrc
