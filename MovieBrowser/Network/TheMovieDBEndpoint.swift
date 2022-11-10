//
//  ApiRequest.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import Foundation

protocol Endpoint {
    var baseUrl: URL { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
}

enum TheMovieDBEndpoint: Endpoint {
    private enum Constants {
        static let apiKey: String = "2f114110ffe01902960893bcac96de55"
        static let language = "en-US"
        static let sortedBy = "popularity.desc"
    }
    
    case genre
    case movies(page:Int, genre: String)
    case movieDetails(id: Int)
    case poster(path: String)
    
    var path: String {
        switch self {
        case .genre:
            return "/genre/movie/list"
        case .movies(_,_):
            return "/discover/movie"
        case .movieDetails(let id):
            //https://api.themoviedb.org/3/movie/718930?api_key=2f114110ffe01902960893bcac96de55
            return "/movie/\(id)"
        case .poster(let path):
            return path
        }
    }

    var baseUrl: URL {
        if case .poster = self {
            return URL(string: "https://image.tmdb.org/t/p/w500/")!
        }
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var parameters: [URLQueryItem] {
        var queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey)]
        if case let .movies(page, genre) = self {
            queryItems += [
                URLQueryItem(name: "language", value: Constants.language),
                URLQueryItem(name: "sort_by", value: Constants.sortedBy),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "with_genres", value: genre),
            ]
        }
        return queryItems
    }
}
