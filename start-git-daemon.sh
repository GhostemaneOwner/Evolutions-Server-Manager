#!/bin/bash
GITDIR="/usr/local/cgserver/git/$1"
CPDIR="$2"

cd "$GITDIR"
for subdir in "$GITDIR"/*; do
	if [ -d "${subdir}" ]; then
		cd "$subdir"
	fi
done

while true; do
	# fetch the latest changes from origin/master
	sudo git fetch > /dev/null 2>&1
	# if there's no DMB or no RSC build anyway
	DMBTEST=$(find "$PWD" -maxdepth 1 -name '*.dmb')
	RSCTEST=$(find "$PWD" -maxdepth 1 -name '*.rsc' ! -name "*.dyn.rsc" ! -name 'buggy.rsc')
	# something changed remotely
	if [ $(sudo git rev-parse HEAD) != $(sudo git rev-parse @{u}) ] || [ -z $DMBTEST ] || [ -z $RSCTEST ]; then
		# pull the latest changes
		sudo git pull
		# rebase to them
		sudo git reset --hard
		# remove old binaries
		if [ -f "$DMBTEST" ]; then 
			sudo rm "$DMBTEST"
		fi
		if [ -f "$RSCTEST" ]; then
			sudo rm "$RSCTEST"
		fi
		# find any .dme file here and build the dmb
		DME=$(find "$PWD" -maxdepth 1 -name '*.dme')
		# sudo build because we're still in /usr/local
		sudo /usr/local/bin/DreamMaker "$DME"
		# find the new binaries which hopefully exist now
		DMB=$(find "$PWD" -maxdepth 1 -name '*.dmb')
		RSC=$(find "$PWD" -maxdepth 1 -name '*.rsc' ! -name '*.dyn.rsc' ! -name 'buggy.rsc')
		# build was sucessful, copy the new binares to $CPDIR
		if [ -f "$DMB" ] && [ -f "$RSC" ]; then
			cp --no-preserve=mode,ownership "$DMB" "$CPDIR"
			cp --no-preserve=mode,ownership "$RSC" "$CPDIR"
		# someone fucked up and pushed broken code good job
		# wait a minute before we try again and hope someone fixed it
		else
			echo "Git Daemon: Compilation failed! Sleeping for a minute to prevent spam."
			sleep 60
		fi
	fi
	# sleep for just half a second before we try again
	sleep 0.5
done