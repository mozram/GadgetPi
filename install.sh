#!/bin/bash
#
# Installer for GadgetPi
#
# Usage:
# 	chmod +x install.sh
#	./install.sh
#

KERNEL_VERSION=$(uname -r)
MODULE_INSTALLED=false

# Update Packages and ensure dependencies are installed
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y screen git

printf "\nInstalling..."
printf "\nBackup files? [y/n] "
read backup

if [[ $backup == y* ]] ;
then
	if [ ! -d ~/GadgetPi/backup ] ;
	then
		sudo mkdir ~/GadgetPi/backup
	fi
	sudo cp /boot/config.txt ~/GadgetPi/backup/config.txt.bak
	sudo cp /etc/modules ~/GadgetPi/backup/modules.bak
	sudo cp /etc/rc.local ~/GadgetPi/backup/rc.local.bak
	sudo cp /etc/network/interfaces ~/GadgetPi/backup/interfaces.bak
	sudo cp /lib/modules/"$KERNEL_VERSION"/kernel/drivers/usb/dwc2/dwc2.ko ~/GadgetPi/backup/dwc2.ko.bak
fi

# Check if kernel module is there, otherwise download kernel and patch
if [ -f /lib/modules/"$KERNEL_VERSION"/kernel/drivers/usb/dwc2/dwc2.ko ] ;
then
	MODULE_INSTALLED=true
else
	printf "\nModule for kernel $KERNEL_VERSION not found.\nPatching is possible, but requires downloading the kernel."
	printf "\nProceed? [y/n] "
	read proceed
	if [[ $proceed == y* ]];
	then
		sudo apt-get install -y bc
		sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source
		sudo chmod +x /usr/bin/rpi-source && /usr/bin/rpi-source -q --tag-update
		rpi-source
		printf "\nPatching kernel module...\n"
		cd ~/linux/drivers/usb/dwc2
		patch -i ~/GadgetPi/dwc2/gadget.patch
		cd ~/linux
		make M=drivers/usb/dwc2 CONFIG_USB_DWC2=m
		sudo cp -f drivers/usb/dwc2/dwc2.ko /lib/modules/"$KERNEL_VERSION"/kernel/drivers/usb/dwc2/dwc2.ko
		sudo cp -f drivers/usb/dwc2/dwc2.ko ~/GadgetPi/dwc2/dwc2."$KERNEL_VERSION".ko
		MODULE_INSTALLED=true
	fi
fi

if [ "$MODULE_INSTALLED" = true ] ; 
then
   	# Install and setup files
	sudo cp -f ~/GadgetPi/config.txt /boot/
	sudo cp -f ~/GadgetPi/modules /etc/
	sudo cp -f ~/GadgetPi/rc.local /etc/
	sudo chmod +x /etc/rc.local
	# sudo cp -f ~/GadgetPi/isc-dhcp-server /etc/default/
	# sudo cp -f ~/GadgetPi/dhcpd.conf /etc/dhcp/
	# sudo cp -f ~/GadgetPi/interfaces /etc/network/
	sudo chmod +x ~/GadgetPi/gadget.sh
	sudo chmod +x ~/GadgetPi/fingerprint.sh
	printf "\nDefault IP address for usb0 is 169.254.100.100\n"
	printf "\nDone.\nYou can now reboot the device.\n"
else
	printf "Installation aborted.\n"
	[ -v PS1 ] && return || exit
fi

