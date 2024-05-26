#!/usr/bin/env zsh

tpm_path="$HOME/.config/tmux/plugins/tpm"
dotfiles="$HOME/Repos/ooloth/dotfiles"

# Install if missing
if [ ! -d "$tpm_path" ]; then
  source "$dotfiles/bin/install/tmux.zsh"
fi

# Then, update
source "$dotfiles/config/zsh/banners.zsh"
info "✨ Updating tmux dependencies"

# see: https://github.com/tmux-plugins/tpm/blob/master/docs/managing_plugins_via_cmd_line.md
"$tpm_path/bin/clean_plugins"
"$tpm_path/bin/install_plugins"
"$tpm_path/bin/update_plugins" all

# Reload tmux config automatically if it's running
if pgrep -q tmux; then
  # see: https://github.com/tmux-plugins/tpm?tab=readme-ov-file#installation
  printf "\n🔁 Reloading tmux config\n"
  tmux source ~/.config/tmux/tmux.conf
fi

printf "\n🚀 Done updating tpm plugins\n"