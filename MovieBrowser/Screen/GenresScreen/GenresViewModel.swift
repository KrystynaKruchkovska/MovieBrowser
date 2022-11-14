//
//  GenresViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 11/11/2022.
//  
//


import Foundation

protocol GenresViewModelProtocol: AnyObject {
    var didFetchGeners: ( ([Genre]) -> Void )? { get set }
    var onError: ((Error) -> Void)? { get set }
    func getAllGenres()
}

final class GenresViewModel: GenresViewModelProtocol {
    
    private var genresProvider: GenresProviderProtocol?
    
    // Outputs
    var didFetchGeners: ( ([Genre]) -> Void )?
    var onError: ((Error) -> Void)?

    
    init(genresProvider: GenresProviderProtocol? = nil) {
        self.genresProvider = genresProvider
    }
    
    func getAllGenres() {
        genresProvider?.getGenres { result in
            switch result {
            case let .success(genres):
                self.didFetchGeners?(genres)
            case let .failure(error):
                self.onError?(error)
            }
        }
    }
}
