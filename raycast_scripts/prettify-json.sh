#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Prettify JSON
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Dev utils

# Documentation:
# @raycast.description Prettify JSON from clipboard
# @raycast.author Barthap
# @raycast.authorURL https://github.com/barthap

pbpaste | jq | pbcopy
