//
//  RootViewModel.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import Foundation

protocol RootViewModel {
    func viewWillAppear()
    func registerDidTap()
    func editProfileDidTap()
}

final class RootViewModelImpl: RootViewModel {
    
    weak var view: RootView?
    private let userModelProvider: UserModelProvider
    private let router: RootRouter
    
    init(userModelProvider: UserModelProvider, router: RootRouter) {
        self.userModelProvider = userModelProvider
        self.router = router
    }
    
    func viewWillAppear() {
        view?.setupButtons(register: RootButtonModel(title: "Register new user", isHidden: false),
						   changeProfile: RootButtonModel(title: "Change existing profile", isHidden: !userModelProvider.isUserRegistered))
    }
    
    func registerDidTap() {
		userModelProvider.syncUserModel(nil)
        router.presentUserProfileViewController()
    }
    
    func editProfileDidTap() {
        router.presentUserProfileViewController()
    }
}
