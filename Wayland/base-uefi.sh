#!/bin/bash

#ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
#hwclock --systohc
#sed -i '1761s/.//' /etc/locale.gen
#locale-gen
#echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
#echo "KEYMAP=de_CH-latin1" >> /etc/vconsole.conf
#echo "arch" >> /etc/hostname
#echo "127.0.0.1 localhost" >> /etc/hosts
#echo "::1       localhost" >> /etc/hosts
#echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
#echo root:password | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S network-manager-applet dunst linux-headers xdg-user-dirs xdg-utils xdg-desktop-portal gvfs nfs-utils bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol playerctl bash-completion reflector acpi acpi_call acpid ntfs-3g pass libsecret seahorse wmname

# install this if you want power management on a laptop
pacman -S tlp

# install this for generic and hp printer support
# pacman -S cups hplip

# install this for amd gpu support
pacman -S --noconfirm xf86-video-amdgpu

# install this for open source nvidia support
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

#grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
#grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager # network manager service
systemctl enable bluetooth.service # bluetooth service
# systemctl enable cups.service
# systemctl enable sshd
# systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer # helps find fastest mirrors for downloading stuff
systemctl enable fstrim.timer # optimise the file system
# systemctl enable libvirtd
# systemctl enable firewalld
systemctl enable acpid # system device comms helper

# this will auto create the normal user directories for you
# xdg-user-dirs-update

#useradd -m rob
#echo rob:password | chpasswd
#usermod -aG wheel,audio,video,optical,storage,libvirt rob

#echo "rob ALL=(ALL) ALL" >> /etc/sudoers.d/rob

#printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
echo "All done now..."

