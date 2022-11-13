//
//  SceneFactory.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 10/11/2022.
//  
//


import UIKit

protocol SceneConfigurator {
    func configured<T: UIViewController>(_ vc: T) -> T
}

protocol SceneFactory: AnyObject {
    var configurator: SceneConfigurator! { get set }
    func makeScene<T: UIViewController>() -> T
}

final class GenresFactory: SceneFactory {
    var configurator: SceneConfigurator!
    
    
    func makeScene<T: UIViewController>() -> T {
        let vc = GenresViewController()
        return configurator.configured(vc) as! T
    }
}

final class MoviesSceneFactory: SceneFactory {
    var configurator: SceneConfigurator!
    
    func makeScene<T: UIViewController>() -> T {
        let vc = MoviesViewController()
        return configurator.configured(vc) as! T
    }
}

