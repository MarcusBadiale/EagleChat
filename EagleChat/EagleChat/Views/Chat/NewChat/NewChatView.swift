//
//  NewChatView.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import JGProgressHUD

final class NewChatView: UIView {
    
    // MARK: - Private variables
    
    //MARK: - Internal variables
    lazy var spinner = JGProgressHUD(style: .dark)
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.sizeToFit()
        view.placeholder = "Procurar usuarios..."
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.isHidden = true
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

extension NewChatView {
    
    //MARK: - Internal methods
    func showSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.spinner.show(in: self)
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.dismiss()
        }
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        backgroundColor = .white
        
        addSubview(tableView, constraints: true)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
