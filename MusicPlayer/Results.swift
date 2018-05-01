//
//  Results.swift
//  MusicPlayer
//
//  Created by Maribel Montejano on 4/30/18.
//  Copyright © 2018 Maribel Montejano. All rights reserved.
//

import Foundation

struct Results: Codable {
    let resultCount: Int
    let results: [Track]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}
