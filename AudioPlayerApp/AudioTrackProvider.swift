//
//  AudioTrackProvider.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 3/4/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import UIKit

class Track: Playable {
    var image: UIImage?
    var name: String
    var url: URL
    
    init(name: String,url: URL,image: UIImage = UIImage()){
        self.name = name
        self.image = image
        self.url = url
    }
}
