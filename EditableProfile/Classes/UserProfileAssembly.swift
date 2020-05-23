//
//  UserProfileAssembly.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import Foundation
import Swinject

class UserProfileAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UserProfileRouter.self) { r in
            UserProfileRouterImpl(imagePicker: container.resolve(ImagePicker.self)!) {
                return container.resolve(UserProfileViewController.self)!
            }
        }
        
        container.register(UserProfileViewModelImpl.self) { r in
            UserProfileViewModelImpl(router: r.resolve(UserProfileRouter.self)!,
                                     attributesAndLocationsFetcher: r.resolve(UserProfileAttributesAndLocationsFetcher.self)!,
									 userModelProvider: r.resolve(UserModelProvider.self)!,
									 modelFabric: r.resolve(UserProfileModelFrabric.self)!)
        }
        
        container.register(UserProfileViewController.self) { r in
            let viewModel = r.resolve(UserProfileViewModelImpl.self)!
            let controller = UserProfileViewController(viewModel: viewModel)
            viewModel.view = controller
            return controller
        }.inObjectScope(.weak)
        
        container.register(ImagePicker.self) { _ in
            ImagePickerImpl()
        }
        
        container.register(UserProfileAttributesAndLocationsFetcher.self) { r in
            UserProfileAttributesAndLocationsFetcherImpl(httpFabric: r.resolve(HTTPFabric.self)!)
        }
		
		container.register(UserModelProvider.self) { r in
			UserModelProviderImpl(settings: r.resolve(SettingsStorage.self)!)
		}
		
		container.register(UserProfileModelFrabric.self) { r in
			UserProfileModelFrabricImpl()
		}
    }
}
