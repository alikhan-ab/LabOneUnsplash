//
//  APIService.swift
//  OneLabUnsplash
//
//  Created by Alikhan Abutalipov on 2/13/21.
//

import Foundation
protocol APIService {
    func fetchTopics(success: @escaping ([Topic], HTTPURLResponse) -> Void,
                     failure: @escaping (DataResponseError) -> Void)
    func fetchPhotos(for topic: Topic, page: Int,
                     success: @escaping ([Photo], HTTPURLResponse) -> Void,
                     failure: @escaping (DataResponseError) -> Void)
    func fetchPhotoOfTheDay(success: @escaping (Photo, HTTPURLResponse) -> Void,
                            failure: @escaping (DataResponseError) -> Void)
}

final class APIServiceImpl {
    let topicRequest: ApiRequest = ApiRequest(resource: TopicsResource())
    let photoOfTheDayRequest: ApiRequest = ApiRequest(resource: PhotoOfTheDayResource())
    var topicPhotosRequests: [String: ApiRequest<TopicPhotosResource>] = [:]

}

extension APIServiceImpl: APIService {
    func fetchTopics(success: @escaping ([Topic], HTTPURLResponse) -> Void, failure: @escaping (DataResponseError) -> Void) {
        topicRequest.fetch(successCompletion: success, errorCompletion: failure)
    }

    func fetchPhotos(for topic: Topic, page: Int, success: @escaping ([Photo], HTTPURLResponse) -> Void, failure: @escaping (DataResponseError) -> Void) {
        if topicPhotosRequests[topic.slug] == nil {
            topicPhotosRequests[topic.slug] = ApiRequest(resource: TopicPhotosResource(topicSlug: topic.slug, page: 1))
        }
        let request = topicPhotosRequests[topic.slug]!
        _ = request.resource.changePageTo(page: page)
        request.fetch(successCompletion: success, errorCompletion: failure)
    }

    func fetchPhotoOfTheDay(success: @escaping (Photo, HTTPURLResponse) -> Void, failure: @escaping (DataResponseError) -> Void) {
        photoOfTheDayRequest.fetch(successCompletion: { (photos, response) in
            if let photo = photos.first {
                success(photo, response)
            } else {
                failure(DataResponseError.decodeError)
            }
        }, errorCompletion: failure)
    }
}
