#!/bin/bash

if [ -f /usr/bin/cgserver ]; then
	sudo rm /usr/bin/cgserver
fi

if [ -f /usr/bin/cgs ]; then
	sudo rm /usr/bin/cgs
fi

if [ -d /usr/local/cgserver ]; then 
	sudo rm -rf /usr/local/cgserver
fi

echo "Successfully uninstalled cgserver."