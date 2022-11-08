//
//  ApiRequest.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import Foundation

enum Endpoint {
    case genre
    case movies(genreId: String)
    
    var discrabing: String {
        switch self {
        case .genre:
            return "/genre/movie/list"
        case .movies(let genreId):
            return "/movie/\(genreId)/lists"
        }
    }
}

struct ApiRequest {
    private enum Constants {
        static let defaultBaseURL: URL = URL(string: "https://api.themoviedb.org/3/")!
    }

    let baseURL: URL
    let endpoint: String
    let params: [URLQueryItem]

    init(baseURL: URL = Constants.defaultBaseURL, endpoint: Endpoint, params: [URLQueryItem] = []) {
        self.baseURL = baseURL
        self.endpoint = endpoint.discrabing
        self.params = params
    }
}
