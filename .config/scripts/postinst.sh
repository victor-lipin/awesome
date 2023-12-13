#!/bin/bash
topDir="$(pwd)"
echo "For which user Awesome will be installed?"
read user
echo "Install Nvidia driver?"
read nvidiaDriver
echo "Install Intel driver?"
read intelDriver
echo "Install home soft? (cura fstl etc)"
read homeSoft
sudo -u $user echo "Let's instal!"

refl() {
pacman -Sy --noconfirm reflector
reflector --country RU --latest 200 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy
}

installYay() {
pacman -Sy base-devel --noconfirm
sudo -u $user git clone https://aur.archlinux.org/yay.git /home/$user/yay
cd /home/$user/yay
sudo -u $user makepkg -si --noconfirm
cp $topDir
rm -rf /home/$user/yay
}

installSoft() {
### pacman ###
pacman -S --noconfirm xorg-server awesome xorg-xinit wireguard-tools openssh alsa-utils xorg-xrandr systemd-resolvconf remmina freerdp \
libvncserver btop less inetutils net-tools dnsutils alacritty scrot neofetch cmatrix zsh ttf-jetbrains-mono-nerd lf cmus \
virtualbox cifs-utils pcmanfm-gtk3 lxappearance qt5ct numlockx i3lock scrot imagemagick xautolock firefox code ueberzug ffmpegthumbnailer ffmpeg \
virtualbox-host-modules-arch lshw loupe

### yay ###
sudo -u $user yay -Sy surf picom-allusive adwaita-qt5-git matcha-gtk-theme anydesk-bin trueconf ctpv-git cli-visualizer advcpmv --noconfirm
}

installNvidia() {
pacman -S nvidia nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
}

installIntel() {
pacman -S vulkan-intel mesa
}

installHomeSoft() {
sudo -u $user yay -S fstl cura-bin --noconfirm
}

config() {
systemctl enable sshd
#modprobe vboxdrv

cat > "/bin/lock" <<DATA
scrot /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x5 /tmp/screenshotblur.png
i3lock -i /tmp/screenshotblur.png
DATA

chmod +x /bin/lock
sudo -u $user xdg-mime default Alacritty.desktop application/x-terminal-emulator
mkdir -p /home/$user/Pictures/screenshots
chown $user -R /home/$user/Pictures
chsh -s /bin/zsh $user
}

toDo() {
cat > "/home/$user/ToDo" <<DATA
### Firefox ###
 open about:config and find:
browser.display.background_color
set - #1C1B22

### Nvidia ###
in file: /boot/grub/grub.cfg

find string:
linux   /boot/vmlinuz-linux root=UUID=f9ae230d-9a7c-420b-9a2b-bfdc1538c166 

and add:
rw  loglevel=3 quiet rw modprobe.blacklist=nouvea
DATA
}

refl
installYay
installSoft
if [ nvidiaDriver == "y" ]; then installNvidia;fi
if [ intelDriver == "y" ]; then installIntel;fi
if [ homeSoft == "y" ]; then installHomeSoft;fi
config
toDo