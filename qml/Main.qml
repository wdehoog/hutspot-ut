import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Themes 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtWebEngine 1.7

import "Spotify.js" as Spotify
import "Util.js" as Util

import "components"
import "pages"

MainView {
    id: app
    
    property alias settings: settings

    property alias deviceId: settings.deviceId
    property alias deviceName: settings.deviceName

    //
    // UI stuff
    //
    property double paddingSmall: units.gu(0.5)
    property double paddingMedium: units.gu(1)
    property double paddingLarge: units.gu(2)

    property double iconSizeSmall: units.gu(2)
    property double iconSizeMedium: units.gu(4)

    property double itemSizeMedium: units.gu(4)
    property double itemSizeLarge: units.gu(10)

    property color normalBackgroundColor: "white" // theme.palette.normal.base
    property color highlightBackgroundColor: "#CDCDCD" // theme.palette.highlited.base
    //

    objectName: 'mainView'
    applicationName: 'hutspot.wdehoog'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)
    
    PageStack {
        id: pageStack
        //anchors.fill: parent
        anchors {
            fill: undefined
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: playerArea.top
        }
        clip: true
    }


    PlayerArea {
        id: playerArea
        visible: pageStack.currentPage.objectName !== "PlayingPage"
        height: visible ? itemSizeLarge : 0
        anchors {
            bottom: parent.bottom
            bottomMargin: paddingSmall
        }
        width: parent.width - 2*paddingSmall
        x: paddingSmall
    }

    function loadFirstPage() {
        var pageUrl = undefined
        /*switch(firstPage.value) {
        default:
        case "PlayingPage":
            // when not having the Playing page as attached page
            if(!playing_as_attached_page.value)
                pageUrl = Qt.resolvedUrl("pages/Playing.qml")
            else
                pageUrl = Qt.resolvedUrl("pages/MyStuff.qml")
            break;
        case "NewReleasePage":
            pageUrl = Qt.resolvedUrl("pages/NewAndFeatured.qml")
            break;
        case "MyStuffPage":
            pageUrl = Qt.resolvedUrl("pages/MyStuff.qml")
            break;
        case "TopStuffPage":
            pageUrl = Qt.resolvedUrl("pages/TopStuff.qml")
            break;
        case "SearchPage":
            pageUrl = Qt.resolvedUrl("pages/Search.qml")
            break;
        case 'GenreMoodPage':
            pageUrl = Qt.resolvedUrl("pages/GenreMood.qml")
            break;
        case 'HistoryPage':
            pageUrl = Qt.resolvedUrl("pages/History.qml")
            break;
        case 'RecommendedPage':
            pageUrl = Qt.resolvedUrl("pages/Recommended.qml")
            break;
        }*/
        pageUrl = Qt.resolvedUrl("pages/Menu.qml")
        if(pageUrl !== undefined ) {
            pageStack.clear()
            pageStack.push(Qt.resolvedUrl(pageUrl))
        }
    }

    // when using menu dialog
    function doSelectedMenuItem(selectedIndex) {
        switch(selectedIndex) {
        case Util.HutspotMenuItem.ShowPlayingPage:
            app.showPage('PlayingPage')
            break
        case Util.HutspotMenuItem.ShowNewReleasePage:
            app.showPage('NewReleasePage')
            break
        case Util.HutspotMenuItem.ShowMyStuffPage:
            app.showPage('MyStuffPage')
            break
        case Util.HutspotMenuItem.ShowTopStuffPage:
            app.showPage('TopStuffPage')
            break
        case Util.HutspotMenuItem.ShowGenreMoodPage:
            app.showPage('GenreMoodPage')
            break
        case Util.HutspotMenuItem.ShowHistoryPage:
            app.showPage('HistoryPage')
            break
        case Util.HutspotMenuItem.ShowRecommendedPage:
            app.showPage('RecommendedPage')
            break
        case Util.HutspotMenuItem.ShowSearchPage:
            app.showPage('SearchPage')
            break
        case Util.HutspotMenuItem.ShowDevicesPage:
            pageStack.push(Qt.resolvedUrl("pages/Devices.qml"))
            break
        case Util.HutspotMenuItem.ShowSettingsPage:
            pageStack.push(Qt.resolvedUrl("pages/Settings.qml"))
            break
        case Util.HutspotMenuItem.ShowAboutPage:
            pageStack.push(Qt.resolvedUrl("pages/About.qml"))
            break;
        case Util.HutspotMenuItem.ShowHelp:
            Qt.openUrlExternally("http://sailfish-spotify.github.io/hutspot/")
            break;
        }
    }

    function showPage(pageName) {
        var page
        switch(pageName) {
        case 'PlayingPage':
            // when not having the Playing page as attached page
            // pop all pages above playing page or add it
            var pPage = pageStack.find(function(page) {
                return page.objectName === "PlayingPage"
            })
            if(pPage !== null)
                pageStack.pop(pPage)
            else
                pageStack.push(playingPage)
            break;
        case 'NewReleasePage':
            //pageStack.clear()
            page = pageStack.push(Qt.resolvedUrl("pages/NewAndFeatured.qml"))
            break;
        case 'MyStuffPage':
            //pageStack.clear()
            page = pageStack.push(Qt.resolvedUrl("pages/MyStuff.qml"))
            break;
        case 'TopStuffPage':
            //pageStack.clear()
            page = pageStack.push(Qt.resolvedUrl("pages/TopStuff.qml"))
            break;
        case 'SearchPage':
            //pageStack.clear()
            page = pageStack.push(Qt.resolvedUrl("pages/Search.qml"))
            break;
        case 'GenreMoodPage':
            //pageStack.clear()
            page = pageStack.push(Qt.resolvedUrl("pages/GenreMood.qml"))
            break;
        case 'HistoryPage':
            //pageStack.clear()
            page = pageStack.push(Qt.resolvedUrl("pages/History.qml"))
            break;
        case 'RecommendedPage':
            //pageStack.clear()
            page = pageStack.push(Qt.resolvedUrl("pages/Recommended.qml"))
            break;
        default:
            return
        }
        //if(playing_as_attached_page.value)
        //    pageStack.pushAttached(playingPage)
        //firstPage.value = pageName
    }

    //
    // 0: Album, 1: Artist, 2: Playlist
    function pushPage(type, options, fromPlaying) {
        var pageUrl = undefined
        switch(type) {
        case Util.HutspotPage.Album:
            pageUrl = "pages/Album.qml"
            break
        case Util.HutspotPage.Artist:
            pageUrl = "pages/Artist.qml"
            break
        case Util.HutspotPage.Playlist:
            pageUrl = "pages/Playlist.qml"
            break
        case Util.HutspotPage.GenreMoodPlaylist:
            pageUrl = "pages/GenreMoodPlaylist.qml"
            break
        }

        // if the pushPage is called from the Playing page and the Playing page
        // is an attached page we need to go to the parent first
        //if(fromPlaying) {
        //    if(playing_as_attached_page.value)
        //        pageStack.navigateBack(PageStackAction.Immediate)
        //}

        if(pageUrl !== undefined ) {
            pageStack.push(Qt.resolvedUrl(pageUrl), options)
            //if(playing_as_attached_page.value)
            //    pageStack.pushAttached(playingPage)
        }
    }

    Component.onCompleted: {
        startSpotify()
    }

    function startSpotify() {
        if (!spotify.isLinked()) {
            spotify.doO2Auth(Spotify._scope, false /*auth_using_browser.value*/)
        } else {
            var now = new Date ()
            console.log("Currently it is " + now.toDateString() + " " + now.toTimeString())
            var tokenExpireTime = spotify.getExpires()
            var tokenExpireDate = new Date(tokenExpireTime*1000)
            console.log("Current token expires on: " + tokenExpireDate.toDateString() + " " + tokenExpireDate.toTimeString())
            // do not set the 'global' hasValidToken since we will refresh anyway
            // and that will interfere
            var hasValidToken = tokenExpireDate > now
            console.log("Token is " + hasValidToken ? "still valid" : "expired")

            // with Spotify's stupid short living tokens, we can totally assume
            // it's already expired
            spotify.refreshToken();
        }
    }

    property int tokenExpireTime: 0 // seconds from epoch
    property bool hasValidToken: false

    function updateValidToken(expireTime) {
        tokenExpireTime = expireTime
        var expDate = new Date(tokenExpireTime*1000)
        console.log("expires on: " + expDate.toDateString() + " " + expDate.toTimeString())
        var now = new Date()
        hasValidToken = expDate > now
    }

    Connections {
        target: spotify

        onExtraTokensReady: { // (const QVariantMap &extraTokens);
            // extraTokens
            //   scope: ""
            //   token_type: "Bearer"
        }

        onLinkingFailed: {
            console.log("Connections.onLinkingFailed")
            //app.connectionText = qsTr("Disconnected")
        }

        onLinkingSucceeded: {
            console.log("Connections.onLinkingSucceeded")
            //console.log("username: " + spotify.getUserName())
            //console.log("token   : " + spotify.getToken())
            Spotify._accessToken = spotify.getToken()
            Spotify._username = spotify.getUserName()
            updateValidToken(spotify.getExpires())
            //app.connectionText = qsTr("Connected")
            //loadUser()
            loadFirstPage()
            // ToDo: maybe call spotify.refreshToken() so after 1st login pages show data
        }

        onLinkedChanged: {
            console.log("Connections.onLinkingChanged")
        }

        onRefreshFinished: {
            console.log("Connections.onRefreshFinished error code: " + errorCode +", msg: " + errorString)
            if(errorCode !== 0) {
                showErrorMessage(errorString, qsTr("Failed to Refresh Authorization Token"))
            } else {
                updateValidToken(spotify.getExpires())
            }
        }

        onOpenBrowser: {
           console.log("onOpenBrowser: " + url)
           // Morph.Web crashes but Morph the browser works
           //if(settings.authUsingBrowser) { 
               Qt.openUrlExternally(url)
           //} else {
           //    pageStack.push(Qt.resolvedUrl("pages/Menu.qml"))
           //    pageStack.push(Qt.resolvedUrl("pages/WebAuth.qml"), {authURL: url })
           //}
        }

        onCloseBrowser: {
            //loadFirstPage()
        }
    }

    property string id: "" // spotify user id
    property string uri: ""
    property string display_name: ""
    property string product: ""
    property string followers: ""

    function loadUser() {
        Spotify.getMe({}, function(error, data) {
            if(data) {
                try {
                    id = data.id
                    uri = data.uri
                    display_name = data.display_name
                    product = data.product
                    followers = data.followers.total
                } catch (err) {
                    console.log(err)
                }
            } else {
                console.log("No Data for getMe")
            }
        })
        controller.refreshPlaybackState();
    }

    function getPlaylist(playlistId, callback) {
        Spotify.getPlaylist(playlistId, {}, function(error, data) {
            if(callback)
                callback(error, data)
        })
    }

    signal playlistEvent(var event)

    function editPlaylistDetails(playlist, callback) {
        var ms = pageStack.push(Qt.resolvedUrl("components/CreatePlaylist.qml"),
                                {titleText: qsTr("Edit Playlist Details"),
                                 name: playlist.name, description: playlist.description,
                                 publicPL: playlist['public'], collaborative: playlist.collaborative} );
        ms.accepted.connect(function() {
            if(ms.name && ms.name.length > 0) {
                var options = {name: ms.name,
                               'public': ms.publicPL,
                               collaborative: ms.collaborativePL}
                if(ms.description && ms.description.length > 0)
                    options.description = ms.description
                Spotify.changePlaylistDetails(playlist.id, options, function(error, data) {
                    if(callback)
                        callback(error, data)
                    if(!error) {
                        var ev = new Util.PlayListEvent(Util.PlaylistEventType.ChangedDetails,
                                                        playlist.id, playlist.snapshot_id)
                        ev.newDetails = options
                        playlistEvent(ev)
                    }
                })
            }
        })
    }

    function addToPlaylist(track) {

        var ms = pageStack.push(Qt.resolvedUrl("components/PlaylistPicker.qml"),
                                { label: qsTr("Select a Playlist") } );
        ms.accepted.connect(function() {
            if(ms.selectedItem && ms.selectedItem.item) {
                Spotify.addTracksToPlaylist(ms.selectedItem.item.id,
                                            [track.uri], {}, function(error, data) {
                    if(data) {
                        var ev = new Util.PlayListEvent(Util.PlaylistEventType.AddedTrack,
                                                        ms.selectedItem.item.id, data.snapshot_id)
                        ev.trackId = track.id
                        ev.trackUri = track.uri
                        playlistEvent(ev)
                        console.log("addToPlaylist: added \"")
                    } else
                        console.log("addToPlaylist: failed to add \"")
                    console.log(track.name + "\" to \"" + ms.selectedItem.item.name + "\"")
                })
            }
        })
    }

    function removeFromPlaylist(playlist, track, position, callback) {
        app.showConfirmDialog(qsTr("Please confirm to remove:<br><br><b>" + track.name + "</b>"),
                              function() {
            // does not work due to Qt. cannot have DELETE request with a body
            /*Spotify.removeTracksFromPlaylist(playlist.id, [track.uri], function(error, data) {
                callback(error, data)
                var ev = new Util.PlayListEvent(Util.PlaylistEventType.RemovedTrack,
                                                playlist.id, data.snapshot_id)
                ev.trackId = track.id
                playlistEvent(ev)
            })*/

            // if the track is 'linked' we must remove the linked_from one
            var uri = track.uri
            if(track.hasOwnProperty('linked_from'))
                uri = track.linked_from.uri
            removeTracksFromPlaylistUsingCurl(playlist.id, playlist.snapshot_id, [uri], [position], function(error, data) {
                if(callback)
                    callback(error, data)
                var ev = new Util.PlayListEvent(Util.PlaylistEventType.RemovedTrack,
                                                playlist.id, data.snapshot_id)
                ev.trackId = track.id
                playlistEvent(ev)
            })
        })
    }

    function createPlaylist(callback) {
        var ms = pageStack.push(Qt.resolvedUrl("components/CreatePlaylist.qml"),
                                {} );
        ms.accepted.connect(function() {
            if(ms.name && ms.name.length > 0) {
                var options = {name: ms.name,
                               'public': ms.publicPL,
                               collaborative: ms.collaborativePL}
                if(ms.description && ms.description.length > 0)
                    options.description = ms.description
                Spotify.createPlaylist(id, options, function(error, data) {
                    callback(error, data)
                    if(data) {
                        var ev = new Util.PlayListEvent(Util.PlaylistEventType.CreatedPlaylist,
                                                        data.id, data.snapshot_id)
                        ev.playlist = data
                        playlistEvent(ev)
                    }
                })
            }
        })
    }

    function getPlaylistTracks(playlistId, options, callback) {
        if(settings.queryForMarket) {
            if(!options)
                options = {}
            options.market = "from_token"
        }
        Spotify.getPlaylistTracks(playlistId, options, callback)
    }

    function replaceTracksInPlaylist(playlistId, tracks, callback) {
        Spotify.replaceTracksInPlaylist(playlistId, tracks, function(error, data) {
            if(callback)
                callback(error, data)
            if(data && data.snapshot_id) {
                var ev = new Util.PlayListEvent(Util.PlaylistEventType.ReplacedAllTracks,
                                                playlistId, data.snapshot_id)
                playlistEvent(ev)
                console.log("replaceTracksInPlaylist: snapshot: " + data.snapshot_id)
            } else
                console.log("No Data while replacing tracks in Playlist " + playlistId)
        })
    }

    function loadTracksInModel(data, count, model, getTrack, getExtraProperties) {
        var trackIds = []
        for(var i=0;i<count;i++) {
            var track = getTrack(data, i)
            //console.log(track.id)
            var item = {type: Spotify.ItemType.Track,
                          name: track.name,
                          item: track,
                          following: false,
                          saved: false}
            if(getExtraProperties) {
                var extra = getExtraProperties(data, i)
                for(var attrname in extra)
                    item[attrname] = extra[attrname]
            }
            model.append(item)
            trackIds.push(track.id)
        }
        Spotify.containsMySavedTracks(trackIds, function(error, data) {
            if(data) {
                Util.setSavedInfo(Spotify.ItemType.Track, trackIds, data, model)
            }
        })
    }

    signal favoriteEvent(var event)

    function isFollowingPlaylist(pid, callback) {
        Spotify.areFollowingPlaylist(pid, [id], function(error, data) {
            callback(error, data)
        })
    }

    function followPlaylist(playlist, callback) {
        Spotify.followPlaylist(playlist.id, function(error, data) {
            callback(error, data)
            var event = new Util.FavoriteEvent(Util.SpotifyItemType.Playlist, playlist.id, playlist.uri, true)
            favoriteEvent(event)
        })
    }

    function _unfollowPlaylist(playlist, callback) {
        Spotify.unfollowPlaylist(playlist.id, function(error, data) {
            callback(error, data)
            var event = new Util.FavoriteEvent(Util.SpotifyItemType.Playlist, playlist.id, playlist.uri, false)
            favoriteEvent(event)
        })
    }

    function unfollowPlaylist(playlist, callback) {
        if(confirm_un_follow_save.value)
            app.showConfirmDialog(qsTr("Please confirm to unfollow playlist:<br><br><b>" + playlist.name + "</b>"),
                                  function() {
                _unfollowPlaylist(playlist, callback)
            })
        else
            _unfollowPlaylist(playlist, callback)
    }

    function followArtist(artist, callback) {
        Spotify.followArtists([artist.id], function(error, data) {
            callback(error, data)
            var event = new Util.FavoriteEvent(Util.SpotifyItemType.Artist, artist.id, artist.uri, true)
            favoriteEvent(event)
        })
    }

    function _unfollowArtist(artist, callback) {
        Spotify.unfollowArtists([artist.id], function(error, data) {
            callback(error, data)
            var event = new Util.FavoriteEvent(Util.SpotifyItemType.Artist, artist.id, artist.uri, false)
            favoriteEvent(event)
        })
    }

    function unfollowArtist(artist, callback) {
        if(confirm_un_follow_save.value)
            app.showConfirmDialog(qsTr("Please confirm to unfollow artist:<br><br><b>" + artist.name + "</b>"),
                                  function() {
                _unfollowArtist(artist, callback)
            })
        else
            _unfollowArtist(artist, callback)
    }

    function saveAlbum(album, callback) {
        var id
        if(album.hasOwnProperty("id"))
            id = album.id
        else
            id = Util.parseSpotifyUri(album.uri).id
        Spotify.addToMySavedAlbums([id], function(error, data) {
            callback(error, data)
            var event = new Util.FavoriteEvent(Util.SpotifyItemType.Album, album.id, album.uri, true)
            favoriteEvent(event)
        })
    }

    function _unSaveAlbum(album, callback) {
        Spotify.removeFromMySavedAlbums([album.id], function(error, data) {
            callback(error, data)
            var event = new Util.FavoriteEvent(Util.SpotifyItemType.Album, album.id, album.uri, false)
            favoriteEvent(event)
        })
    }

    function unSaveAlbum(album, callback) {
        if(confirm_un_follow_save.value)
            app.showConfirmDialog(qsTr("Please confirm to un-save album:<br><br><b>" + album.name + "</b>"),
                                  function() {
                _unSaveAlbum(album, callback)
            })
        else
            _unSaveAlbum(album, callback)
    }

    function saveTrack(track, callback) {
        Spotify.addToMySavedTracks([track.id], function(error, data) {
            callback(error, data)
            var event = new Util.FavoriteEvent(Util.SpotifyItemType.Track, track.id, track.uri, true)
            favoriteEvent(event)
        })
    }

    function _unSaveTrack(track, callback) {
        Spotify.removeFromMySavedTracks([track.id], function(error, data) {
            callback(error, data)
            var event = new Util.FavoriteEvent(Util.SpotifyItemType.Track, track.id, track.uri, false)
            favoriteEvent(event)
        })
    }

    function unSaveTrack(track, callback) {
        if(confirm_un_follow_save.value)
            app.showConfirmDialog(qsTr("Please confirm to un-save track:<br><br><b>" + track.name + "</b>"),
                                  function() {
                _unSaveTrack(track, callback)
            })
        else
            _unSaveTrack(track, callback)
    }

    function toggleSavedTrack(model) {
        if(model.saved)
            unSaveTrack(model.item, function(error,data) {
                if(!error)
                    model.saved = false
            })
        else
            saveTrack(model.item, function(error,data) {
                if(!error)
                    model.saved = true
            })
    }

    function toggleSavedAlbum(album, isAlbumSaved, callback) {
        if(isAlbumSaved)
            unSaveAlbum(album, function(error,data) {
                if(!error)
                    callback(false)
            })
        else
            saveAlbum(album, function(error,data) {
                if(!error)
                    callback(true)
            })
    }

    function toggleFollowArtist(artist, isFollowed, callback) {
        if(isFollowed)
            unfollowArtist(artist, function(error,data) {
                if(!error)
                    callback(false)
            })
        else
            followArtist(artist, function(error,data) {
                if(!error)
                    callback(true)
            })
    }

    function toggleFollowPlaylist(playlist, isFollowed, callback) {
        if(isFollowed)
             unfollowPlaylist(playlist, function(error, data) {
                 if(!error)
                     callback(false)
             })
         else
             followPlaylist(playlist, function(error, data) {
                 if(!error)
                     callback(true)
             })
    }

    function loadArtist(artists, fromPlaying) {
        if(artists.length > 1) {
            // choose
            var ms = pageStack.push(Qt.resolvedUrl("components/ArtistPicker.qml"),
                                    { label: qsTr("View an Artist"), artists: artists } );
            ms.done.connect(function() {
                if(ms.selectedItem) {
                    app.pushPage(Util.HutspotPage.Artist, {currentArtist: ms.selectedItem.item}, fromPlaying)
                }
            })
        } else if(artists.length === 1) {
            app.pushPage(Util.HutspotPage.Artist, {currentArtist:artists[0]}, fromPlaying)
        }
    }

    //
    // Dialogs
    //
    property string _dialogTitle
    property string _dialogText
    Component {
        id: dialog
        Dialog {
            id: dialogue
            title: _dialogTitle
            text: _dialogText
            Button { 
                text: i18n.tr("Ok")
                onClicked: PopupUtils.close(dialogue) 
            }
        }
    }

    function showErrorMessage(error, text) {
        var msg
        if(error) {
            if(error.hasOwnProperty('status') && error.hasOwnProperty('message'))
                msg = text + ":" + error.status + ":" + error.message
            else
                msg = text + ": " + error
        } else
            msg = text
        _dialogTitle = i18n.tr("Error")      
        _dialogText = msg      
        PopupUtils.open(dialog)
    }

    function setDevice(id, name, callback) {
        var newId = id
        var newName = name
        Spotify.transferMyPlayback([id],{}, function(error, data) {
            if(!error) {
                controller.refreshPlaybackState()
                deviceId.value = newId
                deviceName.value = newName
                callback(null, data)
            } else
                showErrorMessage(error, qsTr("Failed to transfer to") + " " + deviceName.value)
        })
    }

    /**
     * List of last visited albums/artists/playlists
     */
    readonly property int historySize: 50
    property var history: []
    signal historyModified(int added, int removed)
    function notifyHistoryUri(uri) {
        var removedIndex = -1
        if(history.length === 0) {
            history.unshift(uri)
        } else if(history[0] === uri) {
            // already at the top
            return
        } else {
            // add to the top
            history.unshift(uri)
            // remove if already present
            for(var i=1;i<history.length;i++)
                if(history[i] === uri) {
                    history.splice(i, 1)
                    removedIndex = i - 1 // -1 since the model does not have the new one yet
                    break
                }
        }
        historyModified(0, removedIndex)
        if(history.length > historySize) { // make configurable
            history.pop()
            historyModified(-1, historySize-1)
        }
        settings.history = history
    }

    function clearHistory() {
        history = []
        settings.history = history
        historyModified(-1, -1)
    }

    property alias controller: spotifyController
    SpotifyController {
        id: spotifyController
    }

    property alias spotifyDataCache: spotifyDataCache
    SpotifyDataCache {
        id: spotifyDataCache
    }

    property var foundDevices: []     // the device info queried by getInfo
    property var connectDevices: ({}) // the device info discovered by mdns

    signal devicesChanged()

    onDevicesChanged: {        
        // for logging Librespot discovery
        var ls = isLibrespotInDiscoveredList()
        if(ls !== null) {
            if(logging_flags.discovery)console.log("onDevicesChanged: " + (ls!==null)?"Librespot is discovered":"not yet")
            if(!isLibrespotInDevicesList()) {
                if(logging_flags.discovery)console.log("Librespot is not in the devices list")
                // maybe the list needs to be updated
                if(hasValidToken)
                    spotifyController.checkForNewDevices()
            } else {
                if(logging_flags.discovery)console.log("Librespot is already in the devices list")
            }
        }
        //handleCurrentDevice()
    }

    Settings {
        id: settings

        property int searchLimit: 50
        property int sorted_list_limit: 1000

        property int currentItemClassMyStuff: 0
        property int currentItemClassArtist: 0
        property int currentItemClassSearch: 0

        property bool authUsingBrowser: false
        property bool queryForMarket: true

        property var history

        property string deviceId: ""
        property string deviceName: ""

    }
}
