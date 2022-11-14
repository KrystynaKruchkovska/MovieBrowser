//
//  ImageDownloader.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 10/11/2022.
//  
//

import UIKit

protocol ImageDownloader: AnyObject {
    func download(with path: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID
    func cancelTask(for UUID: UUID)
}


final class DefaultImageDownloader: ImageDownloader {

    private var runningRequests = [UUID: URLSessionDataTask]()
    private let imageProvider: ImageProviderProtocol
    private let imageCache: ImageCache


    init(imageProvider: ImageProviderProtocol, imageCache: ImageCache) {
        self.imageProvider = imageProvider
        self.imageCache = imageCache
    }

    func download(with path: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID  {
        if let image = imageCache.getImage(for: path) {
           completion(.success(image))
        }
        let uuid = UUID()
        
        let task = imageProvider.getImageData(for: path) { [weak self] result in
            
            defer { self?.runningRequests.removeValue(forKey: uuid) }
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
        runningRequests[uuid] = task
        return uuid
    }

    func cancelTask(for UUID: UUID) {
        runningRequests[UUID]?.cancel()
        runningRequests.removeValue(forKey: UUID)
    }
}
