//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//  
//


import Foundation

protocol MoviesViewModelProtocol: AnyObject {
    var didFetchMovies: ( (MovieCellViewModel) -> Void )? { get set }
    func getMovies()
}

class MoviesViewModel: MoviesViewModelProtocol {
    private var currentGenre: String
    private let apiManager = ApiManager()
    private var moviesProvider: MoviesProviderProtocol
    private var movieDetailsProvider: MovieDetailsProtocol
    private var imageDownloader: ImageDownloader
    private var pageLoader: PageLoader
    private var requestInProgress: Bool
    
    
    // Outputs
    var didFetchMovies: ( (MovieCellViewModel) -> Void )?
    
    init(imageDownloader: ImageDownloader,
         pageLoader: PageLoader,
         moviesProvider: MoviesProviderProtocol,
         detailsProvider: MovieDetailsProtocol,
         currentGenreID: Int) {
        
        self.pageLoader = pageLoader
        self.imageDownloader = imageDownloader
        self.moviesProvider = moviesProvider
        self.movieDetailsProvider = detailsProvider
        self.currentGenre = String(currentGenreID)
        self.requestInProgress = false
    }
    
    func getMovies() {
        if self.requestInProgress {
            return
        }
        self.requestInProgress = true

        DispatchQueue.global(qos: .userInteractive).async { [self] in
            getMoviesBaseInfo { result in
                
                let group = DispatchGroup()
                
                if case .failure(let error) = result {
                    print("Error: \(error)")
                }
                if case .success(let moviesWithBaseInfo) = result {
                    
                    moviesWithBaseInfo.forEach { movieInfo in
                        let movieId = movieInfo.id
                        group.enter()
            
                        self.movieDetailsProvider.getDetails(for: movieId) { [weak self] result in
                            guard let self = self else {
                                group.leave()
                                return
                            }
                            
                            if case .failure(let error) = result {
                                print("Error: \(error)")
                            }
                            
                            if case .success(let details) = result {
                                if self.pageLoader.current < self.pageLoader.itemsLimit {
                                    self.pageLoader.current += 1
                                    
                                    let movie = MovieCellViewModel(baseMovieInfo: movieInfo, details: details, imageDownloader: self.imageDownloader)
                                    
                                    DispatchQueue.main.async {
                                        self.didFetchMovies?(movie)
                                    }
                                }
                            }
                            group.leave()
                        }
                    }
                }
                group.wait()
                
                self.requestInProgress = false
            }
        }
    }
    
    private func getMoviesBaseInfo(completion: @escaping (Result< [MovieInfo], Error>) -> Void) {
        var moviesWithBaseInfo = [MovieInfo]()
        
        guard let page = pageLoader.pageToLoad else {
            return
        }
        
        moviesProvider.discoverMovies(page: page, for: self.currentGenre) { result in
            if case .failure(let error) = result {
                completion(.failure(error))
            }
            
            if case .success(let movies) = result {
                moviesWithBaseInfo = movies.results
                completion(.success(moviesWithBaseInfo))
            }
        }
    }
}

class PageLoader {
    let itemsPerRequest = 20
    var current: Int = 0
    var itemsLimit: Int
    
    var pageToLoad: Int? {
        return culculatePageForLoad()
    }
    
    init(itemsLimit: Int) {
        self.itemsLimit = itemsLimit
    }
    
    private func culculatePageForLoad() -> Int? {
        if current == itemsLimit {
            return nil
        }
        return (current / itemsPerRequest) + 1
    }
    
}
