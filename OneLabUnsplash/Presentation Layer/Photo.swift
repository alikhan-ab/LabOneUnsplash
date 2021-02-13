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
    let name: String
    let firstName: String
    let secondName: String
}

struct Photo: Decodable {
    let id: String
    let createdAt: String
    let urls: [String: String]
    let width: Int
    let height: Int
    let blurHash: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case urls
        case width
        case height
        case blurHash = "blur_hash"        
    }


    
}
