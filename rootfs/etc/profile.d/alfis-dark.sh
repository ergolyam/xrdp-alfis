#!/usr/bin/env sh

if [ ! -f /tmp/darkmode ]; then
    sed -i 's#^dark_theme = true#dark_theme = false#' /data/alfis.toml
fi
