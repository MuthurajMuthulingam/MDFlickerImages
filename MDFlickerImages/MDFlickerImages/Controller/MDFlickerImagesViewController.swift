//
//  ViewController.swift
//  MDFlickerImages
//
//  Created by Muthuraj Muthulingam on 09/05/21.
//

import UIKit

final class MDFlickerImagesViewController: UIViewController {
    
    // MARK - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Private Helpers
    private lazy var networkService: MDNetworkService = MDNetworkService()
    private lazy var imageInfo: FlickerPhoto? = nil
    private lazy var currentPage: Int = 0
    private lazy var currentSearchQuery: String = ""
    private lazy var isLoadingData: Bool = false
    private var photos: [ImageInfo] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Life cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performImageSearchIfNeeded()
    }
}

private typealias PrivateHelpers = MDFlickerImagesViewController
private extension PrivateHelpers {
    
    func performImageSearchIfNeeded() {
        guard let searchText = searchBar.text, searchText.isNotEmpty else {
            resetView()
            return
        }
        if currentSearchQuery == searchText {
            currentPage += 1
        } else {
            currentPage = 1 // reset
        }
        fetchFlickerImages(for: searchText, of: currentPage)
    }
    
    func resetView() {
        imageInfo = nil
        photos = [] // this reload the view
    }
    
    func fetchFlickerImages(for query: String, of page: Int) {
        func handleSuccess(with flickerInfo: FlickerPhoto) {
            imageInfo = flickerInfo
            photos = flickerInfo.photos?.photo ?? []
        }
        func handleFailure(using error: NetworkError) {
            
        }
        networkService.getFlickerImages(for: query, of: page) {[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingData = false
                switch result {
                case let .success(flickerPhoto):
                    guard let flickerPhoto = flickerPhoto else { return }
                    handleSuccess(with: flickerPhoto)
                case let .failure(error):
                    handleFailure(using: error)
                }
            }
        }
    }
}

private typealias SearchBarDelegate = MDFlickerImagesViewController
extension SearchBarDelegate: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // perform search
        performImageSearchIfNeeded()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // clear the results
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // search text changes
    }
}

private typealias CollectionViewHelpers = MDFlickerImagesViewController
extension CollectionViewHelpers: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
    // Cllection view datasource and Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MDImageCollectionViewCell.self), for: indexPath)
        if let imageCell = cell as? MDImageCollectionViewCell {
            imageCell.updateViewWithData(photos[indexPath.item])
        }
        return cell
    }
    
    // Flow Layout delegates
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewItemHeight: CGFloat = collectionView.frame.size.width/3 - 10
        return CGSize(width: collectionViewItemHeight, height: collectionViewItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    // Scrollview Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isLoadingData {
                isLoadingData = true
                performImageSearchIfNeeded()
            }
        }
    }
}

