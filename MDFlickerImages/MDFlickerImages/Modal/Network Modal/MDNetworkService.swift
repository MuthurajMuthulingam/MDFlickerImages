//
//  FlickerImageNetworkService.swift
//  MDFlickerImages
//
//  Created by Muthuraj Muthulingam on 10/05/21.
//

import Foundation
import MMNetworkManager

/// Class to handle All Network service oriented tasks
final class MDNetworkService {
    private let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2932ade8b209152a7cbb49b631c4f9b6&%20format=json&nojsoncallback=1&safe_search=1&per_page=21&text="
    
    func getFlickerImages(for searchQuery: String, of page: Double, completion: @escaping (Result<FlickerPhoto?, NetworkError>) -> Void) {
        guard searchQuery.isNotEmpty else {
            completion(.failure(.noSearchQuery))
            return }
        let finalUrlString: String = "\(urlString+searchQuery)&page=\(page)"
        guard let url = URL(string: finalUrlString) else { return }
        MMRequest(from: url, params: nil, method: .get, responseType: .json, timeout: 60, headers: nil).execute {response, request in
            guard let data = response.rawData else {
                completion(.failure(.error(response.error)))
                return }
            let flickerInfo:FlickerPhoto? = MDFlickerImageParser.parseImages(from: data)
            completion(.success(flickerInfo))
        }
    }
}

enum NetworkError: Error {
    case noError
    case badURL
    case noSearchQuery
    case error(Error?)
}
