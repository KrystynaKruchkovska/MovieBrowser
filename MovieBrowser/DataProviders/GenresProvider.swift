//
//  GenresProvider.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import Foundation

protocol ProviderProtocol {
    var apiManager: ApiManager { get }
    
    func fetchAll<T: Codable>(completion: @escaping (Result<[T], Error>) -> Void)
}

final class GenresProvider {
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

private struct GenresResponse: Codable {
    let genres: [Genre]
}
