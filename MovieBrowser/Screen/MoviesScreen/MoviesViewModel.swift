//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 08/11/2022.
//  
//


import Foundation

protocol MoviesViewModelProtocol {
    var didFetchMovies: ( ([MovieInfoViewModel]) -> Void )? { get set }
    func getAllMovies()
}

class MoviesViewModel: MoviesViewModelProtocol {
    private var movies = [MovieInfoViewModel]() {
        didSet {
            didFetchMovies?(movies)
        }
    }
    private let currentGenre: String
    private let apiManager = ApiManager()
    private var moviesProvider: MoviesProviderProtocol
    private var movieDetailsProvider: MovieDetailsProtocol
    
    // Outputs
    var didFetchMovies: ( ([MovieInfoViewModel]) -> Void )?
    
    init(currentGenre: String) {
        self.currentGenre = currentGenre
        let dataProvider = DataProvider(apiManager: apiManager)
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
                var fullMovie: MovieInfoViewModel? = nil
                group.enter()
                self.movieDetailsProvider.getDetails(for: movieId) { result in
                    if case .failure(let error) = result {
                        print("Error: \(error)")
                        group.leave()

                    }
                    if case .success(let details) = result {
                        group.leave()
                        fullMovie = MovieInfoViewModel(baseMovieInfo: movieInfo, details: details)
                    }
                }
                group.wait()
                
                return fullMovie
            }
        }       
    }
}

struct MovieInfoViewModel {
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, title: String
    let releaseDate: Date
    let runtime: Int
    
    var movieDuration: String {
        return culculateMovieDuration(runtime: runtime)
    }
}

extension MovieInfoViewModel {
    init(baseMovieInfo: MovieInfo, details: MovieDetails) {
        self.id = baseMovieInfo.id
        self.originalLanguage = baseMovieInfo.originalLanguage
        self.popularity = baseMovieInfo.popularity
        self.posterPath = baseMovieInfo.posterPath
        self.releaseDate = baseMovieInfo.releaseDate
        self.originalTitle = baseMovieInfo.originalTitle
        self.overview = baseMovieInfo.overview
        self.title = baseMovieInfo.title
        self.runtime = details.runtime
    }
    
    func culculateMovieDuration(runtime: Int) -> String {
        let hour: Int = runtime / 60
        let min = runtime - (hour * 60)
        return hour > 1 ? "\(hour)h \(min)m" : "\(min)m"
    }
}

extension MovieInfoViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

}
