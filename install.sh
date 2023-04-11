#!/bin/env bash

# TODO: install homebrew here (e.g. via nix)
stow homebrew
brew bundle --global

stow kitty
stow nvim
