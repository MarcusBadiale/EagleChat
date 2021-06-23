//
//  ConversationView.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import JGProgressHUD

final class ConversationView: UIView {
    
    // MARK: - Private variables
    
    //MARK: - Internal variables
    lazy var spinner = JGProgressHUD(style: .dark)
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.id)
        view.backgroundColor = #colorLiteral(red: 0.1529260874, green: 0.1529496312, blue: 0.1529181004, alpha: 1)
        view.separatorStyle = .none
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

extension ConversationView {
    
    //MARK: - Internal methods
    
    // MARK: - Private methods
    
    private func setupLayout() {
        backgroundColor = #colorLiteral(red: 0.1529260874, green: 0.1529496312, blue: 0.1529181004, alpha: 1)
        
        addSubview(tableView, constraints: true)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor
                .constraint(equalTo: topAnchor),
            tableView.leadingAnchor
                .constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor
                .constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor
                .constraint(equalTo: bottomAnchor),
        ])
    }
}
