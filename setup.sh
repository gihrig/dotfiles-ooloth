#!/usr/bin/env zsh

DOTFILES="$HOME/Repos/ooloth/dotfiles"

COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
  echo -e "\n\n${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

confirm_consent() {
  title "Welcome to your new Mac!"

  info "This installation will perform the following steps:\n"

  printf "1. Back up any existing dotfiles in your home folder\n"
  printf "2. Find your new dotfiles and symlink them where they need to be\n"
  printf "3. TBD...\n\n"

  vared -p "Sound good? (y/N) " -c key

  if [[ ! "$key" == 'y' ]]; then
    printf "\nNo worries! Maybe next time."
    printf "\nExiting..."
    exit 1
  else
    printf "\nExcellent! Here we go...\n"
  fi
}

confirm_macos() {
  title "Verifying prerequisites"

  info "Confirming this is a Mac."

  local os=$(uname)
  if [ "$os" != "Darwin" ]; then
    error "\nOops, it looks like this is a non-UNIX system. This script only works on a Mac.\n\nExiting..."
  fi

  success "\nThis is definitely a Mac. But you knew that already.\n"
}

confirm_command_line_tools() {
  info "Confirming the Xcode CLI tools are installed."

  if [ ! -d "$HOME/Library/Developer/CommanLineTools" ]; then
    # TODO: is there a way to install these automatically and continue?
    error "Apple's command line developer tools must be installed before running this script. To install them, run 'xcode-select --install' from the terminal and then follow the prompts. Once the command line tools have been installed, you can try running this script again."
  fi

  success "\nNice! That's usually the hard part.\n"
}

authenticate() {
  info "Confirming you are authorized to install things on this Mac.\n"

  sudo -v
  # Keep-alive: update existing `sudo` time stamp until setup has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  set -e

  success "Yup. That's the password. Have your way with this thing."
}

run_checks() {
  confirm_macos
  confirm_command_line_tools
  authenticate
}

create_ssh_keys() {
  info "Generating SSH public/private key pair...\n"

  # silent output, "id_rsa", overwrite existing, no password
  # https://security.stackexchange.com/a/23385
  # https://stackoverflow.com/a/43235320
  ssh-keygen -q -t rsa -b 2048 -N '' <<< ""$'\n'"y" 2>&1 >/dev/null

  printf "\n"
  info "Adding SSH key pair to ssh-agent and Keychain"

  # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
  eval "$(ssh-agent -s)" # confirm the agent is running (if not, this will start it)

  printf "\n"
  info "Creating SSH config file"

  create_missing_directory "$HOME/.ssh"

  SSH_CONFIG="$HOME/.ssh/config"

  if [ -f "$SSH_CONFIG" ]; then
    printf "SSH config file already exists. Skipping."
  else
    # Use SSH config settings that automatically load keys in ssh-agent and store passphrases in Keychain
    # https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
    touch "$SSH_CONFIG"
    printf "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_rsa" >> "$SSH_CONFIG"
  fi

  printf "\n"
  info "Adding keys to ssh-agent and Keychain"

  # Add SSH private key to ssh-agent and store the passphrase in Keychain
  ssh-add -K ~/.ssh/id_rsa

  printf "\n"
  info "Your turn!"

  printf "\nPlease open https://github.com/settings/ssh/new now and and the following SSH key to your GitHub account:\n\n"

  cat "$HOME/.ssh/id_rsa.pub"

  printf "\n"
  warning "Actually go do this! The next step requires SSH to be working.\n"

  vared -p "All set? (y/N)" -c gitHubKeyAdded

  if [[ ! "$gitHubKeyAdded" == 'y' ]]; then
    printf "\nYou have chosen...poorly.\n"
  else
    printf "\nExcellent!\n"
  fi
}

