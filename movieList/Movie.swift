//
//  Movie.swift
//  movieList
//
//  Created by Wang Jing on 26/6/22.
//

import Foundation

struct MovieData: Decodable {
    let Search: [Movie]
    let totalResults: String
    let Response: String
    
}

struct Movie: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
