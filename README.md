= Nephology
noun \[nɪˈfɒlədʒɪ\]
1. The branch of meteorology that deals with clouds.
2. A system for building and deploying clouds.

Nephology is a flexible bare-metal provisioning system. It is designed to take newly racked hardware from an unknown state all the way through hardware configuration and finally booting an operating system with an (optional) configuration management client installed.  The idea is to take new hardware provisioning time down from hours to minutes.

Unlike other systems, Nepholoy does not dictate which OS or configuration management tools you need to install.  You can even use Nephology to perform initial hardware configuration tasks, verify physical requirements, and then pass off to a third-party netboot installer (like XenServer or WDS).

## Features

* Template based configuration
* Modular Design (bring your own external tools or use ones already built in)
* Scriptable client and server
* Basic hardware inventory gathering information for use in an external DCIM
* OS Independent
* Configuration Management system independent (including no CM)
* Configutation of BIOS settings (on supported platforms)
* Configuration of RAID controllers
* Configuration of IPMI/DRAC/iLO controllers
* Firmware management (of supported devices)
* Detection, reporting, and optional configuration of network connections
* Detection and enforcement of minimum hardware requirements:
  * CPU Core Count
  * Memory Size
  * Disk Count
  * NIC Count
  * many others
* Support for multiple operating systems
* Support for a rescue mode in order to resolve issues in the same environment as the installer

## Requirements

Nephology is designed to run in a netboot environment, and requires that the machine (at least initially) be able to netboot.  Once the OS has been installed, it is possible to switch the system to localboot for security reasons.

The Nephology server needs to run on a host capable of running a Perl script.  We recommend using Ubuntu Linux with lighttpd.  The following Perl modules are required:
* mojolicious (ubuntu package:libmojo-perl)
* YAML (ubuntu package: libyaml-perl)
* JSON (ubuntu package: libjson-perl)
* Rose::DB (ubuntu package: librose-db-perl)
* Rose::DB::Object (ubuntu package: librose-db-object-perl)
* The appropriate packages for Rose::DB to talk to your database of choice

For the actual netbooting of systems, we recommend using [iPXE](http://ipxe.org) -- configuration details in the wiki.

## Status

This project is under active development, and currently in use at DreamHost for deployment of our systems.  We will be releasing the project with a BSD license in the near future.  If you would like to help, please contact me.  There is a wiki page which will help you get started with hacking on the code.