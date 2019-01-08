//
//  Playable.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 3/3/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import UIKit

protocol Playable {
    var url: URL {get set}
    var name: String {get set}
    var image: UIImage? {set get}
}
