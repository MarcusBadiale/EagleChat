//
//  ProfileView.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit

final class ProfileView: UIView {
    
    // MARK: - Private variables
    
    //MARK: - Internal variables
    lazy var userImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle.fill")
        view.backgroundColor = .white
        view.tintColor = .gray
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = K.buttonWidth / 2
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    lazy var userName: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "Marcao"
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
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

extension ProfileView {
    
    //MARK: - Internal methods
    
    // MARK: - Private methods
    
    private func setupLayout() {
        backgroundColor = .white
        
        addSubviews([userImage, userName, tableView], constraints: true)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            userImage.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            userImage.widthAnchor
                .constraint(equalToConstant: K.buttonWidth),
            userImage.heightAnchor
                .constraint(equalToConstant: K.buttonWidth),
            userImage.centerXAnchor
                .constraint(equalTo: centerXAnchor),
            
            userName.topAnchor
                .constraint(equalTo: userImage.bottomAnchor, constant: 10),
            userName.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            userName.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            tableView.topAnchor
                .constraint(equalTo: userName.bottomAnchor, constant: 20),
            tableView.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ProfileView {
    enum K {
        static let buttonWidth:CGFloat = 100
    }
}
