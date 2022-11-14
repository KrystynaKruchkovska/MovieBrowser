//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//
//


import Foundation

protocol MoviesViewModelProtocol: AnyObject {
    var didFetchMovie: ( (MovieCellViewModel) -> Void )? { get set }
    var onError: ((Error) -> Void)? { get set }
    func getMovies(completion: @escaping ()->())
    var requestInProgress: Bool { get }

}

final class MoviesViewModel: MoviesViewModelProtocol {
    private var currentGenre: String
    private let apiManager = ApiManager()
    private var moviesProvider: MoviesProviderProtocol
    private var movieDetailsProvider: MovieDetailsProtocol
    private var imageDownloader: ImageDownloader
    private var pageLoader: PageLoader
    private(set) var requestInProgress: Bool
    
    
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
        let serialQueue = DispatchQueue(label: "serial.queue")
        serialQueue.sync { [self] in
            
            print("REQUEST requestInProgress \(requestInProgress)")
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
                    let serialQueue2 = DispatchQueue(label: "serial.queue2")
                    serialQueue2.sync {
                        var current = 0
                        moviesWithBaseInfo.forEach { movieInfo in
                            print("|||")
                            let movieId = movieInfo.id
                              current += 1

                            self.movieDetailsProvider.getDetails(for: movieId) { [unowned self] result in

                                if case .failure(let error) = result {
                                    DispatchQueue.main.async {
                                        self.onError?(error)
                                    }
                                }
                                
                                if case .success(let details) = result {
                                    DispatchQueue.main.async {
                                        if current < self.pageLoader.itemsLimit {
                                            self.publishMovie(with: movieInfo, details: details)
                                        }
                                    }
                                }
                            }
                        }
                        print("AFTER |||")
                        completion()
                        self.requestInProgress = false
                    }
                }
            }
        }
    }
    
    private func getMoviesBaseInfo(for page: Int, completion: @escaping (Result< [MovieInfo], Error>) -> Void) {
        var moviesWithBaseInfo = [MovieInfo]()
        

        
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
    
    private func publishMovie(with movieInfo: MovieInfo, details: MovieDetails) {

        let movie = MovieCellViewModel(baseMovieInfo: movieInfo, details: details, imageDownloader: imageDownloader)
        
        self.didFetchMovie?(movie)
    }
}

class PageLoader {
    let itemsPerRequest = 20
//    var current: Int = 0
    var itemsLimit: Int
    var lastLoadedPage: Int = 0
    var pageToLoad: Int? {
        let result = culculatePageForLoad()
        print("PAGE to load \(String(describing: result))")
        print("Thread\(Thread.current)")
        return result
    }
    
    init(itemsLimit: Int) {
        self.itemsLimit = itemsLimit
    }
    
    private func culculatePageForLoad() -> Int? {
//        print("Current \(current)")
        if (lastLoadedPage * itemsPerRequest) > itemsLimit  {
            return nil
        }
        lastLoadedPage = lastLoadedPage + 1
        return lastLoadedPage
    }
    
}
