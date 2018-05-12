#!/usr/bin/env bash
### every exit != 0 fails the script


ln -s /usr/bin/chromium-browser /usr/bin/google-chrome
### fix to start chromium in a Docker container, see https://github.com/ConSol/docker-headless-vnc-container/issues/2
echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > $HOME/.chromium-browser.init
#echo "CHROMIUM_FLAGS='--start-maximized --user-data-dir'" > $HOME/.chromium-browser.init