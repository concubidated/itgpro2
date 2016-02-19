# In The Groove 2 - Arcade Installer

In The Groove 2 cabinets are usually in terrible shape when it comes to thier hardware. The computers used in these machines are over a decade old are very prone to failures. Upgrading the computr to use modern hardware and a modern Linux is required to keep the machines alive. *ITGPRO2* is an automated installer that will help a cabinet owner replace the original hardware with something new. This will allow things such as **SATA drives**, **SSDs**, and **USB2** to be used which has not been possible in the past. This gives a much better experience for te player and the cabinet owner.


##How it Works
First thing required is going to be a new computer for the cabinet and a newer *NVIDIA* graphics card. So far I have tested this on the following cards:
* GeForce GT 630
* GeForce 9400 GT

The following motherboards:
* ASRock B85M-ITX Mini ITX
* Gigabyte B85M-DS3H-A (Had to disable onboard video in bios)

The files here are the preseed, and txt.cfg file that have been modified from a *Ubuntu 14.04.1 Server* image. These files are included with **itgpro2.iso** and automatic the installation and configuration of the Operating System. 

**Notes:** 
* Internet connection is required for this to complete.
* Only connect a single drive to the machine during installation as it will be automatically paritioned and formatted. **All previous data will be lost!**

After installing, there will be a user called *itg* created with the password *itg*. In the home directory of the itg user `/home/itg/` there exists the **itg-installer.sh** script. This script will do the following: 
* Install the required packages for the OpenITG binary
* Guide you through installing the included NVIDIA drivers
* Download and configure the data required for the /stats partiion
* Download and configure the data required for the /itgdata partiton (~2GB Download)
* Configure the mount points for flash drives to with OpenITG
* Guide you through some options
  * Running Stock ITG2 or SIMPLY LOVE (Included version working great with OpenITG-beta3)
  * Configuring for **Cabinet** or **Kit**
* Creates upstart script to auto start OpenITG on boot.

Run the script by running the command `sudo ./itg-installer.sh`
The script will ask a series of questions to guide you through setting up In The Groove.

Note: If you are not going to be using the **itgpro2.iso** to install your system, but want to use the installer script, make sure you are using a **3.13.* Kernel**. I have tested with later kernels and have had major issues with the older NVIDIA drivers.

##TODO
* Upload iso
* Add some of the final configuration to the script
* Add script for adding more songs packs
