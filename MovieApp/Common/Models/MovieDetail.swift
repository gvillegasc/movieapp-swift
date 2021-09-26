//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 21/09/21.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let cast: [Cast]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}

struct Cast: Codable {
    let adult: Bool
    let gender: Int
    let id: Int
    let name: String
    let profilePath: String?
    let originalName: String
    let character: String
    
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case name
        case profilePath = "profile_path"
        case originalName = "original_name"
        case character
    }
}
