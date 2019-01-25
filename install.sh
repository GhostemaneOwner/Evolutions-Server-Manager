#!/bin/bash
read -p "Running this script will kill any active DreamDaemon processes. Continue? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then

	# SIGKILL the daemons so they don't constantly error
	(sudo killall -s SIGKILL start-cron-daemon.sh) > /dev/null 2>&1
	(sudo killall -s SIGKILL start-git-daemon.sh) > /dev/null 2>&1

	# then try to safely kill DreamDaemon
	(sudo killall -s SIGTERM DreamDaemon) > /dev/null 2>&1

	# wait for up to 5 seconds before resorting to SIGKILL
	SLEPT=0
	while true; do
		if [ -z "$(pgrep -f "DreamDaemon")" ]; then
			break
		else
			sleep 0.05
			SLEPT=$((SLEPT + 1))
			if [ $SLEPT -ge 100 ]; then
				break
			fi
		fi
	done
	
	# DreamDaemon is still alive, kill it with SIGKILL
	if ! [ -z "$(pgrep -f "DreamDaemon")" ]; then
		(sudo killall -s SIGKILL DreamDaemon) > /dev/null 2>&1
	fi

	# remove any existing cgserver executable
	if [ -f /usr/bin/cgserver ]; then
		sudo rm /usr/bin/cgserver
	fi 

	# clone the executable into the bin
	(sudo wget https://github.com/kachnov/cgserver/blob/master/cgserver) > /dev/null 2>&1
	(sudo cp cgserver /usr/bin && sudo chmod +x /usr/bin/cgserver)
	sudo rm cgserver

	# get some temp files
	(sudo wget https://github.com/kachnov/cgserver/blob/master/start-cron-daemon.sh) > /dev/null 2>&1
	(sudo wget https://github.com/kachnov/cgserver/blob/master/start-git-daemon.sh) > /dev/null 2>&1

	# create /usr/local/cgserver if its not there
	if ! [ -d /usr/local/cgserver ]; then 
		sudo mkdir /usr/local/cgserver
	fi

	# ensure primary files exist (preserve contents)
	sudo touch /usr/local/cgserver/servers
	sudo touch /usr/local/cgserver/sync
	sudo touch /usr/local/cgserver/editor

	# server-states needs to go since we killed all DD instances
	if [ -f /usr/local/cgserver/server-states ]; then
		sudo rm /usr/local/cgserver/server-states
	fi

	# preserve the config dir if it exists, otherwise create it
	if ! [ -d /usr/local/cgserver/config ]; then 
		sudo mkdir /usr/local/cgserver/config
	fi

	# preserve the git dir if it exists, otherwise create it
	if ! [ -d /usr/local/cgserver/git ]; then 
		sudo mkdir /usr/local/cgserver/git
	fi

	# the meta dir has to go since we killed all DD instances 
	if [ -d /usr/local/cgserver/meta ]; then 
		sudo rm -rf /usr/local/cgserver/meta
	fi

	# copy tmp files to /usr/local/cgserver
	sudo cp start-cron-daemon.sh /usr/local/cgserver
	sudo cp start-git-daemon.sh /usr/local/cgserver

	# remove those temp files
	sudo rm start-cron-daemon.sh 
	sudo rm start-git-daemon.sh

	# set some more executable bits
	sudo chmod +x /usr/local/cgserver/start-cron-daemon.sh
	sudo chmod +x /usr/local/cgserver/start-git-daemon.sh

	# append an alias to bashrc
	ALIAS="alias cgs='/usr/bin/cgserver'"
	(sudo sed -i '/'$ALIAS'/d' ~/.bashrc) > /dev/null 2>&1
	(echo "$ALIAS" | sudo tee --append ~/.bashrc) > /dev/null 2>&1

	# success
	echo "Successfully installed cgserver. Run cgserver --help for a list of commands. You can also use the alias 'cgs', after restarting the shell."

	# display the version 
	/usr/bin/cgserver version
fi