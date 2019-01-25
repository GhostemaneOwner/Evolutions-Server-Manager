#!/bin/bash
while true; do
	while read x; do
		if [ ! -z "$x" ] && [ -z "$(pgrep -f "cgserver-$x")" ]; then

			echo "Cron Daemon: DD instance $x unexpectedly went down: if it's still down in 5 seconds, it will be restarted automatically."
			sleep 5

			if [ -z "$(pgrep -f "cgserver-$x")" ]; then
				
				SYNCDIR=""
				while read xx; do
					if [[ $xx =~ .*"$x=".* ]]; then 
						TMP=(${xx//=/ })
						SYNCDIR=${TMP[1]}
						break
					fi
				done < /usr/local/cgserver/sync

				DMBTEST=$(find "$SYNCDIR" -maxdepth 1 -name '*.dmb')
				RSCTEST=$(find "$SYNCDIR" -maxdepth 1 -name '*.rsc' ! -name '*.dyn.rsc')

				if [ ! -f "$DMBTEST" ] || [ ! -f "$RSCTEST" ]; then
					echo "Cron Daemon: No .dmb or no .rsc file was found in $SYNCDIR; shutting down DD instance $2!"
					sudo sed -i '/'$x'/d' /usr/local/cgserver/server-states
				else
					echo "Cron Daemon: Restarting DD instance $x."
					/usr/bin/cgserver start "$x"
				fi
			fi
		fi
	done < /usr/local/cgserver/server-states
	sleep 0.5
done