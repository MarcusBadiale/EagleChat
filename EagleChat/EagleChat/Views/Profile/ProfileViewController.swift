//
//  ProfileViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

final class ProfileViewController: BaseViewController<ProfileView> {

    // MARK: - Private variables
    private let viewModel: ProfileViewModel
    
    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ProfileViewController {
    
    // MARK: - Private methods
    private func setup() {
        title = "Perfil"
        
        setupTableView()
    }
    
    private func setupTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Google Log out
        GIDSignIn.sharedInstance().signOut()
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            viewModel.goToLogin()
        }
        catch {
            print("Failed to log out")
        }
    }
}
