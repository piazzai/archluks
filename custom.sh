#!/bin/bash
set -e

# configure pacman
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf

# install drivers and utilities
sudo pacman -S base-devel mesa pacman-contrib reflector tlp ufw git git-lfs \
  github-cli nano rsync gzip tree neofetch fprintd xcalib xiccd pipewire \
  pipewire-alsa pipewire-jack pipewire-pulse wireplumber easyeffects

# install desktop environment and greeter
sudo pacman -S xfce4 xfce4-notifyd xfce4-battery-plugin xfce4-notes-plugin \
  xfce4-places-plugin xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin \
  xfce4-screenshooter xfce4-taskmanager pavucontrol nm-connection-editor \
  network-manager-applet mousepad parole ristretto libreoffice-fresh gvfs ly

# configure greeter
sudo sed -i 's/^\(animation =\) none/\1 doom/' /etc/ly/config.ini
sudo sed -i 's/^\(clock =\) null/\1 %Y-%m-%d %H:%M %Z/' /etc/ly/config.ini
sudo sed -i 's/^\(clear_password =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(initial_info_text =\) null/\1 arch linux/' /etc/ly/config.ini
sudo sed -i 's/^\(hide_borders =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(default_input =\) login/\1 password/' /etc/ly/config.ini

# enable firewall
sudo ufw enable

# enable services
sudo systemctl enable fstrim.timer
sudo systemctl enable paccache.timer
sudo systemctl enable NetworkManager
sudo systemctl enable tlp
sudo systemctl enable ly

# install aur helper
cd ~ && git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay

# install mullvad vpn and connect
yay -S mullvad-vpn-bin
read -rp "Enter your Mullvad VPN account number: " ACCOUNT
mullvad account login "$ACCOUNT"
mullvad relay set location ch
mullvad connect

# download audio and color profiles
cd ~ && curl -fsSLO https://github.com/FrameworkComputer/linux-docs/raw/refs/heads/main/easy-effects/fw13-easy-effects.json
cd ~ && curl -fsSLO https://www.notebookcheck.net/uploads/tx_nbc2/BOE_CQ_______NE135FBM_N41_01.icm \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0'

# install git lfs
git lfs install

# install globalprotect client
yay -S globalprotect-openconnect-git

# install ruby, bundler, and gems
sudo pacman -S ruby ruby-bundler
gem install --user-install jekyll
gem install --user-install neocities

# install r and packages
sudo pacman -S r
rlibs="Sys.getenv('R_LIBS_USER')"
cran="c(CRAN = 'https://cran.r-project.org')"
R -e "dir.create(path = $rlibs, showWarnings = FALSE, recursive = TRUE)"
R -e "install.packages('languageserver', lib = $rlibs, repos = $cran)"
R -e "install.packages('renv', lib = $rlibs, repos = $cran)"

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
pacman -S keepassxc
yay -S cryptomator-bin

# install dropbox
yay -S dropbox

# install signal
pacman -S signal-desktop

# install web browser and mail client
pacman -S firefox thunderbird

# install graphics editors
pacman -S gimp inkscape

# install spotify
pacman -S spotify-launcher

# set bash variables
printf '%s\n' '' '# Add GPG_TTY for gh auth' "export GPG_TTY=\$(tty)" \
  '' '# Make gems executable' "export PATH=\$PATH:\$(ruby -e 'puts Gem.user_dir')/bin" \
  '' '# Add custom scripts' "export PATH=\$HOME/.bin:\$PATH" >> ~/.bashrc

# update and reboot
sudo pacman -Syu
reboot
