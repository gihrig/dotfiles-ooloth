
###########
# ALIASES #
###########

# Make clear faster to type
alias c='clear'

# Replace ls with exa
alias ls='exa --all --group-directories-first'                             # top level dir + files
alias ld='exa --all --git --group-directories-first --header --long'       # top level details
alias lt='exa --all --git-ignore --group-directories-first -I .git --tree' # file tree (all levels)
alias lt2='lt --level=2'                                                   # file tree (2 levels only)
alias lt3='lt --level=3'                                                   # file tree (3 levels only)
alias lt4='lt --level=4'                                                   # file tree (4 levels only)

# Jump to common directories
alias cdh='cd $HOME'
alias cdo='cd $HOME/Repos/ooloth'
alias cdd='cd $HOME/Repos/ooloth/dotfiles'
alias cdm='cd $HOME/Repos/ooloth/michaeluloth.com'
alias cdr='cd $HOME/Repos/recursionpharma'
alias cdpa='cd $HOME/Repos/recursionpharma/dash-phenoapp-v2'
alias cdpr='cd $HOME/Repos/recursionpharma/phenoreader'
alias cdps='cd $HOME/Repos/recursionpharma/phenoservice-api'

# Up we go
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# List directory contents after moving
chpwd() ls

# Replace vim with neovim
alias vim='nvim'
alias v='vim'

# Replace nvm with fnm
alias nvm='fnm'

# Open both vifm panes in cwd
alias vifm='vifm . .'

# Update homebrew
alias bu='brew upgrade && brew update && brew cleanup && brew doctor'

##################
# ecobee aliases #
##################

alias y='yarn install'
alias yd='y && yarn start:dev'
alias yb='y && yarn build'
alias ys='yb && yarn serve'
alias yc='yarn clean'
alias yt='yarn test:dev'
alias ytu='yarn test:update'
ytp() {
   yt --testPathPattern=$1
}

#####################
# Recursion aliases #
#####################

alias va='source venv/bin/activate'

#######
# fnm #
#######

eval "$(fnm env --use-on-cd)"

#######
# ENV #
#######
# export PYTHONPATH=.
# Add Homebrew's executable directory to the front of the PATH
export PATH=/usr/local/bin:$PATH

# Add lvim location to the PATH
export PATH=$HOME/.local/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/michael.uloth/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/michael.uloth/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/michael.uloth/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/michael.uloth/google-cloud-sdk/completion.zsh.inc'; fi

# Generated by eng-onboarding check-python script
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Generated by eng-onboarding check-griphook script
export VAULT_ADDR=$(cat /Users/michael.uloth/.griphook/vault-addr)
export VAULT_AUTH_METHOD=github
export VAULT_AUTH_CREDS_PATH=/Users/michael.uloth/.griphook/github.pat
export VAULT_TOKEN=$(cat /Users/michael.uloth/.griphook/vault-token)
export GITHUB_TOKEN=$(cat $VAULT_AUTH_CREDS_PATH)

# For phenoservice-api
export PATH=/opt/homebrew/opt/openssl@3/bin:$PATH

# For phenoservice-api
export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/1.9.0/include
export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/1.9.0/lib

export EDITOR='nvim'

##########
# PROMPT #
##########

export STARSHIP_CONFIG=~/.config/starship/config.toml
eval "$(starship init zsh)"

###########
# PLUGINS #
###########

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

