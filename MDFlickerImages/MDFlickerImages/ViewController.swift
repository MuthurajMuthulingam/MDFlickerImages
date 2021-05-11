//
//  ViewController.swift
//  MDFlickerImages
//
//  Created by Muthuraj Muthulingam on 09/05/21.
//

import UIKit

final class MDFlickerImagesViewController: UIViewController {
    
    // MARK: - Private Helpers
    private lazy var networkService: MDNetworkService = MDNetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        networkService.getFlickerImages(for: "kittens")
    }
}

