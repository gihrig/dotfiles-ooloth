source $HOME/.config/.secrets

export PATH="/usr/local/sbin:$PATH"

# Oh my zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Prompt
SPACESHIP_EXEC_TIME_SHOW=false
SPACESHIP_GIT_SYMBOL=''
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_PROMPT_ORDER=(user dir host git node vi_mode line_sep jobs char)
SPACESHIP_VI_MODE_PREFIX='in '
SPACESHIP_VI_MODE_SHOW=true
autoload -U promptinit; promptinit
prompt spaceship

# Faster ESC response in vi mode
KEYTIMEOUT=1

# Editor
export EDITOR='nvim'

# fnm
eval "$(fnm env --multi --use-on-cd)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# tell fzf to use ripgrep and include hidden files in searches
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"

# bat (https://github.com/sharkdp/bat#highlighting-theme)
export BAT_THEME="gruvbox"

# GitHub CLI tab completion (https://www.youtube.com/watch?v=UNJVqevfg-8)
eval "$(gh completion -s zsh)"

# Google Cloud SDK (ecobee)
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

###########
# ALIASES #
###########

# Replace vim with neovim
alias vim='nvim'
alias v='vim'

# Replace nvm with fnm
alias nvm='fnm'

# Open both vifm panes in cwd
alias vifm='vifm . .'

# Replace ls with exa
alias ls='exa --all --group-directories-first'                             # top level dir + files
alias lsa='ls --git-ignore -I .git --recurse'                              # nested dirs + files
alias ld='exa --all --git --group-directories-first --header --long'       # top level details
alias lda='ld --git-ignore -I .git --recurse'                              # nested details
alias lt='exa --all --git-ignore --group-directories-first -I .git --tree' # file tree (all levels)
alias lt2='lt --level=2'                                                   # file tree (2 levels)
alias lt3='lt --level=3'                                                   # file tree (3 levels)
alias lt4='lt --level=4'                                                   # file tree (4 levels)

# List directory contents after moving
chpwd() ls

# Up we go
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Jump to common directories
alias cdh='cd $HOME'
alias cds='cd $HOME/Sites'
alias cde='cd $HOME/Sites/ecobee/consumer-website'
alias cdd='cd $HOME/Sites/projects/dotfiles'
alias cdms='cd $HOME/Sites/projects/mac-setup'
alias cdmu='cd $HOME/Sites/projects/michaeluloth.com'
alias cdgt='cd $HOME/Sites/projects/gatsbytutorials.com'
alias cdn='ssh ooloth@192.168.0.104'

# Common ecobee commands
alias yd='yarn install && yarn develop'
alias jw='$(npm bin)/jest --watch' # tests of uncommitted changes
alias jwa='$(npm bin)/jest --watchAll' # all tests
jwp() {
   $(npm bin)/jest --watch --testPathPattern=$1 # tests matching pattern
}
alias gp='git push --no-verify'
alias yb='yarn build'
alias ys='yarn storybook'

# Speed test
alias speed='speedtest-cli'

