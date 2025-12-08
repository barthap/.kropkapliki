#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Gemini2Notion
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Dev Utils

# Documentation:
# @raycast.description Formats text from Gemini AI to be pastable to Notion
# @raycast.author Barthap
# @raycast.authorURL https://github.com/barthap

pbpaste | sed 's/^```[^[:space:]]*$/```/' | pbcopy
