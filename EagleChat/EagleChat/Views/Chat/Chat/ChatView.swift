//
//  ChatView.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit

final class ChatView: UIView {
    
    // MARK: - Private variables
    
    //MARK: - Internal variables
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupLayout()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatView {
    
    //MARK: - Internal methods
    
    // MARK: - Private methods
    
    private func setupLayout() {
        backgroundColor = .yellow
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
}
