//
//  GenresViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 11/11/2022.
//  
//


import Foundation

class GenresViewModel {
    
    
    private var genresProvider: GenresProviderProtocol?
    private var genres: [Genre]? {
        didSet {
            didFetchGeners?(genres!)
        }
    }
    
    // Outputs
    var didFetchGeners: ( ([Genre]) -> Void )?
    
    init(genresProvider: GenresProviderProtocol? = nil) {
        self.genresProvider = genresProvider
    }
    
    func getAllGenres() {
        genresProvider?.getGenres { result in
            switch result {
            case let .success(genres):
                self.genres = genres
            case let .failure(error):
                print("Cannot get genres, reason: \(error)")
            }
        }
    }
}
