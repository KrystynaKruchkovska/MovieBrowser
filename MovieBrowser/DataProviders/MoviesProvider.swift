//
//  MoviesProvider.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//  
//


import Foundation

class MoviesProvider {
    func getMovies(for genre: String ,completion: @escaping (Result<Movie, Error>) -> Void) {
        apiManager.makeRequest(request:  TheMovieDBEndpoint.movies(page: 1, genre: genre)) { (response: Result<Movie, Error>) in
            switch response {
            case let .success(response):
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            case let .failure(error) :
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private (set) var apiManager: ApiManager
    
    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }
}

private struct MoviesResponse: Codable {
    let genres: [Movie]
}
