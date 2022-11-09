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
//    var method: String { get }
}

enum TheMovieDBEndpoint: Endpoint {
    private enum Constants {
        static let apiKey: String = "2f114110ffe01902960893bcac96de55"
        static let language = "en-US"
        static let sortedBy = "popularity.desc"
    }
    
    case genre
    case movies(page:Int, genre: String)
    
    var path: String {
        switch self {
        case .genre:
            return "/genre/movie/list"
        case .movies(_,_):
            return "/discover/movie"
        }
    }

    var baseUrl: URL {
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
//https://api.themoviedb.org/3/discover/movie?api_key=2f114110ffe01902960893bcac96de55&language=en-US&sort_by=popularity.desc&page=2&with_genres=Animation

//struct ApiRequest {
//    private enum Constants {
//        static let defaultBaseURL: URL = URL(string: "https://api.themoviedb.org/3/")!
//    }
//
//    let baseURL: URL
//    let path: String
//    let params: [URLQueryItem]
//
//    init(baseURL: URL = Constants.defaultBaseURL, endpoint: Endpoint, params: [URLQueryItem] = []) {
//        self.baseURL = baseURL
//        self.path = endpoint.path
//        self.params = endpoint.params
//    }
//}
