# In The Groove 2 - Arcade Installer

In The Groove 2 cabinets are usually in terrible shape when it comes to their hardware. The computers used in these machines are over a decade old are very prone to failures. Upgrading the computer to use modern hardware and a modern Linux is required to keep the machines alive. *ITGPRO2* is an automated installer that will help a cabinet owner replace the original hardware with something new. This will allow things such as **SATA drives**, **SSDs**, and **USB2** to be used which has not been possible in the past. This gives a much better experience for the player and the cabinet owner.


## How it Works

First thing required is going to be a new computer for the cabinet and a newer *NVIDIA* graphics card. So far I have tested this on the following cards:

* GeForce GT 630
* Geforce 210
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

## TODO

* Add script for adding more songs packs

## Where to Get

The iso has had a couple issues where it would not work correctly when installing via USB. (Only was working off optical media). Will create a new image soon enough.

## Installing without the ISO

1. Download [Ubuntu 14.04.1](http://old-releases.ubuntu.com/releases/14.04.2/ubuntu-14.04.1-server-amd64.iso). If you are running this on the STOCK ITG2 hardware, you will need to use an older Ubuntu Release Download [Ubuntu 12.04.1](http://old-releases.ubuntu.com/releases/12.04.1/ubuntu-12.04.1-server-i386.iso) instead.
1. Boot the installer, and select `Install Ubuntu Server`
1. Enter through the options, set the hostname to `itg`, username to `itg`, and password to `itg`, use weak password and do *NOT* encrypt the home directory.
1. Partitioning, select `Manual`, Select `sda` drive, create empy partition table. Then create the following partitions.
    * 500MB, Primary, XFS, Mount = /boot, bootable flag = yes, Done
    * 5GB, Primary, XFS, Mount = /, Done
    * 1GB, Primary, XFS, Mount = /stats, Done
    * Free Space, Logical, XFS, Mount = /itgdata, done
    * Finish Paritioning and write changes to disk
    * No Swap
    
    ![What it should look like](http://i.imgur.com/p2VkHh6.png)
1. System will install, when it gets to the Software Selection Screen, use spacebar to select `OpenSSH server`
1. Install GRUB
1. After the install is finished, the system should reboot and you will get a login promt. Login with `itg`, and password `itg`.
    * At this point it is recommended to connect to the ITG machine via SSH. If you are running Linux or macOS, simply open terminal and run `ssh itg@<ip address>` to connect. The machine will need to be connected online to continue the installation of ITG.
1. Install Git `sudo apt-get install git`
1. Blacklist the nouveau driver `echo "blacklist nouveau"  | sudo tee -a /etc/modprobe.d/blacklist.conf`
1. Reboot `sudo reboot`
1. When started back up, Clone the repo, `git clone https://github.com/concubidated/itgpro2` and change directory to itgpro2, `cd itgpro2`
1. Run the installer script `sudo ./itg-installer.sh`
    * When asked what NVIDIA driver to install, start with 331_49 if using a 9000 series card or older.
    * If you are using the STOCK ITG2 hardware, choose the NVIDIA driver 173_14.
1. If everything went well, itg can be started with `sudo start itg` to stop itg from running, you can run the command `sudo stop itg`.

## When ITG is starting the screen flashes green

If this is occuring, the problem is the NVIDIA driver module not loading. This is likely due to either selecting an incompatable driver. For now you can rerun the 

## Overscan issues

I have noticed a few cases when using S-VIDEO to output to a TV rather then VGA to the JAMMA output that the display is not correct and overscan issues exists. This means the screen is larger then the display. This can be resolved by modifying the xorg configuration ITG uses when booting. The file to modify is /stats/patch/XF86Config-cab

In the `Monitor` section add the following Modeline:

`Modeline "800x600_60.00"   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync`

In the `Screens` section add the following Options:

```	
Option "ConnectedMonitor" "TV-0"
Option         "metamodes"     "TV-0: 800x600+0+0 { ViewPortIn=640x480, ViewPortOut=640x440+30+20}"
```

What this is doing is setting a virtual resoluton of 800x600 on a display that only outputs 640x480. This allows you to manipulate the width, height and origin of the viewport manually.

In this example ViewPortOut was set to 640x440+30+20. This means 640 pixels wide, by 440 pixels tall. The +30 indicates 30 pixels from the left origin, and +20 indicates 20 pixels from the top origin. You may need to manually adjust this depending on your display and graphics card.
