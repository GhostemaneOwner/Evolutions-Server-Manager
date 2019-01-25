# cgserver
A BYOND server manager for Linux
<br>
run cgs(erver) --help for a list of commands

## Installation
```
wget https://raw.githubusercontent.com/kachnov/cgserver/master/getcgs.sh
chmod +x getcgs.sh
./getcgs.sh
```

## Removal
```
chmod +x uninstall.sh
./uninstall.sh
```

## Usage

### Setting up a server with automatic git updates and automatic restarting on crashes
```
cgs add main # add a new DreamDaemon instance, "main"
cgs cfg-add main 5000 # set its port to 5000
cgs sync main /directory/with/byond/binaries # set its directory
cgs git main https://github.com/example/example # sync it with git
cgs start main # start the server
```

## Discord
Major updates will be announced in the support discord
<br>
https://discord.gg/REpeuWE
