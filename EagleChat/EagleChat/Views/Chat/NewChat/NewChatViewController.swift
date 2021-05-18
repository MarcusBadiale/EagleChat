//
//  NewChatViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit

public protocol NewChatDelegate: AnyObject {
    func completion(result:[String:String])
}

final class NewChatViewController: BaseViewController<NewChatView> {

    // MARK: - Private variables
    private let viewModel: NewChatViewModel
    
    weak var delegate: NewChatDelegate?
    
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
        setupTableView()
    }
    
    private func addSearchBarDelegate() {
        customView.searchBar.delegate = self
    }
    
    private func setupTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
    }
}

extension NewChatViewController {
    @objc
    func didTapCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.filteredUsers[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Start Conversation
        self.navigationController?.popViewController(animated: false)
        delegate?.completion(result: viewModel.filteredUsers[indexPath.row])
    }
}

extension NewChatViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
              !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        viewModel.filteredUsers.removeAll()
        customView.showSpinner()
        searchBar.resignFirstResponder()
        
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        if viewModel.hasFetched {
            // filter
            filterUsers(with: query)
        } else {
            // fetch
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result {
                case let .success(users):
                    self?.viewModel.users = users
                    self?.customView.hideSpinner()
                    self?.viewModel.hasFetched = true
                    self?.filterUsers(with: query)
                    
                case let .failure(error):
                    print("Failed to get users: ", error)
                }
            }
        }
    }
    
    func filterUsers(with term: String) {
        guard viewModel.hasFetched else {
            return
        }
        
        let results: [[String:String]] = viewModel.users.filter {
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        }
        
        viewModel.filteredUsers = results
        
        updateUI()
    }
    
    func updateUI() {
        if viewModel.filteredUsers.isEmpty {
            customView.tableView.isHidden = true
            customView.tableView.reloadData()
        } else {
            customView.tableView.isHidden = false
            customView.tableView.reloadData()
        }
    }
}
