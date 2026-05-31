#!/usr/bin/env zsh

# ==============================================
# CONFIGURATION & VARIABLES
# ==============================================
THEME_FILE="$HOME/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark"

# ==============================================
#  MODULES (FUNCTIONS)
#  ============================================
#
#  Module: Update Kitty Termincal Theme
update_kitty_theme() {
	local target_mode=$1

	if [[ "$target_mode" == "light" ]]; then
		kitty +kitten themes --reload-in=all "Alabaster"
	else
		kitty +kitten themes --reload-in=all "3024 Night"
		fi
}

# 1. Define the path to Cosmic's theme state file
THEME_FILE="$HOME/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark"

# 2. Check contents of file
# If the file contains 'true', it means dark mode is currently on
if [[ "$(cat $THEME_FILE)" == "true" ]]; then
	# Update Cosmic Desktop File
	echo "false" > "$THEME_FILE"
  # Update Kitty
	update_kitty_theme "light"

	echo "Switched to Light Mode"
else
	# Update Cosmic Desktop FIle
	echo "true" > "$THEME_FILE"

	# Update Kitty
	update_kitty_theme "dark"

	echo "Switched to Dark Mode"
fi
