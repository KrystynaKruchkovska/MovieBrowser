//
//  ApiManager.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import Foundation

final class ApiManager {

    func makeRequest<T: Codable>(request: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        URLSession.shared.dataTask(with: makeURLRequest(from: request)) {  data, _, error in

            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    completion(.success(try decoder.decode(T.self, from: data)))
                } catch {
                    print("ERROR: ", error)
                    completion(.failure(error))
                    
                }
            } else {
                completion(.failure(UnknownApiError()))
            }
        }.resume()
    }

    @discardableResult
    func makeRequest(request: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) ->  URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: makeURLRequest(from: request)) {  data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(UnknownApiError()))
            }
        }
        task.resume()
        return task
    }

    private func makeURLRequest(from endpoint: Endpoint) -> URLRequest {
        URLRequest(url: endpoint.baseUrl
            .appending(path: endpoint.path)
            .appending(queryItems: endpoint.parameters)
        )
    }
}
