//
//  NetworkRequest.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 1/30/21.
//

import Foundation
protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func fetch(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    fileprivate func fetch(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self?.decode(data))
        }
        task.resume()
    }
    fileprivate func fetch(_ request: URLRequest, withCompletion completion: @escaping (ModelType?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: request) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self?.decode(data))
        }
        task.resume()
    }
}

class ApiRequest<Resource: ApiResource>  {
    let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }
}

extension ApiRequest: NetworkRequest {
    func decode(_ data: Data) -> [Resource.ModelType]? {
        do {
            let topics = try JSONDecoder().decode([Resource.ModelType].self, from: data)
            return topics
        } catch {
            print(error)
            return nil
        }
//        return try? JSONDecoder().decode([Resource.ModelType].self, from: data)
    }

    func fetch(withCompletion completion: @escaping ([Resource.ModelType]?) -> Void) {
        fetch(resource.request, withCompletion: completion)
    }
}

