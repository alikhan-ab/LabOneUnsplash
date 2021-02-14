//
//  LocalStorage.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 2/13/21.
//

import Foundation
import UIKit
protocol LocalStorage {
    func fetchImage(url: URL) -> UIImage?
    func save(image: UIImage, for url: URL)
}

class LocalStorageImpl: LocalStorage {
    func fetchImage(url: URL) -> UIImage? {
        return nil
    }

    func save(image: UIImage, for url: URL) {
        return
    }
}
