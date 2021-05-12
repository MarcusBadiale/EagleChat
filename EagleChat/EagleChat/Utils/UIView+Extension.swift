//
//  UIView+Extension.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 11/05/21.
//

import UIKit

public extension UIView {
    
    func addSubview(_ subview: UIView, constraints: Bool) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = !constraints
    }
    
    func addSubviews(_ subviews: [UIView], constraints: Bool) {
        for subview in subviews {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = !constraints
        }
    }
}
