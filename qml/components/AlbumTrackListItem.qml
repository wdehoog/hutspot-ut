/**
 * Copyright (C) 2018 Willem-Jan de Hoog
 *
 * License: MIT
 */

import QtQuick 2.0
import Ubuntu.Components 1.3

import "../Util.js" as Util

Item {

    property var isFavorite

    property int contextType: -1 // not used but needed for Loader in Playing page

    property var dataModel
    signal toggleFavorite()

    width: parent.width
    height: Math.max(labelss.height, savedImage.height)
    anchors.verticalCenter: parent.verticalCenter

    opacity: Util.isTrackPlayable(dataModel.item) ? 1.0 : 0.4

    Image {
        id: savedImage
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: app.iconSizeSmall
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        source: isFavorite 
                ? "image://theme/starred"
                : "image://theme/non-starred"
        /*source: {
            if(isFavorite)
                return currentIndex === dataModel.index
                        ? "image://theme/icon-m-favorite-selected?" + Theme.highlightColor
                        : "image://theme/icon-m-favorite-selected"
            else
                return currentIndex === dataModel.index
                          ? "image://theme/icon-m-favorite?" + Theme.highlightColor
                          : "image://theme/icon-m-favorite"
        }*/
        // these are used in the Spotify application
        //source: isFavorite ? "image://theme/icon-m-certificates" : "image://theme/icon-m-add"
        MouseArea {
             anchors.fill: parent
             onClicked: toggleFavorite()
        }
    }

    Item {
        id: labelss
        anchors.left: savedImage.right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: app.paddingMedium

        Text {
            id: label
            anchors.left: parent.left
            anchors.right: duration.left
            anchors.rightMargin: app.paddingLarge
            anchors.verticalCenter: parent.verticalCenter
            //color: currentIndex === dataModel.index ? Theme.highlightColor : Theme.primaryColor
            textFormat: Text.StyledText
            text: dataModel.name ? dataModel.name : i18n.tr("No Name")
        }

        Text {
            id: duration
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            //color: currentIndex === dataModel.index ? Theme.highlightColor : Theme.primaryColor
            //font.pixelSize: app.fontSizeSmall
            text: Util.getDurationString(dataModel.item.duration_ms)
            enabled: text.length > 0
            visible: enabled
        }
    }

}