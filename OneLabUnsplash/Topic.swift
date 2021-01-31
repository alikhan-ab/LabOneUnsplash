//
//  Topic.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 1/31/21.
//

import Foundation
struct Topic {
    let slug: String
    let title: String
    let photosURL: URL
}

extension Topic: Decodable {
    enum CodingKeys: String, CodingKey {
        case slug
        case title
        case links

        enum LinksKeys: String, CodingKey {
            case photosURL = "photos"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        slug = try container.decode(String.self, forKey: .slug)
        title = try container.decode(String.self, forKey: .title)

        let linksContainer = try container.nestedContainer(keyedBy: CodingKeys.LinksKeys.self, forKey: .links)
        photosURL = try linksContainer.decode(URL.self, forKey: .photosURL)
    }
}