configure_ssh() {
  title "Configuring SSH"

  info "Checking for existing SSH keys..."

  if [[ ! -d "$HOME/.ssh" || ! -f "$HOME/.ssh/id_rsa" || ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
    info "SSH keys not found. Generating new keys..."
    create_ssh_keys
  else
    success "\nSSH keys found.\n"

    vared -p "Would you like to replace them with a new key pair (not recommended)? (y/N)" -c replaceKeys

    if [[ ! "$replaceKeys" == 'y' ]]; then
      printf "\nMakes sense! Keeping the existing keys.\n"
    else
      printf "\nYou got it! Here we go...\n"
      create_ssh_keys
    fi
  fi

  success "\nDone setting up SSH."
}

create_missing_directory() {
  if [ ! -d "$1" ]; then
    echo -e "Creating $1"
    mkdir -p "$1"
  fi
}

clone_dotfiles() {
  title "Locating dotfiles"

  # Only clone dotfiles if they're missing (don't overwrite local changes!)
  if [ ! -d "$DOTFILES" ]; then
    info "Cloning a fresh copy of dotfiles"

    create_missing_directory "$HOME/Repos/ooloth"

    printf "\n"
    info "If you're asked if you want to continue connecting, type 'yes'...\n"

    git clone "git@github.com:ooloth/dotfiles.git" "$DOTFILES"

    success "\nCloned new dotfiles to $DOTFILES"
  else
    success "Found dotfiles in $DOTFILES."
  fi
}

backup_config() {
  DATE_STAMP=$(date +"%F-%H-%M-%S")
  BACKUP_DIR=$HOME/Desktop/dotfiles-backup-$DATE_STAMP

  title "Backing up current dotfiles"

  info "Creating backup directory at $BACKUP_DIR"

  create_missing_directory "$BACKUP_DIR"

  # Copy ~/.zshenv to backup folder
  if [ -d "$HOME/.config" ]; then
    info "Backing up ~/.config"
    cp -R "$HOME/.config" "$BACKUP_DIR"
  fi

  # Copy ~/.config folder to backup folder
  if [ -d "$HOME/.config" ]; then
    info "Backing up ~/.config"
    cp -R "$HOME/.config" "$BACKUP_DIR"
  fi

  # Back up ~/.ssh folder
  if [ -d "$HOME/.ssh" ]; then
    info "Backing up ~/.ssh"
    cp -R "$HOME/.ssh" "$BACKUP_DIR"
  fi

  # Back up ~/.terminfo folder
  if [ -d "$HOME/.terminfo" ]; then
    info "Backing up ~/.terminfo"
    cp -R "$HOME/.terminfo" "$BACKUP_DIR"
  fi

  success "\nDone backing up your old dotfiles."
}

create_symlinks() {
  title "Symlinking dotfiles to home folder"

  source "$DOTFILES/bin/update/symlinks.zsh"

  success "\nDone symlinking new dotfiles to the home folder."
}

set_up_homebrew() {
  title "Setting up Homebrew"

  source "$DOTFILES/bin/install/homebrew.zsh"
  source "$DOTFILES/bin/update/homebrew.zsh"

  success "\nDone setting up Homebrew."
}

set_up_terminfo() {
  title "Updating terminfo"

  info "adding tmux.terminfo"
  tic -x "$DOTFILES/terminfo/tmux.terminfo"

  info "adding xterm-256color-italic.terminfo"
  tic -x "$DOTFILES/terminfo/xterm-256color-italic.terminfo"

  success "\nDone configuring terminfo settings."
}

set_up_zsh() {
  set_up_terminfo

  title "Configuring zsh shell"

  local shell_path="$(command -v zsh)"

  info "Changing your shell to zsh...\n"

  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    laptop_echo "Adding '${shell_path}' to /etc/shells"
    sudo sh -c "echo ${shell_path} >> /etc/shells"
  fi

  sudo chsh -s "$shell_path" "$USER"

  success "\nDone configuring zsh shell."
}

set_up_rust() {
  title "Setting up Rust"

  source "$DOTFILES/bin/install/rust.zsh"

  success "\nDone setting up Rust."
}

set_up_node() {
  title "Installing node and general global dependencies..."

  source "$DOTFILES/bin/install/node.zsh"

  success "\nDone installing node and global dependencies."
}

set_up_tmux() {
  title "Setting up tmux"

  source "$DOTFILES/bin/install/tpm.zsh"

  success "\nDone setting up tmux."
}

set_up_neovim() {
  title "Setting up neovim"

  source "$DOTFILES/bin/install/neovim.zsh"

  success "\nDone setting up neovim."
}

set_up_yazi() {
  title "Setting up yazi"

  source "$DOTFILES/bin/install/yazi.zsh"

  success "\nDone setting up yazi."
}

configure_macos() {
  title "Configuring Mac preferences"

  info "Configuring general settings...\n"

  printf "Expand save dialog by default\n"
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

  printf "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)\n"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  printf "Enable subpixel font rendering on non-Apple LCDs\n"
  defaults write NSGlobalDomain AppleFontSmoothing -int 2

  printf "\n"
  info "Configuring Finder...\n"

  printf "Show all filename extensions\n"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  printf "Show hidden files by default\n"
  defaults write com.apple.Finder AppleShowAllFiles -bool false

  printf "Use current directory as default search scope in Finder\n"
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  printf "Show Path bar in Finder\n"
  defaults write com.apple.finder ShowPathbar -bool true

  printf "Show Status bar in Finder\n"
  defaults write com.apple.finder ShowStatusBar -bool true

  printf "Show the ~/Library folder in Finder\n"
  chflags nohidden ~/Library

  printf "\n"
  info "Configuring Safari...\n"

  printf "Enable Safari’s debug menu\n"
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  # echo "Kill affected applications"

  # for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done

  success "\nFinished configuring Mac system preferences."
}

configure_apps() {
  title "Configuring app preferences"

  warning "TODO: configure apps"

  success "\nFinished configuring app preferences."
}

suggest_restart() {
  title "Congratulations! Your Mac is nearly set up"

  info "To apply your your preferences, your computer needs to restart.\n\n"

  vared -p "Are you ready to restart now (recommended)? (y/N) " -c restart_choice

  if [[ "$restart_choice" = 'y' ]]; then
    printf "\nExcellent choice. When you're back, remember to complete the manual follow-up steps in the README.\n"
    printf "\nRestarting..."
    sudo shutdown -r now
  else
    printf "\nNo worries! Your terminal session will now refresh...\n"
    exec -l $SHELL

    success "\nDone. Enjoy your new Mac!\n"
  fi
}

confirm_consent \
  && run_checks \
  && configure_ssh \
  && clone_dotfiles \
  && backup_config \
  && create_symlinks \
  && set_up_homebrew \
  && set_up_zsh \
  && set_up_rust \
  && set_up_node \
  && set_up_tmux \
  && set_up_neovim \
  && set_up_yazi \
  && configure_macos \
  && configure_apps \
  && suggest_restart
