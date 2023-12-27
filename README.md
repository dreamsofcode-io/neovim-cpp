# Neovim CPP

[![GitHub license](https://img.shields.io/github/license/dreamsofcode-io/neovim-cpp)](https://github.com/dreamsofcode-io/neovim-cpp/blob/main/LICENSE)

this repository is a personal collection of dotfiles I've curated to optimize the experience of using Neovim with C++. It includes a selection of plugins and configurations that are specifically designed to enhance C++ development.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Shell Script](#Shell-Script)
- [Credits](#credits)

## Installation

To install Neovim CPP, follow these steps:

1. Clone the repository:
```bash
git clone https://github.com/dreamsofcode-io/neovim-cpp.git --depth 1
```
2. Change to the project directory:
  ```bash
cd neovim-cpp
```
3. Run the shell script to install the dependencies:
```bash
sh install.sh
```

## Usage

After installation, you can start using Neovim. The plugins and configurations included in this project will provide you with a comfortable and efficient environment for C++ development.

## Shell-Script

The `install.sh` shell script is responsible for installing the necessary dependencies for this repository. this script will open nvim with MasonInstallAll command to install all necessary plugins by adding it into init.lua file. so if the script didn't remove MasonInstallAll command from init.lua, you can remove it manually by running this in your terminal:
```bash
sed -i '/^vim.cmd("MasonInstallAll")$/d' ~/.config/nvim/init.lua
```

## Credits

This project was developed by [dreamsofcode-io](https://github.com/dreamsofcode-io).
