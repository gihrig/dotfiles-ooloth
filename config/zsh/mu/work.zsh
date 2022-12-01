if $IS_WORK_LAPTOP; then

   # Aliases
   alias r='cd $HOME/Repos/recursionpharma'
   function rv() { pip install -U 'roadie[cli]' && roadie venv }
   function eo() { cd $HOME/Repos/recursionpharma/eng-onboarding && pyenv shell eng-onboarding }
   function pa() { cd $HOME/Repos/recursionpharma/dash-phenoapp-v2 && pyenv shell dash-phenoapp-v2 }
   function pab() { cd $HOME/Repos/recursionpharma/dash-phenoapp-v2/phenoapp && source venv/bin/activate }
   alias paf='cd $HOME/Repos/recursionpharma/dash-phenoapp-v2/react-app'
   alias pm='cd $HOME/Repos/recursionpharma/phenomap'
   function pr() { cd $HOME/Repos/recursionpharma/phenoreader && pyenv shell phenoreader }
   function psa() { cd $HOME/Repos/recursionpharma/phenoservice-api && pyenv shell phenoservice-api }
   function psc() { cd $HOME/Repos/recursionpharma/phenoservice-consumer && pyenv shell phenoservice-consumer }

   # Confluent-Kafka
   # TODO: update these whenever I run brew update
   export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/1.9.2/include
   export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/1.9.2/lib

   # grpcio on M! (see: https://github.com/grpc/grpc/issues/30064)
   export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1 
   export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1 

   # OpenSSL
   export PATH=/opt/homebrew/opt/openssl@3/bin:$PATH
   export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
   export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
   export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"

   # Pyenv
   export PYENV_ROOT="$HOME/.pyenv"
   command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
   # NOTE: do NOT add eval "$(pyenv init -)" or eval "$(pyenv virtualenv-init -)" (they slow the shell down a lot)

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


