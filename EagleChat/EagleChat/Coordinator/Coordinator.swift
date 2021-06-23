//
//  Coordinator.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 11/05/21.
//

import UIKit

final class Coordinator: NSObject {

    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        window.rootViewController =  navigationController
        window.makeKeyAndVisible()
        
        routeToConversations()
    }
}

extension Coordinator {
    func routeToConversations() {
        let viewModel = ConversationViewModel(coordinator: self)
        let viewController = ConversationViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToLogin() {
        let viewModel = LoginViewModel(coordinator: self)
        let viewController = LoginViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToRegister() {
        let viewModel = RegisterViewModel(coordinator: self)
        let viewController = RegisterViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToChat(chatId: String, userName: String, userEmail: String, isNewConversation: Bool) {
        let viewModel = ChatViewModel(coordinator: self, chatId: chatId,
                                      userName: userName, userEmail: userEmail,
                                      newConversation: isNewConversation)
        let viewController = ChatViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToProfile() {
        let viewModel = ProfileViewModel(coordinator: self)
        let viewController = ProfileViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToNewChat(delegate: NewChatDelegate) {
        let viewModel = NewChatViewModel(coordinator: self)
        let viewController = NewChatViewController(viewModel: viewModel)
        viewController.delegate = delegate
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToPhotoViwer(imageUrl: URL) {
        let viewModel = PhotoViwerViewModel(coordinator: self, url: imageUrl)
        let viewController = PhotoViwerViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
