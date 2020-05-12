#!/bin/sh
#
#   Development environment setup script
################################################################################

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

arch=$(dpkg --print-architecture)

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
apt install --assume-yes xserver-xorg libgl1-mesa-dri
apt install --assume-yes xserver-xorg-legacy xserver-xorg-video-all
apt install --assume-yes x11-xserver-utils xorg-docs-core

# Install terminal emulator
info "Installing terminal emulator"
apt install --assume-yes xterm x11-utils
update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/xterm 40

# Install display manager
info "Installing display manager"
DEBIAN_FRONTEND=noninteractive apt install --assume-yes lightdm
echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
dpkg-reconfigure -fnoninteractive lightdm

# Install greeter
info "Installing greeter"
apt install --assume-yes python3-pip
pip3 install pyqt5==5.14
pip3 install whither
apt install --assume-yes liblightdm-gobject-1-dev python3-gi
ldmg_ver="2.2.5-1+15.31"
ldmg_file="lightdm-webkit2-greeter_${ldmg_ver}_${arch}.deb"
wget https://download.opensuse.org/repositories/home:/antergos/xUbuntu_17.10/${arch}/${ldmg_file}
dpkg -i ${ldmg_file}
rm -f ${ldmg_file}
mkdir -p /usr/share/backgrounds

# Install window manager
info "Installing window manager"
apt install --assume-yes openbox obconf obsession
apt install --assume-yes tint2 wmctrl
apt install --assume-yes feh imagemagick

# Install file manager
info "Installing file manager"
apt install --assume-yes nautilus

# Configure X server
cat > /etc/X11/xorg.conf << EOF
#
# xorg.conf
#
# Xorg Server Configuration
################################################################################

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
#
# LightDM Configuration
#
# All settings documented in /usr/share/doc/lightdm/lightdm.conf.gz
################################################################################

[LightDM]
backup-logs=false

[Seat:*]
allow-guest=false
allow-user-switching=true
exit-on-failure=true
greeter-allow-guest=false
greeter-session=lightdm-webkit2-greeter
user-session=openbox
xserver-allow-tcp=true
xserver-command=X -core

[XDMCPServer]
enabled=false

[VNCServer]
enabled=false

EOF

# Configure SSH
cat > /etc/ssh/sshd_config << EOF
#
# sshd_config
#
# OpenSSH SSH daemon configuration
################################################################################

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# Only allow IPv4 connections
AddressFamily inet

# Disable challenge/response authentication
ChallengeResponseAuthentication no

# Users must authenticate within this many seconds
LoginGraceTime 30

# Maximum failed login attempts before logging
MaxAuthTries 3

# Maximum concurrent sessions per connection
MaxSessions 4

# Maximum logins being attempted at any one time
MaxStartups 2

# Do not allow root logins
PermitRootLogin no

# Enable SFTP subsystem
Subsystem sftp	/usr/lib/openssh/sftp-server

# Allow PAM authentication
UsePAM yes

EOF

# Setup VNC server
info "Setting up VNC server"
apt install --assume-yes tigervnc-standalone-server tigervnc-common
apt install --assume-yes tigervnc-xorg-extension

# Setup C development tools
info "Setting up C"
apt install --assume-yes gcc gcc-multilib 
apt install --assume-yes binutils gdb make valgrind
apt install --assume-yes automake cmake
apt install --assume-yes linux-source libc6-dev
apt install --assume-yes manpages-dev manpages-posix manpages-posix-dev

# Setup python3 development tools
info "Setting up python3"
apt install --assume-yes python3 python3-pip
pip3 install --upgrade pip
pip3 install --upgrade testresources
pip3 install --upgrade setuptools
pip3 install --upgrade pycodestyle

# Setup C++ development tools
info "Setting up C++"
apt install --assume-yes g++ g++-multilib

# Setup assembly development tools
info "Setting up assembly"
apt install --assume-yes nasm

# Setup python2
info "Setting up python2"
apt install --assume-yes python2
pip install --upgrade pip
pip install --upgrade setuptools
pip install --upgrade pycodestyle

# Editor
info "Installing editor"
apt install --assume-yes vim
update-alternatives --install /usr/bin/editor editor /usr/bin/vim.basic 50

# Git
info "Installing git"
apt install --assume-yes git git-doc git-lfs git-man

# ripgrep
info "Installing ripgrep"
apt install --assume-yes ripgrep

# FZF
info "Installing FZF"
apt install --assume-yes fzf

# LaTeX
info "Installing LaTeX"
apt install --assume-yes texlive-latex-base evince

# ASCIInema
info "Installing ASCIInema"
pip3 install --upgrade asciinema

# Browser
info "Installing browser"
apt install --assume-yes firefox

# Other
info "Installing other utilities"
apt install --assume-yes tree

# Cleanup
info "Cleaning up package repositories"
apt purge --assume-yes cloud-init
apt autoremove --assume-yes

# Reboot into new system
info "Rebooting..."
reboot now

