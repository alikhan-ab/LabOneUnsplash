//
//  Errors.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 2/10/21.
//

import Foundation
enum DataResponseError {
    case networkError
    case decodeError

    var reason: String {
        switch self {
        case .networkError:
            return "Error while fetching"
        case .decodeError:
            return "Error while decoding"
        }
    }
}
