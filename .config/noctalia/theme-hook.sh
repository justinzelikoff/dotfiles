#!/usr/bin/env bash

LOG_FILE="/tmp/noctalia-matugen.log"

# Ignore secondary monitor triggers
if [ "$NOCTALIA_WALLPAPER_CONNECTOR" = "DP-2" ]; then
    exit 0
fi

# Ensure binary PATH availability
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:$PATH"

if [ -n "$NOCTALIA_WALLPAPER_PATH" ] && [ -f "$NOCTALIA_WALLPAPER_PATH" ]; then
    matugen image "$NOCTALIA_WALLPAPER_PATH" --prefer darkness >> "$LOG_FILE" 2>&1
fi
