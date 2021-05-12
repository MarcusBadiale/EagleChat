//
//  VideoPlayerViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit

final class VideoPlayerViewController: BaseViewController<VideoPlayerView> {

    // MARK: - Private variables
    private let viewModel: VideoPlayerViewModel
    
    // MARK: - Init
    init(viewModel: VideoPlayerViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension VideoPlayerViewController {
    
    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .white
    }
}
