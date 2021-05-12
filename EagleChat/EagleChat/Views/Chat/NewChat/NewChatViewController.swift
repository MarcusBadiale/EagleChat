//
//  NewChatViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit

final class NewChatViewController: BaseViewController<NewChatView> {

    // MARK: - Private variables
    private let viewModel: NewChatViewModel
    
    // MARK: - Init
    init(viewModel: NewChatViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension NewChatViewController {
    
    // MARK: - Private methods
    private func setup() {
        addSearchBarDelegate()
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.titleView = customView.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancelar",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapCancelButton))
        customView.searchBar.becomeFirstResponder()
    }
    
    private func addSearchBarDelegate() {
        customView.searchBar.delegate = self
    }
}

extension NewChatViewController {
    @objc
    func didTapCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewChatViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // todo
    }
}
