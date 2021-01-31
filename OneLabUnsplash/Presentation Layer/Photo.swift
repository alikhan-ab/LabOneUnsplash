//
//  Post.swift
//  OneLabUnsplash
//
//  Created by Айдана on 1/31/21.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let created_at: String
    let urls: [String: String]
    let width: Int
    let height: Int
}
