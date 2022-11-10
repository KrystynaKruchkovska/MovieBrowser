//
//  ImageDownloader.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 10/11/2022.
//  
//

import UIKit

protocol ImageDownloader: AnyObject {
    func download(with path: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}


final class DefaultImageDownloader: ImageDownloader {

//    private var runningRequests = [UUID: URLSessionDataTask]()
    private let imageProvider: ImageProviderProtocol
    private let imageCache: ImageCache


    init(imageProvider: ImageProviderProtocol, imageCache: ImageCache) {
        self.imageProvider = imageProvider
        self.imageCache = imageCache
    }

    func download(with path: String, completion: @escaping (Result<UIImage, Error>) -> Void)  {
        if let image = imageCache.getImage(for: path) {
           completion(.success(image))
        }
        let uuid = UUID()
        
        imageProvider.getImageData(for: path) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    return
                }
                self?.imageCache.setImage(image, for: path)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

//    /// - SeeAlso: `ImageDownloader.cancelTask`
//    func cancelTask(for UUID: UUID) {
//        runningRequests[UUID]?.cancel()
//        runningRequests.removeValue(forKey: UUID)
//    }
}
