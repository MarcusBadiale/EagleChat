//
//  PhotoViwerViewModel.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 12/05/21.
//

import Foundation

final class PhotoViwerViewModel {
    
    // MARK: - Private variables
    private let coordinator: Coordinator
    
    var imageUrl: URL
    
    // MARK: - Init
    init(coordinator: Coordinator, url: URL) {
        self.coordinator = coordinator
        self.imageUrl = url
    }
}
