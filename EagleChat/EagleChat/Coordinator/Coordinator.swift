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
        
        routeToVc()
    }
}

extension Coordinator {
    
    func routeToVc() {
        let viewModel = ViewModel(coordinator: self)
        let viewController = ViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
