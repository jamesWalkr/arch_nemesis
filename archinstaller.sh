#!/bin/bash

# An arch linux install script

# Verify Boot Mode
echo "-------------------------------------------------"
echo " checking to make sure you are bboted in UEFI"
echo "-------------------------------------------------"
boot_mode=$(sed -n '1p' /sys/firmware/efi/fw_platform_size)

if [ $boot_mode = 64 ]; then
  echo "This system is booted in UEFI with 64-bit x64"
else
  echo "This system is not booted in UEFI with 64-bit x64. Please boot into UEFI mode".
fi

# Check Internet connection
echo "-------------------------------------------------"
echo "Checking intenet connection"
echo "-------------------------------------------------"
if ping -c 3 archlinux.org &>/dev/null; then
  echo "Internet is connected"
else
  echo "internet is not connected. Please connect to the internet before installing."
fi

# Setting System Clock
echo "-------------------------------------------------"
echo "Synchronizing System Clock"
echo "-------------------------------------------------"
timedatectl

# Get user input
echo "--------------------------------------------------"
echo "please answer the following prompts"
echo "---------------------------------------------------"

echo -e "\nEnter username to be created:\n"

read usr_name

echo -e "\nEnter new password for $usr_name:\n"

read usr_password

echo -e "\nEnter new password for root:\n"

read rt_passowrd

echo -e "\nEnter new hostname (device name):\n"

read host

echo -e "\nEnter desired timezone in format of Country/Region (the list of all timezones can be found by first switching to different virtual console using Alt+arrow shorcut and issuing command \"ls /usr/share/zoneinfo/*/* | less\"):\n"

read time_zone

# save these inputs in a file from which the respective fields will be sourced later
echo -e "$usr_name $usr_password $rt_password $host $time_zone" >./confidentials

echo -e "\n\n"

echo "-------------------------------------------------"
echo "Displaying disk and block device information"
echo "-------------------------------------------------"

lsblk -l

echo -e "\n\n"

echo "---------------------------------------------------------------------------------------------------"
echo "Please choose what disk and block devices you want to use for this install based on above info."
echo "----------------------------------------------------------------------------------------------------"

echo -e "\nWhat disk would you like to use for this installation? (ie /dev/sda)\n"

read install_disk

echo -e "\nWhat partition would you like to use for the boot partion? (ie /dev/sda1).\n"

read boot_partition

echo -e "\nWhat partition would you like to use for swap? (ie /dev/sda2)\n"

read swap_partition

echo -e "\nWhat partition would you like to use for the root partiton? (ie /dev/sda3).\n"

read rt_partition

echo -e "\n\n"

echo "-------------------------------------------------------------------------"
echo "Below are disk and partitions that will be used for this install"
echo "-------------------------------------------------------------------------"

echo -e "\n$install_disk will be used as disk for arch install.\n"
echo -e "\n$boot_partition will be used for boot partition.\n"
echo -e "\n$swap_partition will be used for swap partition\n"
echo -e "\n$rt_partition will used for root partition.\n"

echo -e "\n\n"

echo "------------------------------------------------"
echo "Formatting Partitions"
echo "------------------------------------------------"

# wipe file system of the installation destination disk
echo -e "\nWiping file system\n"
wipefs --all $install_disk

echo -e "\nCreating GPT partiton table\n"
sgdisk $install_disk -o

# Create boot partiton of size 512MB and label as efi
echo -e "\nCreating boot partiton\n"
sgdisk -n 1::+512Mib -t 1:ef00 -c 1:efi $install_disk

# Create swap paration of size 4G and label as swap
echo -e "\nCreating swap partition\n"
sgdisk -n 2::+4Gib -t 2:8200 -c 2:swap $install_disk

# create root partiton with remaining space and label as root
echo -e "\nCreating root partiton\n"
sgdisk -n 3 -t 3:8300 -c 3:root $install_disk

echo -e "\nPartitons have been created.\n"

lsblk -f

# 02/01/2025 - Script has been tested up to this points

# format BOOT partiton as FAT32
echo -e "\nCreating boot partion\n"
mkfs.fat -F 32 $boot_partition

# format ROOT partion as ext4
echo -e "\nFormating root partition"
mkfs.ext4 $rt_partition

# Turn swap on
echo -e "\nMaking swap partition\n"
mkswap $swap_partition

echo -e "\nPartitions have been formated\n"

lsblk -f

echo -e "\n\n"

echo "--------------------------------------------------"
echo "Mounting Partitons"
echo "--------------------------------------------------"

# Mount root partition
echo -e "\n Mounting root partiton"
mount $rt_partition /mnt

# Mount boot partition
echo -e "\nMounting boot partition\n"
mkdir -p /mnt/boot/efi
mount $boot_partition /mnt/boot/efi

# Turn swap on
echo -e "\nTurning swap on\n"
swapon $swap_partition

echo -e "\npartitions have been mounted\n"
lsblk -f

echo -e "\n\n"

echo "--------------------------------------------------"
echo "Adding fastest Mirror in Pacman mirrorlist"
echo "--------------------------------------------------"

# write to conf file for systemd service
echo -e "--save /etc/pacman.d/mirrorlist\n--country United States\n--protocol https\n--latest 5\n" >/etc/xdg/reflector/reflector.conf

# select the 5 most up to date mirrors from the US that support https
reflector --save /etc/pacman.d/mirrorlist --country United States --protocol https --latest 5 --verbose

echo -e "\n\n"

echo "--------------------------------------------------"
echo "Performing Pacstrap Operation"
echo "--------------------------------------------------"

# install packages from pkgs list
packstrap -K /mnt $(cat pkgs.txt | sed '/^#/d' | sed '/^$/d' | tr '\n' ' ')

echo -e "\npackages have been installed\n"

echo "--------------------------------------------------"
echo "Generating File System Tab"
echo "--------------------------------------------------"

# genrating File System Tab
genfstab -U /mnt >>/mnt/etc/fstab

echo -e "\nBase installation is now complete\n"
