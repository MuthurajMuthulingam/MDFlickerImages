//
//  MDFlickerImageParser.swift
//  MDFlickerImages
//
//  Created by Muthuraj Muthulingam on 10/05/21.
//

import Foundation

final class MDFlickerImageParser {
    class func parseImages(from data: Data) -> FlickerPhoto?  {
        do {
            let photosInfo = try JSONDecoder().decode(FlickerPhoto.self, from: data)
            return photosInfo
        } catch let error {
            debugPrint("Error: \(error)")
            return nil
        }
    }
}
