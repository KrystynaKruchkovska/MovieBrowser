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
    func discoverMovies(page: Int, for genre: String, completion: @escaping (Result<Movie, Error>) -> Void)
}

protocol MovieDetailsProtocol {
    func getDetails(for movieId: Int, completion: @escaping (Result< MovieDetails, Error>) -> Void)
}

protocol ImageProviderProtocol {
    func getImageData(for imagePath: String, completion: @escaping (Result<Data, Error>) -> Void)
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
    func discoverMovies(page: Int, for genre: String, completion: @escaping (Result<Movie, Error>) -> Void) {
        apiManager.makeRequest(request: TheMovieDBEndpoint.movies(page: page, genre: genre)) { (response: Result<Movie, Error>) in
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
//                DispatchQueue.main.async {
                    completion(.success(response))
//                }
            case let .failure(error) :
//                DispatchQueue.main.async {
                    completion(.failure(error))
//                }
            }
        }
    }
}

extension DataProvider: ImageProviderProtocol {
    func getImageData(for imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        apiManager.makeRequest(request: TheMovieDBEndpoint.poster(path: imagePath)) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private struct GenresResponse: Codable {
    let genres: [Genre]
}
