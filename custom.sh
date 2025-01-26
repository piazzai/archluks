#!/bin/bash
set -e

# configure pacman
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf

# enable network manager
sudo systemctl enable NetworkManager

# enable filesystem trim
sudo systemctl enable fstrim.timer

# install and enable battery life optimizer
sudo pacman -S tlp
sudo systemctl enable tlp

# install and enable pacman cache clearing
sudo pacman -S pacman-contrib
sudo systemctl enable paccache.timer

# install pacman mirror selector
sudo pacman -S reflector

# install and enable firewall
sudo pacman -S ufw
sudo ufw enable

# install aur helper
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# install and connect mullvad vpn
yay -S mullvad-vpn-bin
read -rp "Enter your Mullvad VPN account number: " MULLVAD
mullvad account login "$MULLVAD"
mullvad relay set location ch
mullvad connect

# install opengl drivers
sudo pacman -S mesa

# install display server and color manager
sudo pacman -S xorg xcalib xiccd

# download recommended color profile
curl -fsSLO https://www.notebookcheck.net/uploads/tx_nbc2/BOE_CQ_______NE135FBM_N41_01.icm \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0'

# install audio server and equalizer
sudo pacman -S easyeffects pipewire-alsa pipewire-jack

# download recommended audio profile
curl -fsSLO https://github.com/FrameworkComputer/linux-docs/raw/refs/heads/main/easy-effects/fw13-easy-effects.json

# install, configure, and enable greeter
sudo pacman -S ly
sudo sed -i 's/^\(animation =\) none/\1 doom/' /etc/ly/config.ini
sudo sed -i 's/^\(clock =\) null/\1 %Y-%m-%d %H:%M %Z/' /etc/ly/config.ini
sudo sed -i 's/^\(clear_password =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(initial_info_text =\) null/\1 arch linux/' /etc/ly/config.ini
sudo sed -i 's/^\(hide_borders =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(default_input =\) login/\1 password/' /etc/ly/config.ini
sudo systemctl enable ly

# install command-line utilities
sudo pacman -S nano rsync github-cli fprintd

# install git lfs
sudo pacman -S git-lfs
git lfs install

# install globalprotect client
yay -S globalprotect-openconnect-git

# install ruby, bundler, and gems
sudo pacman -S ruby ruby-bundler
gem install --user-install jekyll
gem install --user-install neocities

# install r and packages
sudo pacman -S r
RLIBS="Sys.getenv('R_LIBS_USER')"
MIRROR="c(CRAN = 'https://cran.r-project.org')"
R -e "dir.create(path = $RLIBS, showWarnings = FALSE, recursive = TRUE)"
R -e "install.packages('languageserver', lib = $RLIBS, repos = $MIRROR)"
R -e "install.packages('renv', lib = $RLIBS, repos = $MIRROR)"

# install texlive
sudo pacman -S texlive

# install vscodium and extensions
yay -S vscodium-bin
codium --install-extension James-Yu.latex-workshop
codium --install-extension yzhang.markdown-all-in-one
codium --install-extension jeanp413.open-remote-ssh
codium --install-extension esbenp.prettier-vscode
codium --install-extension reditorsupport.r

# install keepass and cryptomator
sudo pacman -S keepassxc
yay -S cryptomator-bin

# install dropbox
yay -S dropbox

# install signal
sudo pacman -S signal-desktop

# install web browser and mail client
sudo pacman -S firefox thunderbird

# install graphics editors
sudo pacman -S gimp inkscape

# install spotify
sudo pacman -S spotify-launcher

# install xfce4
sudo pacman -S xfce4 xfce4-notifyd xfce4-battery-plugin xfce4-notes-plugin \
  xfce4-places-plugin xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin \
  xfce4-sensors-plugin xfce4-screenshooter xfce4-taskmanager pavucontrol \
  network-manager-applet nm-connection-editor gvfs

# set bash variables
printf '%s\n' '' '# Add GPG_TTY for gh authentication' "export GPG_TTY=\$(tty)" \
  '' '# Make user-installed gems executable' "export PATH=\$PATH:\$(ruby -e 'puts Gem.user_dir')/bin" \
  '' '# Include custom scripts' "export PATH=\$HOME/.bin:\$PATH" >> ~/.bashrc

# update and reboot
yay
reboot
