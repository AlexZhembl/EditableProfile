//
//  RootAssembly.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import Foundation
import Swinject

class RootAssembly: Assembly {

    func assemble(container: Container) {
        container.register(RootRouter.self) { r in
            RootRouterImpl() {
                return container.resolve(RootViewController.self)!
            }
        }
        
        container.register(RootViewModelImpl.self) { r in
            RootViewModelImpl(settings: r.resolve(SettingsStorage.self)!, router: r.resolve(RootRouter.self)!)
        }
        
        container.register(RootViewController.self) { r in
            let viewModel = r.resolve(RootViewModelImpl.self)!
            let controller = RootViewController(viewModel: viewModel)
            viewModel.view = controller
            return controller
        }.inObjectScope(.weak)
    }
}
