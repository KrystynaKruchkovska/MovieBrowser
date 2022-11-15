//
//  Movie.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//  
//


import Foundation

struct Movie: Codable {
    let page: Int
    let results: [BaseMovieInfo]
}

struct BaseMovieInfo: Codable {
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, title: String
    let releaseDate: String
            
}
