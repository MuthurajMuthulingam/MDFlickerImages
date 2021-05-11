//
//  MDImageCollectionViewCell.swift
//  MDFlickerImages
//
//  Created by Muthuraj Muthulingam on 10/05/21.
//

import UIKit
import MMNetworkManager

final class MDImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private var flickerImage: UIImageView!
    
    private var currentIndexPath: IndexPath = IndexPath()
    
    // MARK: - Life cycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        flickerImage.image = #imageLiteral(resourceName: "placeholder")
    }
}

private typealias PrivateHelpers = MDImageCollectionViewCell
extension PrivateHelpers {
    func fetchImage(from urlString: String) {
        func updateView(with image: UIImage) {
            DispatchQueue.main.async {
                self.flickerImage.image = image
            }
        }
        // fetch the image if already present in cache
        if let image = MDImageCache.shared.image(for: urlString) {
            debugPrint("loading from cache: \(urlString)")
            updateView(with: image)
        } else { // image not present in cache, so download and cache
            debugPrint("loading from Remote: \(urlString)")
            guard let url = URL(string: urlString) else {
                return
            }
            MMNetworkResource(rawData: nil, formattedData: nil, type: .image, url: url, error: nil).execute { downloadedResource in
                guard let image = downloadedResource.formattedData as? UIImage else {
                    return
                }
                let downloadedImageURLString = downloadedResource.url.absoluteString
                MDImageCache.shared.storeImage(image, for: downloadedImageURLString)
                if urlString == downloadedImageURLString {
                   updateView(with: image)
                }
            }
        }
    }
}

private typealias PublicHelpers = MDImageCollectionViewCell
extension PublicHelpers {
    func updateViewWithData(_ imageData: ImageInfo) {
        fetchImage(from: imageData.imageUrlString)
    }
}

// MARK: -  Class to cache the instances of images
private final class MDImageCache {
    static let shared: MDImageCache = MDImageCache()
    
    // MARK: - Private Helpers
    private let sharedCache: NSCache = NSCache<NSString, UIImage>()
    
    private init() {} // to avoid getting called by external classes
    
    // MARK: - Public Helpers
    func storeImage(_ image: UIImage, for key: String) {
        sharedCache.setObject(image, forKey: key as NSString)
    }
    
    func image(for key: String) -> UIImage? {
        sharedCache.object(forKey: key as NSString)
    }
}
