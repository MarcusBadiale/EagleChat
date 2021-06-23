//
//  PhotoViwerViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit

final class PhotoViwerViewController: BaseViewController<PhotoViwerView> {

    // MARK: - Private variables
    private let viewModel: PhotoViwerViewModel
    
    // MARK: - Init
    init(viewModel: PhotoViwerViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension PhotoViwerViewController {
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        customView.setImage(imageUrl: viewModel.imageUrl)
    }
}
