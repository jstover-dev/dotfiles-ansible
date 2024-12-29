#!/bin/bash

echo "Installing plugins..."
sleep 1

NVIM_CONF="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim"
NVIM_DATA="${XDG_DATA_HOME:-${HOME}/.local/share}/nvim"

NVIM_INIT="${NVIM_CONF}/init.vim"
PLUGGED_DIR="${NVIM_DATA}/plugged"

nvim +'PlugInstall --sync' +qall -u <(cat <<EOF
call plug#begin('${PLUGGED_DIR}')
$(grep '^[ \t]*Plug' "${NVIM_INIT}")
call plug#end()
EOF
)
