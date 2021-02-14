//
//  Errors.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 2/10/21.
//

import Foundation
enum DataResponseError: Error {
    case networkError
    case decodeError
    case imageConvertionError

    var reason: String {
        switch self {
        case .networkError:
            return "Error while fetching"
        case .decodeError:
            return "Error while decoding"
        case .imageConvertionError:
            return "Error while converting data to UIImage"
        }
    }
}
