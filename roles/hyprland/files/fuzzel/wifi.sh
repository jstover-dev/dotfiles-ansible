#!/bin/sh

ssids="$(nmcli -get-values bars,ssid device wifi list)"
nlines="$(echo "${ssids}" | wc -l || true)"
ssid="$(echo "${ssids}" \
    | awk -F: '{printf "%s %21s\n", $1, $2}' \
    | fuzzel -d --anchor top-right --width 26 --hide-prompt --lines "${nlines}" \
    | sed 's/^[^\ ]\+\ \+//' \
)"
[ -z "${ssid}" ] && exit 1
nmcli device wifi connect "${ssid}"

