//
//  ImageCache.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 10/11/2022.
//  
//


import UIKit

protocol ImageCache: AnyObject {
    func setImage(_ image: UIImage, for path: String)
    func getImage(for path: String) -> UIImage?
}

final class DefaultImageCache: ImageCache {

    private let cache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, for path: String) {
        cache.setObject(image, forKey: path as NSString)
    }

    func getImage(for path: String) -> UIImage? {
        cache.object(forKey: path as NSString)
    }
}
