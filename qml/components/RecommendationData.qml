/**
 * Hutspot.
 * Copyright (C) 2020 Willem-Jan de Hoog
 *
 * License: MIT
 */

import QtQuick 2.0
import "../Spotify.js" as Spotify
import "../Util.js" as Util


Item {

    property alias seedModel: seedModel
    property alias attributesModel: attributesModel
    property bool useAttributes: false

    property bool _debug: true

    signal attributesChanged()
    signal seedsChanged()

    property bool _signal: true

    // type 0: Artist, 1: Track, 2: Genre
    ListModel {
        id: seedModel
        ListElement {type: -1; sid: ""; name: ""; image: "";}
        ListElement {type: -1; sid: ""; name: ""; image: "";}
        ListElement {type: -1; sid: ""; name: ""; image: "";}
        ListElement {type: -1; sid: ""; name: ""; image: "";}
        ListElement {type: -1; sid: ""; name: ""; image: "";}
    }

    function reset() {
      var i
      _signal = false
      for(i=0;i<seedModel.count;i++)
         clearSlot(i)

      setAttributeValue("tempo",  100)
      setAttributeValue("energy", 0.5)
      setAttributeValue("danceability", 0.5)
      setAttributeValue("instrumentalness", 0.5)
      setAttributeValue("speechiness", 0.5)
      setAttributeValue("acousticness", 0.5)
      setAttributeValue("liveness", 0.5)
      setAttributeValue("positiveness", 0.5)
      setAttributeValue("popularity", 50)

      _signal = true
      seedsChanged()
      attributesChanged()
    }

    function clearSlot(index) {
        var i
        var emptySeed = {type: -1, sid: "", name: "", image: "",}
        seedModel.set(index, emptySeed)
        // keep all non-empty slots at the top
        for(i=index+1;i<seedModel.count;i++) {
            var seed = seedModel.get(i)
            if(seed.type >= 0)
                // move up
                seedModel.move(i, i-1, 1)
        }
        if(_signal) seedsChanged()
    }

    function addSeed(seed) {
        seedModel.insert(0, seed)
        seedModel.remove(5, seedModel.count - 5)
        if(_signal) seedsChanged()
    }

    function getSeedTypeString(type) {
        switch(type) {
            case 0: return i18n.tr("artist")
            case 1: return i18n.tr("track")
            case 2: return i18n.tr("genre")
        }
    }

    function addArtist(artist) {
        var seed = {
            type: 0,
            sid: artist.id,
            name: artist.name,
            image: ""
        }
        addSeed(seed)
    }

    function addTrack(track) {
        var seed = {
            type: 1,
            sid: track.id,
            name: track.name,
            image: ""
        }
        addSeed(seed)
    }

    function addGenre(genre) {
        var seed = {
            type: 2,
            sid: "",
            name: genre,
            image: ""
        }
        addSeed(seed)
    }

    function getSaveData() {
        var i

        var savedSeeds = []
        for(i=0;i<seedModel.count;i++) {
            var seed = seedModel.get(i)
            if(seed.type >= 0)
                savedSeeds.push({stype: seed.type, sid: seed.sid, sname: seed.name})
        }

        var saveAttributes = {}
        for(i=0;i<attributesModel.count;i++) {
            var attribute = attributesModel.get(i)
            saveAttributes["target_"+attribute.attribute] = attribute.value
        }

        var saveData = []
        saveData.push({
            name: "saved_seeds",
            seeds: savedSeeds,
            use_attributes: useAttributes,
            attributes: saveAttributes
        })

        return saveData
    }

    function loadSaveData(saveData) {
        if(_debug) console.log("loadSeedsSaveData: " + JSON.stringify(saveData))
        _signal = false
        var i

        var savedSeeds = saveData[0].seeds
        for(i=savedSeeds.length;i>0;i--) { // reverse order
            var seed = savedSeeds[i-1]
            addSeed({type: seed.stype, sid: seed.sid, name: seed.sname, image: ""})
        }

        useAttributes = saveData[0].hasOwnProperty("use_attributes")
            ? saveData[0].use_attributes : false

        var savedAttributes = saveData[0].attributes
        for(i=0;i<attributesModel.count;i++) {
            var attribute = attributesModel.get(i)
            var propertyName = "target_"+attribute.attribute
            if(savedAttributes.hasOwnProperty(propertyName))
                attribute.value = savedAttributes[propertyName]
        }

        _signal = true
    }

    function getLabelText(attribute) {
        switch(attribute) {
            case "tempo": return i18n.tr("Tempo")
            case "energy": return i18n.tr("Energy")
            case "danceability": return i18n.tr("Danceability")
            case "instrumentalness": return i18n.tr("Instrumentalness")
            case "speechiness": return i18n.tr("Speechiness")
            case "acousticness": return i18n.tr("Acousticness")
            case "liveness": return i18n.tr("Liveness")
            case "positiveness": return i18n.tr("Positiveness")
            case "popularity": return i18n.tr("Popularity")
        }
    }

    ListModel {
        id: attributesModel
        ListElement {attribute: "tempo"; min: 0; max: 512; value: 100}
        ListElement {attribute: "energy"; min: 0; max: 1.0; value: 0.5}
        ListElement {attribute: "danceability"; min: 0; max: 1.0; value: 0.5}
        ListElement {attribute: "instrumentalness"; min: 0; max: 1.0; value: 0.5}
        ListElement {attribute: "speechiness"; min: 0; max: 1.0; value: 0.5}
        ListElement {attribute: "acousticness"; min: 0; max: 1.0; value: 0.5}
        ListElement {attribute: "liveness"; min: 0; max: 1.0; value: 0.5}
        ListElement {attribute: "positiveness"; min: 0; max: 1.0; value: 0.5}
        ListElement {attribute: "popularity"; min: 0; max: 100; value: 50}
    }

    function getAttributeValuesForQuery(options) {
        var i
        for(i=0;i<attributesModel.count;i++) {
            var attribute = attributesModel.get(i)
            options["target_"+attribute.attribute] = attribute.value
            //console.log("options[%1]: %2".arg("target_"+attribute.attribute).arg(attribute.value))
        }
        return options
    }

    /*function setAttributeValues(options) {
        var i
        for(i=0;i<attributesModel.count;i++) {
            var attribute = attributesModel.get(i)
            var propertyName = "target_"+attribute.attribute
            if(options.hasOwnProperty(propertyName)) {
                attribute.value = options[propertyName]
                //var item = listView.itemAtIndex(i)
                //item.slider.value = attribute.value
            }
        }
    }*/

    function setAttributeValue(name, value) {
        var i
        for(i=0;i<attributesModel.count;i++) {
            var attribute = attributesModel.get(i)
            if(name === attribute.attribute) {
                attribute.value = value
                if(_signal)
                    attributesChanged()
                return
            }
        }
    }
}
