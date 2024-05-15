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
echo -e "your current configuration will be removed.${NC}"
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
   echo -e "${WHITE}deleting current  neovim folder...${NC}"
   rm -rf ~/.config/nvim
   ;;
esac

# Install NvChad
echo -e "${GREEN}-==Installing NvChad ...==-${NC}"
git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1

# open NvChad for the first time to download lazy plugin
echo -e "${WHITE}The Script will open neovim to install lazy plugin. ${RED} after installation was done, quit using :qa command${NC}"

# Ask user for confirmation
read -p "type (yes) to continue => " response
case "$response" in
 [yY][eE][sS]|[yY]) 
     # open Neovim
     nvim
     ;;
esac

#  Copying Files
echo -e "${GREEN}-==Copying Files==-${NC}"
rsync -av cfg/* ~/.config/nvim/lua/

#  Adding Command
# Display a warning message (for MasonInstallAll)
echo -e "${WHITE}Neovim is about to open to install needed packages, after it downloaded the packages, quit neovim with :qa command! and wait for script to do the rest.${NC}"

# Ask user for confirmation
read -p "Do you understand the instructions? (y/n) => " response
case "$response" in
 [yY][eE][sS]|[yY]) 
     echo -e "${GREEN}-== Adding MasonInstallAll Command ==-${NC}"
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

read -p "Do you want to install and configure Silicon for screenshots? (y/n) => " response
case "$response" in
 [yY][eE][sS]|[yY]) 
   # install Silicon from pacman database (possible to install via cargo aswell for other Distros)
   if [[ "$ID" = "arch" ]]; then
     # ARCH LINUX PACMAN INSTALLATION 
     sudo pacman -S noto-fonts-emoji silicon
   else
     # install silicon from cargo
     cargo install silicon
    echo -e "${GREEN}[+] ${WHITE}make sure to add cargo bin folder in your profile ${RED}(/home/$USER/.cargo/bin)${NC}"
    echo -e "${GREEN}[+]${WHITE} make sure to install noto-fonts-emoji on your system after.${NC}"
   fi
   awk -i inplace '/return {/ {print; print "  {\"michaelrommel/nvim-silicon\", lazy = true, cmd = \"Silicon\", config = function() require(\"silicon\").setup({ font = \"JetBrainsMono Nerd Font=34; Noto Color Emoji=34\" }) end },"; next}1' ~/.config/nvim/lua/plugins/init.lua
   ;;
 *)
   echo -e "${WHITE}Skipping Silicon Installation...${NC}"
   ;;
esac

clear
echo -e "${GREEN}[+]${WHITE} INSTALLATION DONE :) ${NC}"
