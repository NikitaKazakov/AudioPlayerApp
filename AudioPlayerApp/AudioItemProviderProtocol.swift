//
//  AudioItemProviderProtocol.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 3/4/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation

protocol AudioItemProviderProtocol {
    var tracks: [Playable] { get }
    init(tracks: [Playable])
}
