//
//  PhotoViwerView.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import SDWebImage

final class PhotoViwerView: UIView {
    
    // MARK: - Private variables
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
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

extension PhotoViwerView {
    
    //MARK: - Internal methods
    func setImage(imageUrl: URL) {
        imageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        backgroundColor = .black
        
        addSubview(imageView, constraints: true)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
