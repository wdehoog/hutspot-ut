/**
 * Copyright (C) 2018 Willem-Jan de Hoog
 * Copyright (C) 2018 Maciej Janiszewski
 *
 * License: MIT
 */


import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../components"
import "../Spotify.js" as Spotify
import "../Util.js" as Util

Page {
    id: artistPage
    objectName: "ArtistPage"

    property string defaultImageSource : "image://theme/stock_music"
    property bool showBusy: false

    property var currentArtist
    property var _fullArtist
    property bool isFollowed: false

    property int currentIndex: -1


    ListModel {
        id: searchModel
    }

    header: PageHeader {
        id: pHeader
        width: parent.width
        title: {
            return i18n.tr("Artist")
        }
        leadingActionBar.actions: [
            Action {
                iconName: "back"
                text: "Back"
                onTriggered: pageStack.pop()
            }
        ]
        trailingActionBar.actions: [
            Action {
                text: i18n.tr("Home")
                iconName: "home"
                onTriggered: app.goHome()
            },
            Action {
                iconName: "external-link"
                text: qsTr("Load Artist About Page in Browser")
                visible: currentArtist && currentArtist.external_urls["spotify"]
                onTriggered: Qt.openUrlExternally(currentArtist.external_urls["spotify"] + "/about")
            }
        ]
        flickable: listView
        extension: Sections {
            id: sections
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }    
            onSelectedIndexChanged: setItemClass(selectedIndex)
            model: [
                i18n.tr("Albums"),
                i18n.tr("Related Artists")
            ]
        }
        Binding {
            target: pHeader.extension
            property: "selectedIndex"
            value: _itemClass
        }
    }

    SearchResultContextMenu {
        id: contextMenu
    }

    ListView {
        id: listView
        model: searchModel

        width: parent.width
        anchors.top: parent.top
        height: parent.height // - app.dockedPanel.visibleSize
        //clip: app.dockedPanel.expanded

        header: Component { Column {
            id: lvColumn

            width: parent.width - 2*app.paddingMedium
            x: app.paddingMedium
            anchors.bottomMargin: app.paddingLarge
            spacing: app.paddingMedium


            Image {
                id: imageItem
                source: (_fullArtist && _fullArtist.images)
                        ? _fullArtist.images[0].url : defaultImageSource
                width: parent.width * 0.75
                height: width
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                onPaintedHeightChanged: height = Math.min(parent.width, paintedHeight)
                MouseArea {
                       anchors.fill: parent
                       onClicked: app.controller.playContext(currentArtist)
                }
            }

            MetaInfoPanel {
                firstLabelText: currentArtist ? currentArtist.name : qsTr("No Name")
                secondLabelText: {
                    if(!_fullArtist)
                        return ""
                    var s = ""
                    if(_fullArtist && _fullArtist.genres && _fullArtist.genres.length > 0)
                        s += Util.createItemsString(_fullArtist.genres, "")
                    return s
                }
                thirdLabelText: {
                    if(!_fullArtist)
                        return ""
                    return _fullArtist.followers && _fullArtist.followers.total > 0
                                ? Util.abbreviateNumber(_fullArtist.followers.total) + " " + qsTr("followers")
                                : ""
                }

                isFavorite: isFollowed
                onToggleFavorite: app.toggleFollowArtist(currentArtist, isFollowed, function(followed) {
                    isFollowed = followed
                })
            }

            /*Rectangle {
                width: parent.width
                height:Theme.paddingLarge
                opacity: 0
            }*/
        }}

        delegate: ListItem {
            id: listItem
            width: parent.width - 2*app.paddingMedium
            x: app.paddingMedium
            //contentHeight: Theme.itemSizeLarge

            SearchResultListItem {
                id: searchResultListItem
                dataModel: model
            }

            onPressAndHold: {
                contextMenu.open(model, listItem)
            }

            onClicked: {
                switch(type) {
                case 0:
                    app.pushPage(Util.HutspotPage.Album, {album: item})
                    break;
                case 1:
                    app.pushPage(Util.HutspotPage.Artist, {currentArtist: item})
                    break;
                }
            }
        }

        onAtYEndChanged: {
            if(listView.atYEnd && searchModel.count > 0)
                append()
        }

    }

    Scrollbar {
        id: scrollBar
        flickableItem: listView
        anchors.right: parent.right
    }

    onCurrentArtistChanged: {
        if(currentArtist && !currentArtist.hasOwnProperty("genres")) {
            _fullArtist = null
            Spotify.getArtist(currentArtist.id, {}, function(error, data) {
                if(data)
                    _fullArtist = data
                else
                    console.log("Failed to load full Artist: " + currentArtist.id)
            })
        }
        _fullArtist = currentArtist
        refresh()
    }

    property var artistAlbums
    property var relatedArtists
    property int _itemClass: app.settings.currentItemClassArtist

    function setItemClass(ic) {
        _itemClass = ic
        app.settings.currentItemClassArtist = ic
        refresh()
    }

    function loadData() {
        var i;

        isFollowed = app.spotifyDataCache.isArtistFollowed(currentArtist.id)

        if(artistAlbums) {
            for(i=0;i<artistAlbums.items.length;i++) {
                searchModel.append({type: 0,
                                    name: artistAlbums.items[i].name,
                                    item: artistAlbums.items[i],
                                    following: app.spotifyDataCache.isArtistFollowed(artistAlbums.items[i].id)})
            }
        }

        if(relatedArtists) {
            for(i=0;i<relatedArtists.artists.length;i++) {
                searchModel.append({type: 1,
                                    name: relatedArtists.artists[i].name,
                                    item: relatedArtists.artists[i],
                                    following: app.spotifyDataCache.isArtistFollowed(relatedArtists.artists[i].id)})
            }
        }

    }

    property alias cursorHelper: cursorHelper

    CursorHelper {
        id: cursorHelper
    }

    function refresh() {
        //showBusy = true
        searchModel.clear()        
        artistAlbums = undefined
        relatedArtists = undefined
        append()
        app.notifyHistoryUri(currentArtist.uri)
        //loadAllAlbumsInfo()
    }

    property bool _loading: false

    function append() {
        // if already at the end -> bail out
        if(searchModel.count > 0 && searchModel.count >= cursorHelper.total)
            return

        // guard
        if(_loading)
            return
        _loading = true

        var i;
        switch(_itemClass) {
        case 0:
            Spotify.getArtistAlbums(currentArtist.id,
                                    {offset: searchModel.count, limit: cursorHelper.limit},
                                    function(error, data) {
                if(data) {
                    //console.log("number of ArtistAlbums: " + data.items.length)
                    //console.log(JSON.stringify(data))
                    artistAlbums = data
                    cursorHelper.offset = data.offset
                    cursorHelper.total = data.total
                } else {
                    console.log("No Data for getArtistAlbums")
                }
                loadData()
                _loading = false
            })
            break
        case 1:
            Spotify.getArtistRelatedArtists(currentArtist.id,
                                            {offset: searchModel.count, limit: cursorHelper.limit},
                                            function(error, data) {
                if(data) {
                    //console.log("number of ArtistRelatedArtists: " + data.artists.length)
                    relatedArtists = data
                    cursorHelper.offset = 0 // no cursor, always 20
                    cursorHelper.total = data.artists.length
                } else {
                    console.log("No Data for getArtistRelatedArtists")
                }
                loadData()
                _loading = false
            })
            break
        }
    }

    property var albumsInfo: []
    function loadAllAlbumsInfo() {
        if(albumsInfo.length > 0)
            albumsInfo = []
        _loadAlbumsInfo(0)
    }

    function _loadAlbumsInfo(offset) {
        var options = {}
        if(app.settings.queryForMarket)
            options.market = "from_token"
        options.offset = offset
        options.limit = 50
        Spotify.getArtistAlbums(currentArtist.id, options, function(error, data) {
            if(data) {
                //console.log(JSON.stringify(data))
                for(var i=0;i<data.items.length;i++)
                    albumsInfo[i+offset] =
                        {id: data.items[i].id,
                         name: data.items[i].name,
                         release_data: data.items[i].release_date ? data.items[i].release_date : "",
                         uri: data.items[i].uri}
                var nextOffset = data.offset+data.items.length
                if(nextOffset < data.total)
                    _loadAlbumsInfo(nextOffset)
                else
                   console.log(JSON.stringify(albumsInfo))
            } else {
                console.log("No Data for getArtistAlbums")
            }
        })
    }
    
    Connections {
        target: app
        onFavoriteEvent: {
            switch(event.type) {
            case Util.SpotifyItemType.Artist:
                if(currentArtist.id === event.id)
                    isFollowed = event.isFavorite
                else
                    Util.setFollowedInfo(event.id, event.isFavorite, searchModel)
                break
            }
        }
    }

}
