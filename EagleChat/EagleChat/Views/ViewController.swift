//
//  ViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 11/05/21.
//

import UIKit

final class ViewController: BaseViewController<UIView> {

    // MARK: - Private variables
    private let viewModel: ViewModel
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension ViewController {
    
    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .red
    }
}
