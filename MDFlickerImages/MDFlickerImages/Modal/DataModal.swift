//
//  DataModal.swift
//  MDFlickerImages
//
//  Created by Muthuraj Muthulingam on 10/05/21.
//

import Foundation

struct FlickerPhoto: Codable {
    let photos: FlickerPhotoInfo?
    let stat: String
}

struct FlickerPhotoInfo: Codable {
    let page: Int?
    let pages: Double?
    let perpage: Double?
    let total: Double?
    let photo: [ImageInfo]
}

struct ImageInfo: Codable {
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
}

extension ImageInfo {
    var imageUrlString: String {
        guard let farm = farm,
              let server = server,
              let id = id,
              let secret = secret else {
            return "" // no url String can be formed
        }
        return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

/*
 https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2932ade8b209152a7cbb49b631c4f9b6&%20format=json&nojsoncallback=1&safe_search=1&text=kittens
 */
