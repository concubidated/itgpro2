#!/bin/bash

#Run as root
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

#color variables
GREEN='\e[32m\e[1m';
RED='\e[31m\e[1m';
NC='\033[0m\e[21m';

#functions
kernel_module(){
	#Download Build Kernel Module
	echo -e "${GREEN}Nvidia Driver Install${NC}\n";
	echo "Graphic Drivers will need to be compiled for your system.";
	echo "Please choose which driver you would like to install. Most";
	echo "Likely 331.49 drivers will work best, but with newer cards";
	echo -e "a newer driver be required.\n";
	echo -e "Working Examples: GeForce 9400, 210	${GREEN}(331.49)${NC}";
	echo -e "                  GeForce GT 630	${GREEN}(340.65)${NC}";
	echo -e "                  GeForce FX 5200	${GREEN}(173.14)${NC}\n";
}

nvidia_choice(){
	read -p "Which Nvidia driver would you like to install (173_14/331_49/340_65/340_96)? " choice

	case "$choice" in
	  173_14 ) nvidia_173_14 ;;	
	  331_49 ) nvidia_331_49 ;;
	  340_65 ) nvidia_340_65 ;;
	  340_96 ) nvidia_340_96 ;;
	  *   ) echo -e "${RED}Invalid Choice${NC}"; nvidia_choice ;;
	esac
}

nvidia_173_14(){
	if [ -f "/home/itg/drivers/NVIDIA-Linux-x86-173.14.39-pkg1.run" ]
	then
		echo "Installing NVIDIA-Linux-x86-173.14.39-pkg1.run";
		/home/itg/drivers/NVIDIA-Linux-x86-173.14.39-pkg1.run -a -X -q
	else
		echo "Downloading NVIDIA Driver";
		wget "http://us.download.nvidia.com/XFree86/Linux-x86/173.14.39/NVIDIA-Linux-x86-173.14.39-pkg1.run" -P $HOME/;
        	sh $HOME/NVIDIA-Linux-x86-173.14.39-pkg1.run -a -X -q
	fi
}

nvidia_331_49(){
	if [ -f "/home/itg/drivers/NVIDIA-Linux-x86_64-331.49.run" ]
	then
		echo "Installing NVIDIA-Linux-x86_64-331.49.run";
		/home/itg/drivers/NVIDIA-Linux-x86_64-331.49.run -a -X -q
	else
		echo "Downloading NVIDIA Driver";
		wget "http://us.download.nvidia.com/XFree86/Linux-x86_64/331.49/NVIDIA-Linux-x86_64-331.49.run" -P $HOME/;	
		sh $HOME/NVIDIA-Linux-x86_64-331.49.run -a -X -q
	fi
}

nvidia_340_65(){

        if [ -f "/home/itg/drivers/NVIDIA-Linux-x86_64-340.65.run" ]
        then
		echo "Installing NVIDIA-Linux-x86_64-340.65.run";
		/home/itg/drivers/NVIDIA-Linux-x86_64-340.65.run -a -X -q
	else
		echo "Downloading NVIDIA Driver then intalling";
		wget "http://us.download.nvidia.com/XFree86/Linux-x86_64/340.65/NVIDIA-Linux-x86_64-340.65.run" -P $HOME/;
		sh $HOME/NVIDIA-Linux-x86_64-340.65.run -a -X -q
	fi
}

nvidia_340_96(){
	if [ -f "/home/itg/drivers/NVIDIA-Linux-x86_64-340.96.run" ]
	then
		echo "Installing NVIDIA-Linux-x86_64-340.96.run";
		/home/itg/drivers/NVIDIA-Linux-x86_64-340.96.run -a -X -q
	else
		echo "Downloading NVIDIA Driver then installing";
		wget "http://us.download.nvidia.com/XFree86/Linux-x86_64/340.96/NVIDIA-Linux-x86_64-340.96.run" -P $HOME/;
		sh $HOME/NVIDIA-Linux-x86_64-340.96.run -a -X -q
	fi
}

