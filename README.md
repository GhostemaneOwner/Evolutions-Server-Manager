# cgserver
A BYOND server manager for Linux
<br>
run cgs(erver) --help for a list of commands

## Installation
```bash
wget https://raw.githubusercontent.com/kachnov/cgserver/master/getcgs.sh
chmod +x getcgs.sh
./getcgs.sh
```

## Updating
Updating to the latest git build simply requires you to run getcgs.sh again.
<br>
getcgs.sh will rarely be updated itself, so you can almost always use the same script you used to  install cgserver.
```bash
./getcgs.sh
```

## Removal
```bash
chmod +x uninstall.sh
./uninstall.sh
```

## Usage

### Setting up a server with automatic git updates and automatic restarting on crashes
```bash
cgs add main # add a new DreamDaemon instance, "main"
cgs cfg-add main 5000 # set its port to 5000
cgs sync main /directory/with/byond/binaries # set its directory
cgs git main https://github.com/example/example # sync it with git
cgs start main # start the server
```

## DM hooks
```DM
// implement special behavior on /world/Reboot()
/world/Reboot()
  ..()
  // we were sent the reboot signal by cgserver
  if (reason == 3)
    return world.custom_behavior()
  // normal reboot
  return ..(reason)
```

## Discord
Major updates will be announced in the support discord
<br>
[![discord](https://discordapp.com/api/guilds/536989523666665474/widget.png)](https://discord.gg/REpeuWE)

