#!/bin/bash

#Run as root
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

#color variables
GREEN='\e[32m\e[1m';
RED='\e[31\e[1m';
NC='\033[0m\e[21m';

#functions
kernel_module(){
	#Download Build Kernel Module
	echo -e "${GREEN}Nvidia Driver Install${NC}\n";
	echo "Graphic Drivers will need to be compiled for your system.";
	echo "Please choose which driver you would like to install. Most";
	echo "Likely 331.49 drivers will work best, but with newer cards";
	echo -e "a newer driver be required.\n";
	echo -e "Working Examples: GeForce 9400    ${GREEN}(331.49)${NC}";
	echo -e "                  GeForce GT 630  ${GREEN}(340.64)${NC}\n";
}

nvidia_choice(){
	read -p "Which Nvidia driver would you like to install (331_49/340_65/340_96)? " choice

	case "$choice" in
	  331_49 ) nvidia_331_49 ;;
	  340_65 ) nvidia_340_65 ;;
	  340_96 ) nvidia_340_96 ;;
	  *   ) echo "Invalid Choice"; nvidia_choice ;;
	esac
}

nvidia_331_49(){
	echo "Installing NVIDIA-Linux-x86_64-331.49.run";
	/home/itg/drivers/NVIDIA-Linux-x86_64-331.49.run -a -X -q
}

nvidia_340_65(){
	echo "Installing NVIDIA-Linux-x86_64-340.65.run";
	/home/itg/drivers/NVIDIA-Linux-x86_64-340.65.run -a -X -q
}

nvidia_340_96(){
	echo "Installing NVIDIA-Linux-x86_64-340.96.run";
	/home/itg/drivers/NVIDIA-Linux-x86_64-340.96.run -a -X -q
}

stats_setup(){
	echo "Downloading and extracting data for /stats";
	wget -qO- http://concubidated.com/itgfiles/stats.tar | tar xvz -C /stats/
}

itgdata_setup(){
	echo "Downloading and extracting data for /itgdata"
	wget -qO- http://concubidated.com/itgfiles/itgdata.tar | tar xvz -C /itgdata/
}

upstart_setup(){
	echo "start on runlevel [2345]
exec /itgdata/start-game.sh
respawn
# Give up if restart occurs 10 times in 90 seconds.
respawn limit 10 90" | tee /etc/init/itg.conf
}


flashdrive_setup(){
	#flash drive entires into fstab for working USB
	mkdir -p /media/itg/sdb1
	mkdir -p /media/itg/sdc1
	mkdir -p /media/itg/sdd1
	mkdir -p /media/itg/sde1

	#check fstab before adding entries
	if [[ ! $(cat /etc/fstab | grep "/media/itg") ]]
	then

	echo "/dev/sdb1 /media/itg/sdb1 vfat    noauto  0       0
	/dev/sdc1       /media/itg/sdc1 vfat    noauto  0       0
	/dev/sdd1       /media/itg/sdd1 vfat    noauto  0       0
	/dev/sde1       /media/itg/sde1     vfat    noauto  0       0" | \
	sudo tee -a /etc/fstab;

	fi
}


internet_check(){
	#Check for interwebs
	echo "Checking for Internet Connection:";
	echo -n "Please Wait";
	sleep .5
	echo -n ".";
	sleep .5
	echo -n ".";
	sleep .5
	echo -e  ".\n";
	wget -q --tries=10 --timeout=20 --spider http://google.com
	if [[ ! $? -eq 0 ]]; then
        	exit 1;
	fi
}

install_packages(){
	#Install required packages
	apt-get update
	apt-get install build-essential libc6-i386 libx11-6:i386 libglu1-mesa:i386 \
	libpng12-0:i386 libjpeg62:i386 libusb-0.1-4:i386 libxrandr2:i386 libstdc++5:i386 \
	alsa xinit x11-xserver-utils libXtst6:i386 libasound2:i386 pmount zip unzip \
	libusb-0.1-4:i386 xinit;
}

#Start of the Installer Script

echo -e "${GREEN}In The Groove 2 - Arcade Installer\n${NC}";

internet_check
install_packages
kernel_module
nvidia_choice
stats_setup
itgdata_setup
flashdrive_setup
upstart_setup
