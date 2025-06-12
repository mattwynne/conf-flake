#!/bin/bash
id=$(osascript -e 'id of app "Cursor"')
defaults write "$id" ApplePressAndHoldEnabled -bool false
