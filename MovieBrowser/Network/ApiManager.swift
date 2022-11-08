//
//  ApiManager.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import Foundation

final class ApiManager {
    private enum Constants {
        static let apiKey: String = "2f114110ffe01902960893bcac96de55"
    }

    func makeRequest<T: Codable>(request: ApiRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        URLSession.shared.dataTask(with: makeURLRequest(from: request)) {  data, _, error in

            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    completion(.success(try decoder.decode(T.self, from: data)))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(UnknownApiError()))
            }
        }.resume()
    }

    private func makeURLRequest(from apiRequest: ApiRequest) -> URLRequest {
        URLRequest(url: apiRequest.baseURL
            .appending(path: apiRequest.endpoint)
            .appending(queryItems: [URLQueryItem(name: "api_key", value: Constants.apiKey)])
            .appending(queryItems: apiRequest.params)
        )
    }
}
