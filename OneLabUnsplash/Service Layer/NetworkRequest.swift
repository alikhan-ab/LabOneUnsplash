//
//  NetworkRequest.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 1/30/21.
//

import Foundation
protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) throws -> ModelType
    func fetch(successCompletion: @escaping (ModelType, HTTPURLResponse) -> Void, errorCompletion: @escaping (DataResponseError) -> Void)
}

extension NetworkRequest {
    fileprivate func fetch(_ url: URL, completion: @escaping (ModelType, HTTPURLResponse) -> Void, errorCompletion: @escaping (DataResponseError) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let self = self else { return }
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                errorCompletion(DataResponseError.networkError)
                return
            }
            do {
                let decodedData = try self.decode(data)
                completion(decodedData, response)
            } catch {
                errorCompletion(DataResponseError.decodeError)
            }
        }
        task.resume()
    }
    fileprivate func fetch(_ request: URLRequest, completion: @escaping (ModelType, HTTPURLResponse) -> Void, errorCompletion: @escaping (DataResponseError) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: request) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let self = self else { return }
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                errorCompletion(DataResponseError.networkError)
                return
            }
            do {
//                print(String(data: data, encoding: .utf8) ?? "Cant convert to string")
                let decodedData = try self.decode(data)
                completion(decodedData, response)
            } catch {
                print(error.localizedDescription)
                errorCompletion(DataResponseError.decodeError)
            }
        }
        task.resume()
    }
}

class ApiRequest<Resource: ApiResource>  {
    var resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }
}

extension ApiRequest: NetworkRequest {
    func decode(_ data: Data) throws -> [Resource.ModelType] {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode([Resource.ModelType].self, from: data)
    }

    func fetch(successCompletion: @escaping (Array<Resource.ModelType>, HTTPURLResponse) -> Void, errorCompletion: @escaping (DataResponseError) -> Void) {
        fetch(resource.request, completion: successCompletion, errorCompletion: errorCompletion)
    }
}
