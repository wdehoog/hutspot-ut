/**
 * Copyright (C) 2018 Willem-Jan de Hoog
 *
 * License: MIT
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../Spotify.js" as Spotify
import "../Util.js" as Util

Page {
    id: itemPicker

    signal accepted()

    property string label: i18n.tr("Select Playlist")
    property string defaultName: ""

    property var selectedItem

    property int currentIndex: -1

    header: PageHeader {
        id: header
        contents: Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: label
        }
        leadingActionBar.actions: [
            Action {
                iconName: "cancel"
                text: i18n.tr("Cancel")
                onTriggered: pageStack.pop()
            }
        ]
        trailingActionBar.actions: [
            Action {
                iconName: "ok"
                text: i18n.tr("Select")
                enabled: currentIndex != -1
                onTriggered: {
                    accepted()
                    pageStack.pop()
                }
            },
            Action {
                iconName: "list-add"
                text: qsTr("Create New Playlist")
                onTriggered: app.createPlaylist(defaultName, function(error, data) {
                    if(data) {
                        refresh()
                    }
                })
            }
        ]
        flickable: listView
    }
    // unfortunately these do not work 
    // the header is not fixed and the text of the actions is not visible
    head.locked: true
    head.preset: "select"

    ListModel { id: items }

    ListView {
        id: listView

        anchors.fill: parent
        model: items

        delegate: ListItem {
            id: delegateItem

            width: parent.width - 2*app.paddingMedium
            x: app.paddingMedium

            onClicked: {
                selectedItem = items.get(index)
                currentIndex = index
            }

            SearchResultListItem {
                id: searchResultListItem
                dataModel: model
            }
        }
 
        onAtYEndChanged: {
            if(listView.atYEnd && model.count > 0)
                append()
        }
    }

    Scrollbar {
        id: scrollBar
        flickableItem: listView
        anchors.right: parent.right
    }

    CursorHelper {
        id: cursorHelper
    }

    onLabelChanged: refresh() // ToDo come up with a better trigger

    function refresh() {
        items.clear()
        append()
    }

    property bool _loading: false

    function append() {
        // if already at the end -> bail out
        if(items.count > 0 && items.count >= cursorHelper.total)
            return

        // guard
        if(_loading)
            return
        _loading = true

        Spotify.getUserPlaylists({offset: items.count, limit: cursorHelper.limit},function(error, data) {
            try {
                if(data) {
                    //console.log("number of playlists: " + data.items.length)
                    cursorHelper.offset = data.offset
                    cursorHelper.total = data.total
                    for (var i=0;i<data.items.length;i++) {
                        items.append({type: 2,
                                      stype: 2,
                                      name: data.items[i].name,
                                      item: data.items[i],
                                      following: true});
                    }
                } else
                    console.log("No Data for getUserPlaylists")
            } catch(err) {
                console.log("PlaylistPicker.append exception" + err)
            } finally {
                _loading = false
            }
        })
    }
}

