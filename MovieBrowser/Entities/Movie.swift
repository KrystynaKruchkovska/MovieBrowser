//
//  Movie.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//  
//


import Foundation

struct Movie: Codable {
    let id: Int
    let page: Int
    let results: [MovieInfo]
}

struct MovieInfo: Codable {
    let description: String
    let favoriteCount, id, itemCount: Int
    let name: String
    let posterPath: String?
}
