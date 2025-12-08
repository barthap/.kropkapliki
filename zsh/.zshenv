[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
export PATH="$HOME"/.nix-profile/bin:/nix/var/nix/profiles/default/bin:"${PATH}"

if [[ -n "$CLAUDECODE" ]]; then
  eval "$(direnv hook zsh)"
fi
