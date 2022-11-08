//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//  
//


import Foundation

protocol MoviesViewModelProtocol {
    func getAllMovies()
}

class MoviesViewModel: MoviesViewModelProtocol {
    var movies = [MovieInfo]()
    let currentGenre: String
    private let apiManager = ApiManager()
    private var moviesProvider: MoviesProvider
    
    init(currentGenre: String) {
        self.currentGenre = currentGenre
        moviesProvider = MoviesProvider(apiManager: apiManager)
    }
    
    func getAllMovies() {
        moviesProvider.getMovies(for: currentGenre) { result in
            if case .failure(let error) = result {
                print("Error: \(error)")
            }
            
            if case .success(let movies) = result {
                self.movies = movies.results
                print("MOVIES: \(self.movies.count)")
            }
        }
    }
    
    
    
}
