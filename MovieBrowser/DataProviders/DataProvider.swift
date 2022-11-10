//
//  DataProvider.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 09/11/2022.
//  
//

import Foundation

protocol GenresProviderProtocol {
    func getGenres(completion: @escaping (Result<[Genre], Error>) -> Void)
}

protocol MoviesProviderProtocol {
    func getMovies(for genre: String ,completion: @escaping (Result<Movie, Error>) -> Void)
}

protocol MovieDetailsProtocol {
    func getDetails(for movieId: Int, completion: @escaping (Result< MovieDetails, Error>) -> Void)
    
}

final class DataProvider: GenresProviderProtocol {
    func getGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        apiManager.makeRequest(request: TheMovieDBEndpoint.genre) { (response: Result<GenresResponse, Error>) in
            switch response {
            case let .success(response):
                DispatchQueue.main.async {
                    completion(.success(response.genres))
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

extension DataProvider: MoviesProviderProtocol {
    func getMovies(for genre: String ,completion: @escaping (Result<Movie, Error>) -> Void) {
        apiManager.makeRequest(request: TheMovieDBEndpoint.movies(page: 1, genre: genre)) { (response: Result<Movie, Error>) in
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
}

extension DataProvider: MovieDetailsProtocol {
    func getDetails(for movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        apiManager.makeRequest(request: TheMovieDBEndpoint.movieDetails(id: movieId)) { (response: Result<MovieDetails, Error>) in
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
}

private struct GenresResponse: Codable {
    let genres: [Genre]
}
