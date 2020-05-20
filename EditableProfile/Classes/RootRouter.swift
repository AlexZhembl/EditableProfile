//
//  RootRouter.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import UIKit

protocol RootRouter {
    func presentUserProfileViewController()
}

final class RootRouterImpl: RootRouter {
    
    private let presentingController: () -> UIViewController
    
    init(presentingController: @escaping () -> UIViewController) {
        self.presentingController = presentingController
    }
    
    func presentUserProfileViewController() {
       
    }
}
