#!/bin/sh

# Helper functions
msg ()
{
    echo "${1}"
}

info ()
{       
    msg "[+] ${1}" 
}

warn () 
{       
    msg "[-] ${1}" 
}

err () 
{        
    msg "[!] ${1}" 
}

err_exit() 
{    
    err ${2}
    exit ${1} 
}

# Run this as root!
if [ 0 != $(id -u) ]; then
    err_exit 1 "This script must be run as root!"
fi

# Update default software
info "Updating package index"
apt update

info "Updating packages"
apt upgrade --assume-yes

# Install/change shell
info "Setting up bash"
apt install --assume-yes bash bash-builtins bash-completion bash-doc
chsh -s /bin/bash ${USER}

# Install X server
info "Installing X server"
apt install --assume-yes xserver-xorg libgl1-mesa-dri xserver-xorg-legacy xserver-xorg-video-all

# Install terminal emulator
info "Installing terminal emulator"
apt install --assume-yes xterm x11-utils

# Install display manager
info "Installing display manager"
apt install --assume-yes lightdm
dpkg-reconfigure lightdm

# Install greeter
info "Installing greeter"
apt install --assume-yes python3-pip
pip3 install pyqt5==5.14
pip3 install whither
apt install --assume-yes liblightdm-gobject-1-0-dev python3-gi
wget https://download.opensuse.org/repositories/home:/antergos/xUbuntu_17.10/amd64/lightdm-webkit2-greeter_2.2.5-1+15.31_amd64.deb
dpkg -i lightdm-webkit2-greeter_2.2.5-1+15.31_amd64.deb
mkdir /usr/share/backgrounds

# Install window manager
info "Installing window manager"
apt install --assume-yes i3

# Configure X server
cat > /etc/X11/xorg.conf << EOF
# Xorg Server Configuration

Section "ServerFlags"
    Option "BlankTime" "5"
    Option "StandbyTime" "5"
    Option "SuspendTime" "5"
    Option "OffTime" "5"
    Option "MaxClients" "64"
    Option "Log" "flush"
EndSection

EOF

# Configure display manager
cat > /etc/lightdm/lightdm.conf << EOF
# LightDM Configuration

[LightDM]
backup-logs=false

[Seat:*]
allow-guest=false
greeter-session=lightdm-webkit2-greeter
user-session=i3
xserver-command=X -core

EOF

# Setup C development tools
info "Setting up C"
apt install --assume-yes gcc gcc-multilib 
apt install --assume-yes binutils gdb make valgrind
apt install --assume-yes linux-source libc6-dev
apt install --assume-yes manpages-dev manpages-posix manpages-posix-dev

# Setup python3 development tools
info "Setting up python3"
apt install --assume-yes python3 python3-pip
pip3 install --upgrade pip
pip3 install --upgrade setuptools

# Setup C++ development tools
info "Setting up C++"
apt install --assume-yes g++ g++-multilib

# Setup assemly development tools
info "Setting up assembly"
apt install --assume-yes nasm

# Setup python2
info "Setting up python2"
apt install --assume-yes python2 python-pip
pip install --upgrade pip
pip install --upgrade setuptools

# Editor
info "Installing editor"
apt install --assume-yes vim-tiny

# Git
info "Installing git"
apt install --assume-yes git git-doc git-lfs git-man

# Cleanup
info "Cleaning up package repositories"
apt autoremove

# Reboot into new system
info "Rebooting..."
reboot now
