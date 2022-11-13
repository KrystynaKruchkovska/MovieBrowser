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
    func getAllMovies()
}

class MoviesViewModel: MoviesViewModelProtocol {
    private var movie: MovieCellViewModel? {
        didSet {
            pageLoader.current += 1 
            didFetchMovies?(movie!)
        }
    }
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
    
    func getAllMovies() {
        guard let page = pageLoader.pageToLoad else {
            return
        }
        
        if self.requestInProgress {
            return
        }
        
        self.requestInProgress = true
        
        var moviesWithBaseInfo = [MovieInfo]()
        let group = DispatchGroup()
    
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            group.enter()
            self.moviesProvider.getMovies(page: page, for: self.currentGenre) { result in
                if case .failure(let error) = result {
                    print("Error: \(error)")
                }
                
                if case .success(let movies) = result {
                    moviesWithBaseInfo = movies.results
                }
                
                group.leave()
            }
            
            group.wait()
            
            moviesWithBaseInfo.forEach { movieInfo in
                if pageLoader.current == 50 {
                    return
                }
                let movieId = movieInfo.id
                group.enter()
                self.movieDetailsProvider.getDetails(for: movieId) { [weak self] result in
                    guard let self = self else {
                        group.leave()
                        return
                    }
                    if case .failure(let error) = result {
                        print("Error: \(error)")
                        group.leave()

                    }
                    if case .success(let details) = result {
                        group.leave()
                        self.movie = MovieCellViewModel(baseMovieInfo: movieInfo, details: details, imageDownloader: self.imageDownloader)
                    }
                }
                
                group.wait()
            }
            
            self.requestInProgress = false
        }
    }
}

class PageLoader {
    var current: Int = 0
    var pageToLoad: Int? {
        return culculatePageForLoad()
    }
    
    private func culculatePageForLoad() -> Int? {
        if current > 50 {
            return nil
        }
        return (current / 20) + 1
    }
    
}
