//
//  Movies.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 19/09/21.
//

import Foundation

struct Movies: Codable {
    let listOfMovies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case listOfMovies = "results"
    }
}

struct Movie: Codable {
    let title: String
    let popularity: Double
    let id: Int
    let voteCount: Int
    let originalTitle: String
    let voteAverage: Double
    let overview: String
    let releaseDate: String
    let posterPath: String
    let backdropPath: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case popularity
        case id = "id"
        case voteCount = "vote_count"
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case overview = "overview"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}