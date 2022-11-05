#############
# Variables #
#############

export EDITOR='lvim'
export STARSHIP_CONFIG=~/.config/starship/config.toml

IS_WORK_LAPTOP=false
if [[ -d "$HOME/Repos/recursionpharma" ]]; then IS_WORK_LAPTOP=true; fi

###########
# ALIASES #
###########

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias c='clear'
alias cat='bat --paging=never'  # Replace cat with bat
alias dot='cd $HOME/Repos/ooloth/dotfiles'
alias f='vifm . .'                                                                   # open both vifm panes in cwd
alias h='cd $HOME'
alias ls='exa --all --group-directories-first'                                       # top level dir + files
alias ld='exa --all --git --group-directories-first --header --long'                 # top level details
alias lt='exa --all --git-ignore --group-directories-first -I .git --tree --level=1' # file tree (all levels)
alias lt2='lt --level=2'                                                             # file tree (2 levels only)
alias lt3='lt --level=3'                                                             # file tree (3 levels only)
alias lt4='lt --level=4'                                                             # file tree (4 levels only)
alias mini="s michael@192.168.68.102" # automatically log in using SSH key pair
alias mu='cd $HOME/Repos/ooloth/michaeluloth.com'
alias nvm='fnm'
alias oo='cd $HOME/Repos/ooloth'
alias pilots='cd $HOME/Repos/ooloth/download-pilots'
alias s="kitty +kitten ssh" # Alias kitty's ssh kitten

function sl() { ln -sfv $1 $2 } # easier symlinking

alias t='tmux a'

function u() {
  brew upgrade && brew update && brew cleanup && brew doctor
  if $IS_WORK_LAPTOP; then
    echo '🚨 Run "brew info librdkafka" and manually update the version in .zshrc if it has changed.'
  fi
}

alias v='vim'
alias vim='lvim'
# TODO: make yarn/npm/python agnostic
alias y='yarn install'
alias yd='y && yarn start:dev'
alias yb='y && yarn build'
alias ys='yb && yarn serve'
alias yc='yarn clean'
alias yt='yarn test:dev'

function ytp() { yt --testPathPattern=$1 }

alias ytu='yarn test:update'
alias ze="$EDITOR $HOME/Repos/ooloth/dotfiles/config/zsh/.zshrc"
alias zs="source $HOME/.config/zsh/.zshrc"

#################
# Auto commands #
#################

function chpwd() { exa --all --group-directories-first } # list directory contents after changing directories

eval "$(fnm env --use-on-cd)" # use node version defined in .nvmrc when changing directories
eval "$(starship init zsh)"

########
# PATH #
########

export PATH=/usr/local/bin:$PATH # Add Homebrew's executable directory to front of PATH
export PATH=$HOME/.local/bin:$PATH # Add lvim location to PATH
export PATH=$HOME/.cargo/bin:$PATH # Add cargo to PATH

#############
# Recursion #
#############

# Only add the following on my work laptop
if $IS_WORK_LAPTOP; then

   # Aliases
   alias r='cd $HOME/Repos/recursionpharma'
   alias pa='cd $HOME/Repos/recursionpharma/dash-phenoapp-v2'
   alias pab='cd $HOME/Repos/recursionpharma/dash-phenoapp-v2/phenoapp'
   alias paf='cd $HOME/Repos/recursionpharma/dash-phenoapp-v2/react-app'
   alias pr='cd $HOME/Repos/recursionpharma/phenoreader'
   alias psa='cd $HOME/Repos/recursionpharma/phenoservice-api'
   alias psc='cd $HOME/Repos/recursionpharma/phenoservice-consumer'

   # TODO: move to tmux session creation scripts?
   # Activate python venv (if any) after changing directories
   chpwd() {
      if [[ $PWD =~ "recursionpharma/dash-phenoapp-v2" ]]; then
         pyenv shell dash-phenoapp-v2
      elif [[ $PWD =~ "recursionpharma/eng-onboarding" ]]; then
         pyenv shell eng-onboarding
      elif [[ $PWD =~ "recursionpharma/phenoreader" ]]; then
         pyenv shell phenoreader
      elif [[ $PWD =~ "recursionpharma/phenoservice-api" ]]; then
         pyenv shell phenoservice-api
      elif [[ $PWD =~ "recursionpharma/phenoservice-consumer" ]]; then
         pyenv shell phenoservice-consumer
      else
         pyenv shell system
      fi

      exa --all --group-directories-first
   }

   # Confluent-Kafka
   # TODO: update these whenever I run brew update
   export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/1.9.2/include
   export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/1.9.2/lib

   # OpenSSL
   export PATH=/opt/homebrew/opt/openssl@3/bin:$PATH

   # Pyenv
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   eval "$(pyenv init -)"
   # eval "$(pyenv virtualenv-init -)"
   # eval "$(va)" # activate Python virtual env (if applicable)

   # Python
   export PYTHONPATH=.
   export MYPYPATH=.

   # Vault (generated by eng-onboarding check-griphook script)
   export VAULT_ADDR=$(cat /Users/michael.uloth/.griphook/vault-addr)
   export VAULT_AUTH_METHOD=github
   export VAULT_AUTH_CREDS_PATH=/Users/michael.uloth/.griphook/github.pat
   export VAULT_TOKEN=$(cat /Users/michael.uloth/.griphook/vault-token)
   export GITHUB_TOKEN=$(cat $VAULT_AUTH_CREDS_PATH)

   # The next line updates PATH for the Google Cloud SDK.
   if [ -f '/Users/michael.uloth/google-cloud-sdk/path.zsh.inc' ]; then
   . '/Users/michael.uloth/google-cloud-sdk/path.zsh.inc';
   fi

   # The next line enables shell command completion for gcloud.
   if [ -f '/Users/michael.uloth/google-cloud-sdk/completion.zsh.inc' ]; then
   . '/Users/michael.uloth/google-cloud-sdk/completion.zsh.inc';
   fi

fi

###############
# zsh plugins #
###############

# TODO: store my plugin configs in separate files and source them?
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
