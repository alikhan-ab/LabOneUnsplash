//
//  ImageDownloadService.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 2/13/21.
//

import Foundation
import UIKit
protocol ImageDownloadService {
    func fetchImage(with url: URL,
                         success: @escaping (UIImage, URL) -> Void,
                         failure: @escaping (DataResponseError) -> Void)
    func cancelImageFetch(for: URL)
}

final class ImageDownloadServiceImpl {
    static let shared = ImageDownloadServiceImpl()

    private init() {}

    let localStorage: LocalStorage = LocalStorageImpl()
    var imageRequests: [URL: ImageRequest] = [:]
}

extension ImageDownloadServiceImpl: ImageDownloadService {
    func fetchImage(with url: URL, success: @escaping (UIImage, URL) -> Void, failure: @escaping (DataResponseError) -> Void) {
        if localStorage.fetchImage(url: url) == nil {
            let request = ImageRequest(url: url)
            imageRequests[url] = request
            request.fetch { [weak self] (image, response) in
                self?.localStorage.save(image: image, for: url)
                self?.imageRequests.removeValue(forKey: url)
                success(image, url)
            } errorCompletion: { (error) in
                failure(error)
            }
        }
    }

    func cancelImageFetch(for url: URL) {
        if let request = imageRequests[url] {
            request.cancelFetch(for: url)
        }
    }
}
