#!/bin/bash

# Base colors
export NOTIFY_COLOR_BG_DIM="#232A2E"
export NOTIFY_COLOR_BG0="#2D353B"
export NOTIFY_COLOR_BG1="#343F44"
export NOTIFY_COLOR_BG2="#3D484D"
export NOTIFY_COLOR_BG3="#475258"
export NOTIFY_COLOR_BG4="#4F585E"
export NOTIFY_COLOR_BG5="#56635F"

# Accent colors
export NOTIFY_COLOR_RED="#E67E80"
export NOTIFY_COLOR_ORANGE="#E69875"
export NOTIFY_COLOR_YELLOW="#DBBC7F"
export NOTIFY_COLOR_GREEN="#A7C080"
export NOTIFY_COLOR_BLUE="#7FBBB3"
export NOTIFY_COLOR_AQUA="#83C092"
export NOTIFY_COLOR_PURPLE="#D699B6"

# Background accent colors
export NOTIFY_COLOR_BG_RED="#543A48"
export NOTIFY_COLOR_BG_VISUAL="#514045"
export NOTIFY_COLOR_BG_YELLOW="#4D4C43"
export NOTIFY_COLOR_BG_GREEN="#425047"
export NOTIFY_COLOR_BG_BLUE="#3A515D"

# Create themed notification functions
notify-error() {
    notify-send "$1" "$2" -h "string:x-hyprnotify-color:${NOTIFY_COLOR_RED}"
}

notify-warning() {
    notify-send "$1" "$2" -h "string:x-hyprnotify-color:${NOTIFY_COLOR_ORANGE}"
}

notify-info() {
    notify-send "$1" "$2" -h "string:x-hyprnotify-color:${NOTIFY_COLOR_BLUE}"
}

notify-success() {
    notify-send "$1" "$2" -h "string:x-hyprnotify-color:${NOTIFY_COLOR_GREEN}"
}

# Function for custom colored notifications
notify-custom() {
    local color="$1"
    local title="$2"
    local message="$3"
    notify-send "$title" "$message" -h "string:x-hyprnotify-color:$color"
}
