//
//  BaseViewController.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 11/05/21.
//

import UIKit

open class BaseViewController<View: UIView>: UIViewController {
    
    public var customView: View {
        return view as! View
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = View()
    }
}
