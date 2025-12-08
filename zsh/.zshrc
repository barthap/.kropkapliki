### ENVIRONMENT VARIABLES

# Load sensitive environment variables (API keys, tokens, etc.)
# Copy .env.zsh.example to .env.zsh and fill in your values
[[ -f "$HOME/.config/zsh/.env.zsh" ]] && source "$HOME/.config/zsh/.env.zsh"
[[ -f "$HOME/.env.zsh" ]] && source "$HOME/.env.zsh"

export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_HOME="$HOME/Library/Android/sdk"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# export JAVA_HOME=/Applications/Android\ Studio.app/Contents/jre/Contents/Home
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
# export JAVA_HOME="$HOME/Library/Java/JavaVirtualMachines/azul-11.0.13/Contents/Home"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# TODO: This shouldn't be necessary lol
export PROTOC=/nix/store/l2swk09x758sbdpx2phsr2ww3kj0c2w8-protobuf-21.12/bin/protoc

export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools/31.0.0/
# export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

export PATH=~/.npm-global/bin:$PATH
export PATH=~/Library/Python/3.8/bin/:$PATH
export PATH=~/Library/Android/sdk/cmake/3.22.1/bin/:$PATH
export PATH=~/.cargo/bin/:$PATH

### OH-MY-ZSH CONFIGURATION

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="muse"
### PLUGINS

plugins=(
  git
  yarn
  direnv
  brew
  macos
  zoxide
  rust
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

### USER CONFIGURATION

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

### ALIASES

# Load aliases from modular file if available
if [[ -f "$HOME/.config/zsh/aliases.zsh" ]]; then
  source "$HOME/.config/zsh/aliases.zsh"
else
  # Fallback: inline aliases
  alias b="bun"
  alias tf="terraform"
  alias gri="git rebase -i"
  alias grc="git rebase --continue"
  alias icat="kitty +kitten icat"
  alias s="kitty +kitten ssh"
  alias top="btop"
  alias awsl="aws --endpoint-url=http://localhost:4566"
  alias tldrf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,70% | xargs -o -r -I {} sh -c "tldr {} | less"'
  alias l="eza -alF"
  alias name-tab="kitty @ set-tab-title"
fi

### SHELL OPTIONS

# GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot.
setopt globdots

### TOOL INITIALIZATION

# Custom scripts
export PATH=~/scripts:$PATH

export GPG_TTY=$(tty)

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" --no-use # This loads nvm

export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"

eval "$(zoxide init zsh)"

export LIBCLANG_PATH="$HOME/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-19.1.2_20250225/esp-clang/lib"
export PATH="$HOME/.rustup/toolchains/esp/xtensa-esp-elf/esp-14.2.0_20240906/xtensa-esp-elf/bin:$PATH"

# kitty-scrollback.nvim (requires zsh 5.9+)
autoload -Uz edit-command-line
zle -N edit-command-line
function kitty_scrollback_edit_command_line() {
  local VISUAL="$HOME/.local/share/nvim/lazy/kitty-scrollback.nvim/scripts/edit_command_line.sh"
  zle edit-command-line
  zle kill-whole-line
}
zle -N kitty_scrollback_edit_command_line
bindkey '^x^e' kitty_scrollback_edit_command_line

### COMPLETIONS

# Load completion scripts from modular directory
for completion in "$HOME/.config/zsh/completions"/*.zsh(N); do
  source "$completion"
done

################################################################################
### OH-MY-ZSH CONFIGURATION REFERENCE
### Available options you can uncomment/enable as needed
################################################################################

# Theme options:
# - Set to "random" to load a random theme each time
# - See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Completion options:
# CASE_SENSITIVE="true"              # Use case-sensitive completion
# HYPHEN_INSENSITIVE="true"          # _ and - will be interchangeable
# COMPLETION_WAITING_DOTS="true"     # Display red dots whilst waiting for completion
#                                    # (may cause issues with multiline prompts in zsh < 5.7.1)

# Update options:
# DISABLE_AUTO_UPDATE="true"         # Disable bi-weekly auto-update checks
# DISABLE_UPDATE_PROMPT="true"       # Automatically update without prompting
# export UPDATE_ZSH_DAYS=13          # Change auto-update frequency (in days)

# Terminal behavior:
# DISABLE_MAGIC_FUNCTIONS="true"     # Fix pasting URLs and other text issues
# DISABLE_LS_COLORS="true"           # Disable colors in ls
# DISABLE_AUTO_TITLE="true"          # Disable auto-setting terminal title
# ENABLE_CORRECTION="true"           # Enable command auto-correction

# VCS options:
# DISABLE_UNTRACKED_FILES_DIRTY="true"  # Don't mark untracked files as dirty
#                                       # (makes repo status check much faster)

# History options:
# HIST_STAMPS="mm/dd/yyyy"           # Timestamp format in history
#                                    # Options: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"

# Custom folder:
# ZSH_CUSTOM=/path/to/new-custom-folder  # Use different custom folder

# Language environment:
# export LANG=en_US.UTF-8
# export MANPATH="/usr/local/man:$MANPATH"

# Compilation flags:
# export ARCHFLAGS="-arch x86_64"

