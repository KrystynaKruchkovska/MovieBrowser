//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//  
//


import Foundation

protocol MoviesViewModelProtocol {
    var didFetchMovies: ( ([MovieCellViewModel]) -> Void )? { get set }
    func getAllMovies()
}

class MoviesViewModel: MoviesViewModelProtocol {
    private var movies = [MovieCellViewModel]() {
        didSet {
            didFetchMovies?(movies)
        }
    }
    private let currentGenre: String
    private let apiManager = ApiManager()
    private var moviesProvider: MoviesProviderProtocol
    private var movieDetailsProvider: MovieDetailsProtocol
    private var imageDownloader: ImageDownloader
    
    // Outputs
    var didFetchMovies: ( ([MovieCellViewModel]) -> Void )?
    
    init(currentGenre: String) {
        self.currentGenre = currentGenre
        let dataProvider = DataProvider(apiManager: apiManager)
        let imageCache = DefaultImageCache()
        let imageDownloader = DefaultImageDownloader(imageProvider: dataProvider,
                                                     imageCache: imageCache)
        self.imageDownloader = imageDownloader
        moviesProvider = dataProvider
        movieDetailsProvider = dataProvider
    }
    
    func getAllMovies() {
        var moviesWithBaseInfo = [MovieInfo]()
        let group = DispatchGroup()
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            group.enter()
            self.moviesProvider.getMovies(for: self.currentGenre) { result in
                if case .failure(let error) = result {
                    print("Error: \(error)")
                }
                
                if case .success(let movies) = result {
                    moviesWithBaseInfo = movies.results
                }
                group.leave()
            }
            group.wait()
            self.movies = moviesWithBaseInfo.compactMap { movieInfo in
                let movieId = movieInfo.id
                var fullMovie: MovieCellViewModel? = nil
                group.enter()
                self.movieDetailsProvider.getDetails(for: movieId) { result in
                    if case .failure(let error) = result {
                        print("Error: \(error)")
                        group.leave()

                    }
                    if case .success(let details) = result {
                        group.leave()
                        fullMovie = MovieCellViewModel(baseMovieInfo: movieInfo, details: details, imageDownloader: imageDownloader)
                    }
                }
                group.wait()
                
                return fullMovie
            }
        }       
    }
}

