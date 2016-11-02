//
//  SonosInfo.swift
//  Living
//
//  Created by Nelson FB on 26/10/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import SwiftyJSON

class SonosInfo{

    var play_mode:String = ""
    var player_name:String = ""
    var volume:Int = 0
    var mute:Bool = false
    var current_track:[String:String] = [:]
    var playlists:[String:String] = [:]
    var state:String = ""

    
    func addCurrentTrackTrack(json:JSON){
        for (key,subJson):(String, JSON) in json {
            //Do something you want
            self.current_track[key] = subJson.stringValue
        }
    }
    func addTrackPlaylist(json:JSON){
        for (key,subJson):(String, JSON) in json {
            //Do something you want
            self.playlists[key] = subJson.stringValue
        }
    }
    
   /* {
    "response" : {
    "play_mode" : "NORMAL",
    "player_name" : "Living Room",
    "volume" : 18,
    "playlists" : [
    {
    "playlist_id" : "0",
    "title" : "Playlist Intel"
    }
    ],
    "mute" : false,
    "state" : "PAUSED_PLAYBACK",
    "radio_stations" : {
    "total" : "0",
    "returned" : 0,
    "favorites" : [
    
    ]
    },
    "current_track" : {
    "duration" : "0:07:38",
    "album" : "Aurora",
    "artist" : "John Monkman",
    "playlist_position" : "1",
    "position" : "0:01:34",
    "album_art" : "http:\/\/192.168.1.108:1400\/getaa?s=1&u=x-sonosprog-http%3atr%253a128335867.mp3%3fsid%3d2%26flags%3d8224%26sn%3d2",
    "uri" : "x-sonosprog-http:tr%3a128335867.mp3?sid=2&flags=8224&sn=2",
    "title" : "AURORA (Original Mix)"
},
"queue" : [

]
},
"status" : "done"
}*/


}
