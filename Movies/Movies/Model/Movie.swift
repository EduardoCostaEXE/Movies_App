//
//  Movie.swift
//  Movies
//
//  Created by Cabral Costa, Eduardo on 13/06/24.
//

struct Movie: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let posterPath: String?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case overview
        case posterPath = "poster_path"
        case genres
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct MovieResponse: Codable {
    let results: [Movie]
}
