#!/bin/bash

# make a temp dir
if ! [ -d /home/.__cgstmp ]; then 
	sudo mkdir /home/.__cgstmp
fi

# download and install cgs
(cd /home/.__cgstmp && (sudo wget WIP/install.sh) > /dev/null 2>&1 && sudo chmod +x install.sh && ./install.sh && cd && sudo rm -rf /home/.__cgstmp)