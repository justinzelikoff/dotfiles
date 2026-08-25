#!/usr/bin/env zsh

# ==============================================
# CONFIGURATION & VARIABLES
# ==============================================
THEME_FILE="$HOME/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark"
KITTY_CONF="$HOME/.config/kitty/kitty.conf"

# ==============================================
#  MODULES (FUNCTIONS)
#  ============================================
#
#  Module: Update Kitty Terminal Theme & Opacity
update_kitty_theme() {
	local target_mode=$1

	if [[ "$target_mode" == "light" ]]; then
		# Update active instances live
		kitty @ set-background-opacity 1.0 2>/dev/null
		kitty +kitten themes --reload-in=all "Atom One Light"
		
		# Persist setting in kitty.conf
		sed -i 's/^background_opacity .*/background_opacity 1.0/' "$KITTY_CONF"
	else
		# Update active instances live
		kitty @ set-background-opacity 0.60 2>/dev/null
		kitty +kitten themes --reload-in=all "One Dark"
		
		# Persist setting in kitty.conf
		sed -i 's/^background_opacity .*/background_opacity .60/' "$KITTY_CONF"
	fi
}

# 1. Check contents of cosmic state file
if [[ "$(cat $THEME_FILE)" == "true" ]]; then
	# Update Cosmic Desktop File
	echo "false" > "$THEME_FILE"
	# Update Kitty
	update_kitty_theme "light"

	echo "Switched to Light Mode"
else
	# Update Cosmic Desktop File
	echo "true" > "$THEME_FILE"

	# Update Kitty
	update_kitty_theme "dark"

	echo "Switched to Dark Mode"
fi
