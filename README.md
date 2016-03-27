# In The Groove 2 - Arcade Installer

In The Groove 2 cabinets are usually in terrible shape when it comes to their hardware. The computers used in these machines are over a decade old are very prone to failures. Upgrading the computer to use modern hardware and a modern Linux is required to keep the machines alive. *ITGPRO2* is an automated installer that will help a cabinet owner replace the original hardware with something new. This will allow things such as **SATA drives**, **SSDs**, and **USB2** to be used which has not been possible in the past. This gives a much better experience for the player and the cabinet owner.


##How it Works
First thing required is going to be a new computer for the cabinet and a newer *NVIDIA* graphics card. So far I have tested this on the following cards:
* GeForce GT 630
* GeForce 9400 GT
* GeForce 7300 GS
* GeForce 8500 GS


The following motherboards:
* ASRock B85M-ITX Mini ITX
* Gigabyte B85M-DS3H-A (Had to disable onboard video in bios)

The files here are the preseed file, the installer script, and the txt.cfg file that have been modified from a *Ubuntu 14.04.1 Server* image. These files are included with **itgpro2.iso** and automate the installation and configuration of the Operating System. 

**Notes:** 
* Internet connection is required for this to complete.
* Only connect a single drive to the machine during installation as it will be automatically paritioned and formatted. **All previous data will be lost!**

After installing, there will be a user called *itg* created with the password *itg*. In the home directory of the itg user `/home/itg/` exists the **itg-installer.sh** script. This script will do the following: 
* Install the required packages for the OpenITG binary
* Guide you through installing the included NVIDIA drivers
* Download and configure the data required for the /stats partiion
* Download and configure the data required for the /itgdata partiton (~2GB Download)
* Configure the mount points for flash drives to work with OpenITG
* Guide you through some options
  * Running Stock ITG2 or SIMPLY LOVE (Included version has some bug fixes I added)
  * Configuring for **Cabinet** or **Kit**
* Creates upstart script to auto start OpenITG on boot.

Run the script by running the command `sudo ./itg-installer.sh`
The script will ask a series of questions to guide you through setting up In The Groove.

Note: If you are not going to be using the **itgpro2.iso** to install your system, but want to use the installer script, make sure you are using a **3.13.* Kernel**. I have tested with later kernels and have had major issues with the older NVIDIA drivers.

##TODO
* Add script for adding more songs packs

##Where to Get

The iso has had a couple issues where it would not work correctly when installing via USB. (Only was working off optical media). Will create a new image soon enough.

##Installing without the ISO

1. Download [Ubuntu 14.04.1] (http://old-releases.ubuntu.com/releases/14.04.2/ubuntu-14.04.1-server-amd64.iso)
2. Boot the installer, and select "Install Ubuntu Server"
3. Enter through the options, set the hostname to *itg*, username to *itg*, and password to *itg*, use weak password and do NOT encrypt the home directory.
4. Partiioning, select *Manual*, Select *sda* drive, create empy partition table. Then create the following partitions.
  * 500MB, Primary, XFS, Mount = /boot, bootable flag = yes, Done
  * 5GB, Primary, XFS, Mount = /, Done
  * 1GB, Primary, XFS, Mount = /stats, Done
  * Free Space, Logical, XFS, Mount = /itgdata, done
  * Finish Paritioning and write changes to disk
  * No Swap
![What it should look like] (http://i.imgur.com/p2VkHh6.png)
4. System will install, when it gets to the Software Selection Screen, use spacebar to select OpenSSH server
5. Install GRUB
6. After the install is finished, the system should reboot and you will get a login promt. Login with `itg`, and password `itg`.
7. Install GIT `sudo apt-get install git`
8. Clone the repo, `git clone https://github.com/concubidated/itgpro2` and change directory to itgpro2, `cd itgpro2`
9. Run the installer script `sudo ./itg-installer.sh`
  * When asked what NVIDIA driver to install, start with 331_49 if using a 9000 series card or older.
10. If everything went well, itg can be started with `sudo start itg`


