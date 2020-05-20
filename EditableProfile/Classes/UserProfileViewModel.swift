//
//  UserProfileViewModel.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import Foundation

protocol UserProfileViewModel {
    func viewDidLoad()
}

final class UserProfileViewModelImpl: UserProfileViewModel {
    
    weak var view: UserProfileView?
    
    func viewDidLoad() {
        
    }
}
