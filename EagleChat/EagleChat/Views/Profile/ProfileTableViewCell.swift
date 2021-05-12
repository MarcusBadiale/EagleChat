//
//  ProfileTableViewCell.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    //MARK: - Private variables

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileTableViewCell {
    
    //MARK: - Internal methods
    func setupCell() {
    }
    
    // MARK: - Private methods
    private func setupDefaultCell() {
    }
    
    private func setupLayout() {
        backgroundColor = .white
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
}
