#!/bin/bash

active_ws=$(hyprctl activeworkspace -j | jq -r '.id')
active_monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')
other_monitor=$(hyprctl monitors -j | jq -r '.[].name' | grep -v "^$active_monitor$" | head -n1)

hyprctl dispatch moveworkspacetomonitor "$active_ws $other_monitor"
