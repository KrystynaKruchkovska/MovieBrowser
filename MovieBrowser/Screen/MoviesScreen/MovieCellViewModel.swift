//
//  MovieCellViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 10/11/2022.
//  
//


import UIKit

struct MovieCellViewModel {
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, title: String
    let releaseDate: String
    let runtime: Int
    var imageDownloader: ImageDownloader?

    var movieDuration: String {
        return culculateMovieDuration(runtime: runtime)
    }
}

extension MovieCellViewModel {
    
    init(baseMovieInfo: MovieInfo,
         details: MovieDetails,
         imageDownloader: ImageDownloader) {
        self.id = baseMovieInfo.id
        self.originalLanguage = baseMovieInfo.originalLanguage
        self.popularity = baseMovieInfo.popularity
        self.posterPath = baseMovieInfo.posterPath
        self.releaseDate = baseMovieInfo.releaseDate
        self.originalTitle = baseMovieInfo.originalTitle
        self.overview = baseMovieInfo.overview
        self.title = baseMovieInfo.title
        self.runtime = details.runtime
        
        self.imageDownloader = imageDownloader
    }
    
    func culculateMovieDuration(runtime: Int) -> String {
        let hour: Int = runtime / 60
        let min = runtime - (hour * 60)
        return hour > 1 ? "\(hour)h \(min)m" : "\(min)m"
    }
    
    func getPosterImage(completion: @escaping (UIImage?) -> ()) {
        imageDownloader?.download(with: posterPath, completion: { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                completion(nil)
            }
        })
    }
}

extension MovieCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
