//
//  MovieSceneConfigurator.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 11/11/2022.
//  
//


import UIKit

final class MovieSceneConfigurator: SceneConfigurator {
    
    private var genre: Genre
    
    init(genre: Genre) {
        self.genre = genre
    }

    func configured<T>(_ vc: T) -> T where T : UIViewController {
        guard let vc = vc as? MoviesViewController else {
            fatalError()
        }
        let apiManager = ApiManager()
        let imageProvider: ImageProviderProtocol = DataProvider(apiManager: apiManager)
        let imageCache = DefaultImageCache()
        
        let dataProvider = DataProvider(apiManager: apiManager)
        
        let moviesProvider:MoviesProviderProtocol = dataProvider
        let movieDetailsProvider: MovieDetailsProtocol = dataProvider
        
        let pageLoader = PageLoader(itemsLimit: 50)
        let imageDownloader = DefaultImageDownloader(imageProvider: imageProvider, imageCache: imageCache)
        
        let viewModel: MoviesViewModelProtocol = MoviesViewModel(imageDownloader: imageDownloader, pageLoader: pageLoader, moviesProvider: moviesProvider, detailsProvider: movieDetailsProvider, currentGenreID: genre.id)
        vc.viewModel = viewModel
        vc.title = genre.name

        return vc as! T

    }
}
