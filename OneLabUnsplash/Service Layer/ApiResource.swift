//
//  ApiResource.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 1/31/21.
//

import Foundation
// MARK: - APIResource Protocol
protocol ApiResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
    var queryItems: [String: String]? { get }
}

extension ApiResource {
    var url: URL {
        var components = URLComponents(string: "https://api.unsplash.com")!
        components.path = methodPath
        if let queryItems = queryItems {
            components.queryItems = []
            for (name, value) in queryItems {
                components.queryItems?.append(URLQueryItem(name: name, value: value))
            }
        }
        return components.url!
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        if let accessKey = getAccessKey() {
            request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    private func getAccessKey() -> String? {
        let url = Bundle.main.url(forResource: "UnsplashKeys", withExtension: "plist")!
        do {
            let data = try Data(contentsOf: url)
            let dict = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String: String]
            return dict["Access Key"]
        } catch {
            print(error)
            return nil
        }
    }
}

protocol PagedResource where Self: ApiResource {
    var page: Int { get }
    mutating func changePageTo(page: Int) -> Int
    mutating func incrementPage(by amount: Int) -> Int
}

// MARK: - TOPICS RESOURCE
struct TopicsResource: ApiResource {
    typealias ModelType = Topic
    static let staticMethodPath = "/topics"
    let methodPath = TopicsResource.staticMethodPath
    var queryItems: [String : String]? = ["order_by": "featured", "per_page": "30"]
}

// MARK: - TOPIC PHOTOS RESOURCE
struct TopicPhotosResource: ApiResource {
    typealias ModelType = Photo
    let methodPath: String
    var queryItems: [String : String]?
    var page: Int

    init(topicSlug: String, page: Int = 0) {
        self.methodPath = "\(TopicsResource.staticMethodPath)/\(topicSlug)/photos"
        self.page = page
        self.queryItems = ["page:" : String(page)]
    }
}
extension TopicPhotosResource: PagedResource {
    mutating func changePageTo(page: Int) -> Int {
        self.page = page
        queryItems!["page"] = String(page)
        return page
    }

    mutating func incrementPage(by amount: Int = 1) -> Int {
        self.page += amount
        queryItems!["page"] = String(page)
        return Int(queryItems!["page"]!)!
    }
}
