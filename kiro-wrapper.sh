#!/bin/bash
export GTK_MODULES=
# Suppress update check logs
export ELECTRON_NO_ATTACH_CONSOLE=1
exec /app/Kiro/kiro --no-sandbox "$@" > /dev/null 2>&1
