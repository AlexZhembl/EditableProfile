//
//  RootViewModel.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import Foundation

protocol RootViewModel {
    func viewDidLoad()
    func registerDidTap()
    func editProfileDidTap()
}

protocol RootViewModelSettings  {
    var isUserRegistered: Bool { get }
}

final class RootViewModelImpl: RootViewModel {
    
    weak var view: RootView?
    private let settings: RootViewModelSettings
    private let router: RootRouter
    
    init(settings: RootViewModelSettings, router: RootRouter) {
        self.settings = settings
        self.router = router
    }
    
    func viewDidLoad() {
        view?.createButtons(register: RootButtonModel(title: "Register new user", isHidden: false),
                            changeProfile: RootButtonModel(title: "Change existing profile", isHidden: settings.isUserRegistered))
    }
    
    func registerDidTap() {
        
    }
    
    func editProfileDidTap() {
        
    }
}
