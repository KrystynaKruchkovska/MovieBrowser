//
//  GenresConfigurator.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 11/11/2022.
//  
//


import UIKit

class GenresSceneConfirurator: SceneConfigurator {
    func configured<T>(_ vc: T) -> T where T : UIViewController {
        guard let vc = vc as? GenresViewController else {
            fatalError()
        }
        
        let apiManager = ApiManager()
        let genresProvider: GenresProviderProtocol = DataProvider(apiManager: apiManager)
        
        vc.viewModel = GenresViewModel(genresProvider: genresProvider)
        
        return vc as! T
    }
    
    
}
