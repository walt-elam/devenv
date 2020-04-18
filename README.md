# Development Environment Setup and Configuration

This repo contains the files necessary to setup and configure a new \*nix
installation for use as a development environment. It does not contain user
configuration files (e.g. .bashrc, .vimrc, etc.), so those should be maintained
and pulled from a separate repo.

# Current software list
This is a quick overview of the main software installed for the system. Details
on how they were chosen can be found below.

* Operating System: Ubuntu Server
* Shell: bash
* X Server: X.org server
* Display Manager: LightDM
* Window Manager: i3wm
* Terminal: xterm

# Requirements and Goals
The overarching goal of this development environment is to support systems
programming and scripting.

## Language Support
Programming, amongst other various development tasks, will have a focus on the
following languages (in order of importance):

* C
* Python 3
* C++
* Assembly

## Architectures

The environment also aims to be "portable" across the following architectures:

* x86\_64
* x86
* ARM
* AArch64

Intel/AMD architecture support is aimed at generic Intel/AMD CPUs, while the
ARM architectures are aimed at whatever the CPUs used by Raspberry Pis.

Requirements of the operating system (OS) are that it should have frequent
releases (~6 months or less) and support a package manager with a wide variety
of packages. This is to say that for a given piece of \*nix software, there
should be a reasonable expectation that there will be a package/source available
for the OS.

## Software
In general, any piece of software that is chose should be well maintained,
although releases do not need to be as frequent as the OS itself. Another
consideration is popularity, as with many things \*nix, you will be spending
time debugging various issues and a broader user base will make that process
much smoother.

# Operating System
Given the requirements, *Ubuntu* will be the OS. It supports all architectures,
has arguable the largest package repository of any \*nix system, and can easily
support development in all languages.

Beyond this, *Ubuntu Server* will be the variant being used as it does not come
with any GUI componenets preconfigured, allowing for those to be chosen at will.

## Contenders
Other OSs that were considered, and the reasons they weren't chosen:

* Debian (stable releases too infrequent)
* Fedora (fewer packages)
* FreeBSD (significantly fewer packages)

# Shell
For now, Bash will be the shell but there are a few strong contenders listed
below. Again, two lists, one for viable candidates and one for discards and why.

* bash - default and familiar, no lambdas
* zsh - fully featured

* csh (no functions)
* fish (no RE built-in, no string processing)
* ksh (no wildcard completion, secure prompt via stty, not as good)
* sh (no command completion)
* tcsh (no wildcard completion, no functions)

# GUI Components
The OS GUI can be broken down in to many parts, each of which should be able to
be chosen mostly independently from the others.

## X Server 
The X.org server is the reference implementation for X servers and is actively
maintained. There is no real reason _not_ to use it.

## Display Manager 
LightDM provides a lightweight, and easily configurable, display manager for
Ubuntu (and was the default until 16.04).

### Contenders

* GDM (configured via XML)
* LXDM (doesn't support XDMCP)
* SDDM (configured via QML)
* XDM (reference implementation, but no real features)

## Window Manager 
i3 is a flexible display manager that is well documented, widely used, and
easily configurable.

### Contenders

* awesome (fast, but configured via LUA)
* dwm (must be recompiled to reconfigure)
* monsterwm (small and configurable, but must be recompiled)

## Terminal Emulator
For now, xterm will be the terminal emulator only because it's somewhat the
default. Due to the variety of terminal emulator, more time is required to come
to a definitive decision.

### Contenders

Given that there are so many terminal emulator, they have been broken down into
two lists. The first is viable candidates, while the second is those not in the
running and why.

* termite - vim-like shortcuts, very active
* tilda - lightweight, highly configurable, active, drop down
* tilix - very active and modern
* urxvt - configurable, fast, not much activity
* xfce - drag and drop, configurable, active
* xterm - lightweight, minimal, oldest, somewhat active

* gnome terminal (very basic)
* konsole (KDE default, tabs)
* quake (drops down like a quake console)
* roxterm (only slightly better than gnome terminal)
* terminator (has tiles and tabs)
* terminology (file preview system)
* yaquake (drop down like quake)

