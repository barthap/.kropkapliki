The `.zprofile` should be automatically modified by Homebrew and others (e.g. `rbenv`):

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by `rbenv init` on Mon Sep 29 12:41:11 CEST 2025
eval "$(rbenv init - --no-rehash zsh)"
```

## Structure

The ZSH configuration is organized with optional modularization:

- `.zshrc` - Main configuration file with inline fallbacks
- `.zshenv` - Environment setup (sourced for all shells)
- `.env.zsh.example` - Template for sensitive environment variables
- `.config/zsh/` - Optional modular configuration directory
  - `aliases.zsh` - Command aliases
  - `completions/` - Completion scripts (e.g., graphite.zsh)
  - `.env.zsh` - Your private environment variables (gitignored)

## Installation

Managed via GNU Stow from the dotfiles repository:

```bash
cd ~/.dotfiles
stow zsh
```

This creates symlinks from `~/.dotfiles/zsh/` to your home directory.

## Customization

The `.zshrc` automatically loads modular files from `~/.config/zsh/` if they exist, but includes inline fallbacks for backward compatibility. This means:

- **With modular files**: Cleaner main config, easy to add/modify aliases and completions
- **Without modular files**: Everything still works using inline definitions

### Managing Sensitive Environment Variables

For API keys, tokens, and other secrets:

1. Copy the example file:

   ```bash
   cp ~/.dotfiles/zsh/.env.zsh.example ~/.config/zsh/.env.zsh
   ```

2. Edit `~/.config/zsh/.env.zsh` and add your actual values:

   ```bash
   export OPENAI_API_KEY="sk-your-actual-key"
   export GITHUB_TOKEN="ghp_your-actual-token"
   ```

3. The `.env.zsh` file is automatically gitignored and will never be committed

### Adding Custom Aliases

```bash
echo 'alias myalias="my command"' >> ~/.config/zsh/aliases.zsh
```

### Adding Custom Completions

```bash
# Create a new completion file in ~/.config/zsh/completions/
# It will be automatically sourced on shell startup
```

## Configuration Reference

At the end of `.zshrc`, there's a reference section documenting all available oh-my-zsh configuration options for easy reference.
