//
//  Track.swift
//  MusicPlayer
//
//  Created by Maribel Montejano on 4/30/18.
//  Copyright © 2018 Maribel Montejano. All rights reserved.
//

import Foundation

struct Track: Codable {
    let artistName: String
    let trackName: String
    let artworkUrl60: String
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
        case artworkUrl60
    }
}
