//
//  ConversationTableViewCell.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 26/05/21.
//

import UIKit
import SDWebImage

final class ConversationTableViewCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    //MARK: - Private variables
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3669571579, green: 0.2636830509, blue: 0.3215260208, alpha: 1)
        return view
    }()
    
    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = K.imageWidth / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()

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

extension ConversationTableViewCell {
    
    //MARK: - Internal methods
    func setupCell(with model: Conversation) {
        userNameLabel.text = model.name
        userMessageLabel.text = model.latestMessage.text
        
        let path = "images/\(model.otherUserEmail)_profile_picture.png"
        StorageManager.shared.donwloadURL(for: path) { [weak self] result in
            switch result {
            case let .success(url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
                
            case let .failure(error):
                print("Falhou em pegar imagem:", error)
            }
        }
    }
    
    // MARK: - Private methods
    private func setupDefaultCell() {
    }
    
    private func setupLayout() {
        backgroundColor = #colorLiteral(red: 0.1529260874, green: 0.1529496312, blue: 0.1529181004, alpha: 1)
        
        addSubview(containerView, constraints: true)
        containerView.addSubviews([userImageView, userNameLabel, userMessageLabel], constraints: true)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor
                .constraint(equalTo: topAnchor, constant: 16),
            containerView.bottomAnchor
                .constraint(equalTo: bottomAnchor, constant: -16),
            containerView.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -16),
            
            userImageView.topAnchor
                .constraint(equalTo: containerView.topAnchor, constant: 16),
            userImageView.bottomAnchor
                .constraint(equalTo: containerView.bottomAnchor, constant: -16),
            userImageView.leadingAnchor
                .constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userImageView.widthAnchor
                .constraint(equalToConstant: K.imageWidth),
            userImageView.heightAnchor
                .constraint(equalToConstant: K.imageWidth),
            
            userNameLabel.topAnchor
                .constraint(equalTo: userImageView.topAnchor),
            userNameLabel.leadingAnchor
                .constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor
                .constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            
            userMessageLabel.topAnchor
                .constraint(greaterThanOrEqualTo: userNameLabel.topAnchor, constant: 4),
            userMessageLabel.leadingAnchor
                .constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userMessageLabel.trailingAnchor
                .constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            userMessageLabel.bottomAnchor
                .constraint(equalTo: userImageView.bottomAnchor),
        ])
    }
}

extension ConversationTableViewCell {
    enum K {
        static let imageWidth:CGFloat = 50
    }
}
