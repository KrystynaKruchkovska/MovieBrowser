//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//
//


import Foundation

protocol MoviesViewModelProtocol {
    var didFetchMovie: ( (MovieCellViewModel) -> Void )? { get set }
    var onError: ((Error) -> Void)? { get set }
    func getMovies(completion: @escaping ()->())
}

final class MoviesViewModel: MoviesViewModelProtocol {
    private var currentGenre: String
    private let apiManager = ApiManager()
    private var moviesProvider: MoviesProviderProtocol
    private var movieDetailsProvider: MovieDetailsProtocol
    private var imageDownloader: ImageDownloader
    private var pageLoader: PageLoader
    private var requestInProgress: Bool
    
    
    // Outputs
    var didFetchMovie: ( (MovieCellViewModel) -> Void )?
    var onError: ((Error) -> Void)?
    
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
        
    func getMovies(completion: @escaping ()->()) {
        if self.requestInProgress {
            completion()
            return
        }
        
        self.requestInProgress = true
        
        guard let page = pageLoader.pageToLoad else {
            completion()
            return
        }
        
        getMoviesBaseInfo(for: page) { result in
            if case .failure(let error) = result {
                DispatchQueue.main.async {
                    completion()
                    self.onError?(error)
                }
            }
            if case .success(let moviesWithBaseInfo) = result {
                self.publishUniqueMovies(moviesWithBaseInfo)
                completion()
                self.requestInProgress = false
            }
        }
    }
    
    private func publishUniqueMovies(_ moviesWithBaseInfo: [BaseMovieInfo]) {
        var movieIds = Set<Int>()
        moviesWithBaseInfo.forEach { movieInfo in
            let movieId = movieInfo.id
            if !(movieIds.contains(movieId)) {
                movieIds.insert(movieId)
                self.movieDetailsProvider.getDetails(for: movieId) { [weak self] result in
                    
                    guard let self = self else {
                        return
                    }
                    if case .failure(let error) = result {
                        DispatchQueue.main.async {
                            self.onError?(error)
                        }
                    }
                    
                    if case .success(let details) = result {
                        DispatchQueue.main.async {
                            if movieIds.count < self.pageLoader.itemsLimit {
                                self.publishMovie(with: movieInfo, details: details)
                            }
                        }
                    }
                }
            }
        }
    }

    
    private func getMoviesBaseInfo(for page: Int, completion: @escaping (Result<[BaseMovieInfo], Error>) -> Void) {
        var moviesWithBaseInfo = [BaseMovieInfo]()
        moviesProvider.discoverMovies(page: page, for: self.currentGenre) { result in
            self.requestInProgress = false
            
            if case .failure(let error) = result {
                completion(.failure(error))
            }
            
            if case .success(let movies) = result {
                moviesWithBaseInfo = movies.results
                completion(.success(moviesWithBaseInfo))
            }
        }
    }
    
    private func publishMovie(with movieInfo: BaseMovieInfo, details: MovieDetails) {
        
        let movie = MovieCellViewModel(baseMovieInfo: movieInfo, details: details, imageDownloader: imageDownloader)

        self.didFetchMovie?(movie)
    }
}

final class PageLoader {
    private let itemsPerRequest = 20
    private var lastLoadedPage: Int = 0
    
    var itemsLimit: Int
    var pageToLoad: Int? {
        return culculatePageForLoad()
    }
    
    init(itemsLimit: Int) {
        self.itemsLimit = itemsLimit
    }
    
    private func culculatePageForLoad() -> Int? {
        if (lastLoadedPage * itemsPerRequest) > itemsLimit  {
            return nil
        }
        lastLoadedPage = lastLoadedPage + 1
        return lastLoadedPage
    }
    
}
