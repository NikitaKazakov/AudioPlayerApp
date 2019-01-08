//
//  AudioPlayableProvider.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 3/5/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation

class AudioPlayableProvider:AudioItemProviderProtocol {
    var tracks: [Playable]
    
    required init(tracks: [Playable]) {
        self.tracks = tracks
    }
    
}
