#!/bin/bash

# Define colors
RED='\033[0;31m'
WHITE='\033[0;37m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

clear

# Check if Git is installed
if ! command -v git &> /dev/null
then
 echo -e "${RED}[ERROR]${NC} => Git could not be found. Install git before this."
 exit
fi

. /etc/os-release

if [ "$ID" = "arch" ]; then
   read -p "looks like you are on arch linux. would you like to install jetbrains nerd font? (yes/no) " response
   case "$response" in
    [yY][eE][sS]|[yY]) 
        sudo pacman -S ttf-jetbrains-mono-nerd
     ;;
 *)
     echo -e "${RED}Skipping nerd font installation...${NC}"
     clear
     ;;
    esac
fi

#  Backup Operation
echo -e "${GREEN}-==Backup Operation==-${NC}"
# Ask user if they want to create a backup
read -p "Do you want to create a backup of your current .config/nvim directory? (yes/no) " response
case "$response" in
 [yY][eE][sS]|[yY]) 
   # Check if the backup directory exists
   if [ ! -d ~/.config/nvim-backup ]; then
    mkdir ~/.config/nvim-backup
   fi
   # Create a timestamped backup of the .config/nvim directory
   timestamp=$(date +%Y%m%d-%H%M%S)
   cp -r ~/.config/nvim ~/.config/nvim-backup/$timestamp
   ;;
 *)
   echo -e "${WHITE}Skipping backup...${NC}"
   ;;
esac

# Install NvChad
echo -e "${GREEN}-==Installing NvChad ...==-${NC}"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 > /dev/null 2>&1

#  Cloning Repository
echo -e "${GREEN}-==Cloning Repository ...==-${NC}"
git clone https://github.com/dreamsofcode-io/neovim-cpp.git > /dev/null 2>&1
# Navigate to the cloned directory
cd neovim-cpp

#  Copying Files
echo -e "${GREEN}-==Copying Files==-${NC}"
rsync -av --exclude='README.md' --exclude='.git/' --exclude='install.sh' . ~/.config/nvim/lua/custom

#  Adding Command
# Display a warning message (for MasonInstallAll)
echo -e "${WHITE}Neovim is about to open to install needed packages, after it downloaded the packages, quit neovim with quit command! and wait for script to do the rest.${NC}"

# Ask user for confirmation
read -p "Do you understand the instructions? (yes/no) " response
case "$response" in
 [yY][eE][sS]|[yY]) 
     echo -e "${GREEN}-==Adding MasonInstallAll Command==-${NC}"
     # Append the MasonInstallAll command to the init.lua file
     echo 'vim.cmd("MasonInstallAll")' >> ~/.config/nvim/init.lua
     # Open Neovim
     nvim
     ;;
 *)
     echo -e "${RED}Exiting...${NC}"
     exit 1
     ;;
esac

#  Removing Command
echo -e "${GREEN}-==Removing MasonInstallAll Command==-${NC}"
# Remove the command from init.lua
sed -i '/^vim.cmd("MasonInstallAll")$/d' ~/.config/nvim/init.lua

#  Removing Directory
echo -e "${GREEN}-==Removing necessary files==-${NC}"
# Remove the cloned directory
rm -rf ../neovim-cpp