stats_setup(){
	if [ ! -d "/stats" ]; then
		mkdir /stats
	fi
	
	if [ -f "files/stats.tar" ]
	then
	        echo "Extracting data for /stats";
		tar zxf files/stats.tar -C /stats/
	else
	        echo "Downloading and extracting data for /stats";
		wget -qO- http://concubidated.com/itgfiles/stats.tar | tar xvz -C /stats/
	fi
}

itgdata_setup(){
	if [ ! -d "/itgdata" ]; then
		mkdir /itgdata
	fi
	
	if [ -f "files/itgdata.tar" ]
	then
		echo "Extracting data for /itgdata"
		tar zxf files/itgdata.tar -C /itgdata/
	else
		echo "Downloading and extracting data for /itgdata"
		wget -qO- http://concubidated.com/itgfiles/itgdata.tar | tar xvz -C /itgdata/
	fi
}

upstart_setup(){
	if [ ! -f /etc/init/itg.conf ]
	then
		cat <<EOF >> /etc/init/itg.conf
start on runlevel [2345]
exec /itgdata/start-game.sh
respawn
# Give up if restart occurs 3 times in 60 seconds.
respawn limit 3 60
EOF
		echo -e "Upstart Script installed.\n" ;
	fi

}


flashdrive_setup(){

	#flash drive entires into fstab for working USB
	echo "Making Directories for flash drive mount points..."
	mkdir -p /media/itg/sdb1
	mkdir -p /media/itg/sdc1
	mkdir -p /media/itg/sdd1
	mkdir -p /media/itg/sde1

	#check fstab before adding entries
	if [[ ! $(cat /etc/fstab | grep "/media/itg") ]]
	then
		echo "Updating /etc/fstab...";

		cat <<EOF >> /etc/fstab
/dev/sdb1 /media/itg/sdb1 vfat    noauto  0       0
/dev/sdc1       /media/itg/sdc1 vfat    noauto  0       0
/dev/sdd1       /media/itg/sdd1 vfat    noauto  0       0
/dev/sde1       /media/itg/sde1     vfat    noauto  0       0
EOF

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
	if [ `getconf LONG_BIT` = "64" ]
	then
		apt-get install -y build-essential libc6-i386 libx11-6:i386 libglu1-mesa:i386 \
		libpng12-0:i386 libjpeg62:i386 libusb-0.1-4:i386 libxrandr2:i386 libstdc++5:i386 \
		alsa xinit x11-xserver-utils libXtst6:i386 libasound2:i386 pmount zip unzip \
		libusb-0.1-4:i386 xinit;
	else
		apt-get install -y build-essential libx11-6 libglu1-mesa \
		libpng12-0 libjpeg62 libusb-0.1-4 libxrandr2 libstdc++5 \
		alsa xinit x11-xserver-utils libXtst6 libasound2 pmount zip unzip \
		libusb-0.1-4 xinit linux-headers-`uname -r`;
fi

}

cab_config(){

	#Is machine a upgrade or dedicab?
	read -p "Is this cabinet an Upgrade Cab? (y/n)? " choice
	case "$choice" in
	  [yY] ) touch /itgdata/K; rm -f /itgdata/C ;;
	  [nN] ) echo "\n" ;;
	  *    ) echo "-e ${RED}Invalid Choice${NC}\n"; cab_config ;;
	esac

	#What theme to run?
	read -p "Do you want to run the Simply Love theme? (y/n) " choice
	case "$choice" in
          [yY] ) echo -e "${GREEN}Simply Love${NC} theme installed\n"; ;;
          [nN] ) sed -i 's/^Theme/#Theme/' /stats/patch/Static-default.ini ; echo -e "${GREEN}Stock ITG2${NC} theme will be used.\n" ;;
          *    ) echo "${RED}Invalid Choice${NC}"; echo -e "Simply Love will be used.\n" ;;
        esac

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
cab_config
