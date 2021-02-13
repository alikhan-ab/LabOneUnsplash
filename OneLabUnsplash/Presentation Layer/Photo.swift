//
//  Post.swift
//  OneLabUnsplash
//
//  Created by Айдана on 1/31/21.
//

import Foundation

struct User: Decodable {
    let id: String
    let username: String
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct Photo: Decodable {
    let id: String
    let createdAt: String
    let urls: [String: URL]
    let width: Int
    let height: Int
    let blurHash: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case urls
        case width
        case height
        case blurHash = "blur_hash"
        case user
    }
}
