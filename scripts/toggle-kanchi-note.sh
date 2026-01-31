#!/bin/bash
# Toggle Kanchi Note window visibility

WINDOW_ID=$(xdotool search --name "Kanchi Note" 2>/dev/null | head -1)

if [ -z "$WINDOW_ID" ]; then
    # App not running, start it
    /usr/share/kanchi-note/kanchi_note &
else
    # Check if window is visible
    if xdotool getactivewindow 2>/dev/null | grep -q "$WINDOW_ID"; then
        # Window is active, minimize it
        xdotool windowminimize "$WINDOW_ID"
    else
        # Window exists but not active, activate it
        xdotool windowactivate "$WINDOW_ID"
    fi
fi
