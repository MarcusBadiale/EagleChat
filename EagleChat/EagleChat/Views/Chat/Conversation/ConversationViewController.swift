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
        view.backgroundColor = .white
        
        addNavButtons()
        fetchConversations()
        setupTableView()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
    }
    
    private func addNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapProfileBtn))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
    }
    
    private func showErrorOverlay() {
        DispatchQueue.main.async {
            ErrorOverlay.shared.showOverlay(view: self.customView.tableView,
                                            errorImage: UIImage(systemName: "xmark.octagon") ?? UIImage(),
                                            message: "Algo deu errado! \nTente novamente")
        }
    }
    
    private func fetchConversations() {
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Teste"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.goToChat(user: [:], isNewConversation: false)
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
