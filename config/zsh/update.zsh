u() {

  # If rust is installed, update its dependencies
  if command -v rustup &> /dev/null; then
    info "✨ Updating rust dependencies"
    rustup update
  fi
  source "$DOTFILES/bin/update/symlinks.zsh"

  info "✨ Updating yazi dependencies"
  git -C "$HOME/Repos/yazi-rs/flavors" pull;

  info "✨ Updating neovim dependencies"
  git -C "$HOME/Repos/knubie/vim-kitty-navigator" pull;

  # TODO: update lazy.nvim plugins here as well? in all nvim instances? pin dependencies to avoid unwanted updates?

  # If tpm is installed, update its dependencies
  if [ -d "$HOME/.config/tmux/plugins/tpm" ]; then
    info "✨ Updating tmux dependencies"
    # see: https://github.com/tmux-plugins/tpm/blob/master/docs/managing_plugins_via_cmd_line.md
    ~/.config/tmux/plugins/tpm/bin/clean_plugins
    ~/.config/tmux/plugins/tpm/bin/install_plugins
    ~/.config/tmux/plugins/tpm/bin/update_plugins all
  fi

  # see: https://docs.npmjs.com/cli/v9/commands/npm-update?v=true#updating-globally-installed-packages
  info "✨ Updating Node $(node -v) global dependencies"
	ng

  # If gcloud is installed, update its components
  if command -v gcloud &> /dev/null; then
    info "✨ Updating gcloud components"
    # The "quiet" flag skips interactive prompts by using the default or erroring (see: https://stackoverflow.com/a/31811541/8802485)
    gcloud components update --quiet
  fi

  info "✨ Updating brew packages"
  # Install missing packages, upgrade outdated packages, and remove old versions
  brew bundle --cleanup
	brew update && brew upgrade && brew autoremove && brew cleanup && brew doctor

  # Avoid potential issues on work laptop caused by updating macOS too early
  if ! $IS_WORK; then
    info "💻 Updating macOS software (after password, don't cancel!)"
    sudo softwareupdate --install --all --restart --agree-to-license --verbose
  fi

  info "🔄 Reloading shell"
  R
}