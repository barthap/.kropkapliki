# Bun
alias b="bun"

# Vim
alias vim2="NVIM_APPNAME=nvim2 nvim"

# Expo development
alias expo-dev-cli="node ~/dev/expo-cli/packages/expo-cli/bin/expo.js"
alias eas-dev-cli="node ~/dev/eas-cli/bin/run"
alias easd="node ~/dev/eas-cli/bin/run"

# Comm / Terraform
alias tf="terraform"
alias tf-prod="terraform workspace select production"
alias tf-staging="terraform workspace select staging"

# Git
alias gri="git rebase -i"
alias grc="git rebase --continue"

# Kitty
alias rg="kitty +kitten hyperlinked_grep"
alias icat="kitty +kitten icat"
alias s="kitty +kitten ssh"

# Utilities
alias top="btop"
alias awsl="aws --endpoint-url=http://localhost:4566"
alias kot="\\cat"
alias tldrf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,70% | xargs -o -r -I {} sh -c "tldr {} | less"'
alias l="eza -alF"
alias name-tab="kitty @ set-tab-title"
