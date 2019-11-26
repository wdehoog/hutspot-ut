# Hutspot

A simple Spotify Controller for UBports.

One more time: No this is *NOT* a player, it's a controller. It is based on [Hutspot for SailfishOS](https://github.com/sailfish-spotify/hutspot).

It uses Spotify web-api and needs a Premium Account.

Don't expect too much. Currently you can 

  * browse your playlists/tracks/albums/artists
  * search
  * control a player
 

## Spotify on your UBports phone
One option is to copy [spotifyd](https://github.com/Spotifyd/spotifyd/releases) on your phone. For example I use 0.2.19 from  spotifyd-2019-10-06-armv6-slim.zip on by opo. 

This version does not have the pulseaudio backend. It will still work but you will have to take care of setting an environment variable in order for the volume controls to work:

```
#!/bin/sh

export PULSE_PROP='media.role=multimedia'
./spotifyd
```

The easiest way to set it up is creating a config file as described in the [README from spotifyd](https://github.com/Spotifyd/spotifyd).


Another huge problem is the audio getting choppy due to the phone being suspended when the display goes dark. Currently this is solved/hacked using a DBus call to `powerd` (requestSysState) by Hutspot when playing is active. If Hutspot crashes or quits it might not have notified `powerd` and then your battery live might be in danger. 


## Developing
You can build it with [clickable](http://clickable.bhdouglass.com/en/latest/).

I tried to crossbuild spotifyd with the pulseaudio backend but it fails. If you know how to fix that please let me know.

## License

Copyright (C) 2019  Willem-Jan de Hoog

Licensed under the MIT license
