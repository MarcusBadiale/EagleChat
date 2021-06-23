//
//  ConversationViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import UIKit

final class ConversationViewController: BaseViewController<ConversationView> {

    // MARK: - Private variables
    private let viewModel: ConversationViewModel
    
    // MARK: - Init
    init(viewModel: ConversationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.validadeAuth()
    }
}

extension ConversationViewController {
    
    // MARK: - Private methods
    private func setup() {
        title = "Conversas"
        
        addNavButtons()
        makeNavigationTranslucent()
        fetchConversations()
        setupTableView()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func makeNavigationTranslucent() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1529260874, green: 0.1529496312, blue: 0.1529181004, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
    }
    
    private func addNavButtons() {
        let customRightBarButton = UIBarButtonItem(barButtonSystemItem: .compose,
                                             target: self,
                                             action: #selector(didTapComposeButton))
        
        let customLeftBarButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(didTapProfileBtn))
        navigationItem.rightBarButtonItem = customRightBarButton
        navigationItem.leftBarButtonItem = customLeftBarButton
        
    }
    
    private func showErrorOverlay() {
        DispatchQueue.main.async {
            ErrorOverlay.shared.showOverlay(view: self.customView.tableView,
                                            errorImage: UIImage(systemName: "xmark.octagon") ?? UIImage(),
                                            message: "Algo deu errado! \nTente novamente")
        }
    }
    
    private func fetchConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.shared.safeEmail(emailAddress: email)
        DatabaseManager.shared.getAllConversations(for: safeEmail) { [weak self] result in
            switch result {
            case let .success(conversations):
                guard !conversations.isEmpty else {
                    return
                }
                self?.viewModel.conversations = conversations
                DispatchQueue.main.async {
                    self?.customView.tableView.reloadData()
                }
                
            case let .failure(error):
                print("Falhou em pegar conversas: ", error)
            }
        }
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.id,
                                                       for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(with: viewModel.conversations[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.conversations[indexPath.row]
        viewModel.goToChat(chatId: model.id,
                           userName: model.name,
                           userEmail: model.otherUserEmail,
                           isNewConversation: false)
    }
}

// MARK: - Actions
extension ConversationViewController {
    @objc
    func didTapProfileBtn() {
        viewModel.goToProfile()
    }
    
    @objc
    func didTapComposeButton() {
        viewModel.goToNewChat()
    }
}
