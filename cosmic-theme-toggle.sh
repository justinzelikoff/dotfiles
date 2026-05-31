#!/usr/bin/env zsh

# 1. Define the path to Cosmic's theme state file
THEME_FILE="$HOME/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark"

# 2. Check contents of file
# If the file contains 'true', it means dark mode is currently on
if [[ "$(cat $THEME_FILE)" == "true" ]]; then
	echo "false" > "$THEME_FILE"
	echo "Switched to Light Mode"
else
	echo "true" > "$THEME_FILE"
	echo "Switched to Dark Mode"
fi
