#!/bin/bash

echo "Installing WinRAR using Wine\n"
sleep 3
wine /home/appbox/winrar.exe /s
rm -fr /home/appbox/winrar.exe
rm -fr /home/appbox/install_winrar.sh