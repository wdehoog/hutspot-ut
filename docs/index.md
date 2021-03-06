---
title: Introduction
nav_order: 1
layout: default
---
#  Welcome to the Hutspot Documentation
Hutspot is a Spotify controller for Ubuntu Touch. It uses the [Spotify web-api](https://developer.spotify.com/documentation/web-api/). Playing is done on an 'connect' device. It requires a premium Spotify account. 

Main features:

 * Browse Albums/Artists/Playlists
 * Search Albums/Artists/Playlists/Tracks
 * Support for Genres & Moods
 * Follow/Unfollow, Save/Unsave
 * Discover and control Connect Devices
 * Control Play/Pause/Next/Previous/Volume/Shuffle/Replay/Seek
 * Create and Edit Playlists
 * Get Recommendations based on Artists, Tracks, Genres and some attributes
 * Keep track of visited Albums, Artists and Playlists
 * Can be used by media controls from indicator panel
 * Start/Stop Librespot if available (see [play-on-phone](play-on-phone))
 * Supports Suru Dark mode

It does not support saving tracks nor offline playing

Please report any problems or requests in the [Github Issue Tracker](https://github.com/wdehoog/hutspot-ubports/issues)

## Confinement
Hutspot is an 'unconfined' app. This due to:
  * Calling a restricted DBus method on repowerd to keep the phone from suspending while playing. Otherwise audio becomes choppy.
  * All sorts of DBus activity due to acting as a Mpris2 player. Being an Mpris2 compatible player allows the use of the media controls in the indicator panel.

If you want to run it as a confined app you need to add some policy groups to you system and Hutspot's apparmor file. See the `confined` directory of the sources. 


## Install
A package might be available at [Gitlab](https://gitlab.com/wdehoog/hutspot-ut/-/pipelines) where a CI job runs for an ``armhf`` and an ``arm64`` target. Ofcourse you can always build it yourself, see below.


## Developing
You can build it with [clickable](http://clickable.bhdouglass.com/en/latest/).

Hutspot uses some libraries [qtdbusextended](https://github.com/nemomobile/qtdbusextended) and [qtmpris](https://git.merproject.org/mer-core/qtmpris), [qmdnsengine](https://github.com/nitroshare/qmdnsengine) and [nemo-qml-plugin-dbus](https://git.sailfishos.org/mer-core/nemo-qml-plugin-dbus). Their sources are currently included in the git repo. Building these libraries required some modifications in two .pro files from qtmpris.


### Thanks
 * Spotify for the [web api](https://developer.spotify.com/documentation/web-api/)
 * JMPerez for [spotify-web-api-js](https://github.com/JMPerez/spotify-web-api-js)
 * pipacs for [O2](https://github.com/pipacs/o2)
 * librespot-org for [Librespot](https://github.com/librespot-org/librespot)
 * Maciej Janiszewski: co-author of Hutspot for SailfishOS
 * Whoever made: nemo-qml-plugin-dbus, qtmpris and qtdbusextended
 * nitroshare: qmdnsengine

### License
O2 and spotify-web-api-js have their own license. For Hutspot it is MIT. Some parts are LGPL and/or BSD.

Due to the issues with detecting Spotify capable players this app is not 'plug and play'. Don't use it unless you are willing to mess around.

### Donations
Sorry but I do not accept any donations. I do appreciate the gesture but it is a hobby that I am able to do because others are investing their time as well.

If someone wants to show appreciation for my  work by a donation then I suggest to support [UBports](https://ubports.com/donate).

