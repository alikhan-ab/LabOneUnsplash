//
//  Post.swift
//  OneLabUnsplash
//
//  Created by Айдана on 1/31/21.
//

import Foundation

struct User {
    let id: String
    let username: String
    let firstName: String
    let lastName: String?
    let profileImage: URL
}

extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImage = "profile_image"

        enum ProfileImageKeys: String, CodingKey {
            case profileImage = "small"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String?.self, forKey: .lastName)

        let profileImageContrainer = try container.nestedContainer(keyedBy: CodingKeys.ProfileImageKeys.self, forKey: .profileImage)
        profileImage = try profileImageContrainer.decode(URL.self, forKey: .profileImage)
    }
}

struct Photo {
    let id: String
    let createdAt: String
    let urls: [String: URL]
    let width: Int
    let height: Int
    let blurHash: String
    let user: User
}

extension Photo: Decodable {
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
