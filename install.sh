#!/bin/env bash

# TODO: install homebrew here (e.g. via nix)
stow homebrew
brew bundle --global

stow assorted
stow kitty
stow nvim

# TODO: Check if karabiner can be installed from here
stow karabiner
