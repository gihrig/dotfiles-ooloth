if $IS_WORK_LAPTOP; then

  eo() { cd $HOME/Repos/recursionpharma/eng-onboarding; }
  mp() { cd $HOME/Repos/recursionpharma/mapapp-public; }
  n() { npm install -- $1; }
  nb() { n && npm run build; }
  nfc() { npm run format:check; }
  nff() { npm run format:fix; }
  nk() { npm run typecheck; }
  nl() { npm run lint; }
  nlc() { npm run lint:check; }
  nlf() { npm run lint:fix; }
  ns() { n && npm run start; }
  nt() { npm run test -- $1; }
  pa() { cd $HOME/Repos/recursionpharma/dash-phenoapp-v2; }
  pab() { cd $HOME/Repos/recursionpharma/dash-phenoapp-v2/phenoapp; }
  paf() { cd $HOME/Repos/recursionpharma/dash-phenoapp-v2/react-app; }
  pm() { cd $HOME/Repos/recursionpharma/phenomap; }
  pr() { cd $HOME/Repos/recursionpharma/phenoreader; }
  psa() { cd $HOME/Repos/recursionpharma/phenoservice-api; }
  psc() { cd $HOME/Repos/recursionpharma/phenoservice-consumer; }
  r() { cd $HOME/Repos/recursionpharma; }
  rv() { pip install -U 'roadie[cli]' && roadie venv; } # see: https://pip.pypa.io/en/stable/cli/pip_install/#options

  activate_venv() {
    local CURRENT_DIRECTORY=$(basename $PWD)

    # if the correct venv is already active, do nothing
    if [[ "$PYENV_VERSION" == "$CURRENT_DIRECTORY" ]]; then
      return
    else
      eval "$(pyenv init -)"
    fi

    # if defined, activate the appropriate venv for this directory
    case $CURRENT_DIRECTORY in
      dash-phenoapp-v2 | phenoapp) pyenv shell dash-phenoapp-v2 ;;
      eng-onboarding)              pyenv shell eng-onboarding ;;
      phenomap)                    pyenv shell phenomap ;;
      phenoreader)                 pyenv shell phenoreader ;;
      phenoservice-api)            pyenv shell phenoservice-api ;;
      phenoservice-consumer)       pyenv shell phenoservice-consumer ;;
      *)                           eval export PYENV_VERSION='' ;;
    esac
  }

  # automatically activate appropriate venv when zsh first loads (called again in autocommands.zsh whenever cwd changes)
  activate_venv

  run() {
    local CURRENT_DIRECTORY=$(basename $PWD)

    case $CURRENT_DIRECTORY in
      dash-phenoapp-v2) python phenoapp/app.py ;;
      phenoapp)         pa && python phenoapp/app.py ;;
      react-app)        ns ;;
      *)                echo "🚨 No 'run' case defined for '/${CURRENT_DIRECTORY}' in work.zsh" ;;
    esac
  }

  # gcloud
  # see: https://cloud.google.com/sdk/docs/downloads-interactive
  # The next line updates PATH for the Google Cloud SDK.
  if [ -f '/Users/michael.uloth/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/michael.uloth/google-cloud-sdk/path.zsh.inc'; fi

  # The next line enables shell command completion for gcloud.
  if [ -f '/Users/michael.uloth/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/michael.uloth/google-cloud-sdk/completion.zsh.inc'; fi

  # kafka
  # TODO: update versions whenever I run brew update
  export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/2.1.1/include
  export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/2.1.1/lib

  # netskope
  # see: https://github.com/recursionpharma/netskope_dev_tools
  source "$HOME/.config/netskope/env.sh"

  # npm
  # export GITHUB_NPM_TOKEN="$(cat $HOME/.griphook/github.pat)"
  # export GITHUB_NPM_TOKEN=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

  # openSSL
  export PATH=/opt/homebrew/opt/openssl@3/bin:$PATH
  export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"

  # pyenv
  # NOTE: do NOT add eval "$(pyenv init -)" or eval "$(pyenv virtualenv-init -)" here (they slow the shell down a lot)

  # python
  # see: https://github.com/recursionpharma/data-science-onboarding#cloning-some-internal-repos
  export PYTHONPATH="$PYTHONPATH:/Users/$USER"
  export MYPYPATH=.

  # roadie
  eval "$(_ROADIE_COMPLETE=source_zsh roadie)"

  # sbin
  export PATH="/opt/homebrew/sbin:$PATH"

  # vault (griphook)
  # see: https://github.com/recursionpharma/data-science-onboarding#setting-up-griphook
  source $HOME/.griphook/env
fi

