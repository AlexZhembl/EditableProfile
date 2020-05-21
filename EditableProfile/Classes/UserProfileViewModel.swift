//
//  UserProfileViewModel.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import Foundation

protocol UserProfileViewModel {
    func viewDidLoad()
    func profilePictureDidTap()
}

final class UserProfileViewModelImpl: UserProfileViewModel {
    
    weak var view: UserProfileView?
    private let router: UserProfileRouter
    private let attributesAndLocationsFetcher: UserProfileAttributesAndLocationsFetcher
    
    init(router: UserProfileRouter, attributesAndLocationsFetcher: UserProfileAttributesAndLocationsFetcher) {
        self.router = router
        self.attributesAndLocationsFetcher = attributesAndLocationsFetcher
    }
    
    func viewDidLoad() {
        attributesAndLocationsFetcher.fetchAttributes { attr in
            print(attr)
        }
        
        attributesAndLocationsFetcher.fetchLocations { locs in
            print(locs)
        }
        
        let model = UserProfileElementsView.Model(profileImage: nil,
                                                  displayName: (text: nil, placeholder: "Display name"),
                                                  realName: (text: nil, placeholder: "Real name"),
                                                  location: (text: nil, placeholder: "Your location"),
                                                  bDay: (text: nil, placeholder: "Birthday date"),
                                                  gender: (text: nil, placeholder: "Your gender"),
                                                  ethnicity: (text: nil, placeholder: "Ethnicity"),
                                                  religion: (text: nil, placeholder: "Religion"),
                                                  figure: (text: nil, placeholder: "Figure"),
                                                  maritalStatus: (text: nil, placeholder: "Material status"),
                                                  height: (text: nil, placeholder: "Height"),
                                                  occupation: (text: nil, placeholder: "Occupation"),
                                                  aboutMe: (text: nil, placeholder: "About me"),
                                                  doneButtonText: "Save/register")
        view?.setupProfileElements(with: model)
    }
    
    func profilePictureDidTap() {
        router.presentImagePicker { [weak self] image in
            guard let image = image else {
                print("No image choosed")
                return
            }
            
            let model = UserProfileElementsView.Model(profileImage: image,
            displayName: (text: nil, placeholder: "Display name"),
            realName: (text: nil, placeholder: "Real name"),
            location: (text: nil, placeholder: "Your location"),
            bDay: (text: nil, placeholder: "Birthday date"),
            gender: (text: nil, placeholder: "Your gender"),
            ethnicity: (text: nil, placeholder: "Ethnicity"),
            religion: (text: nil, placeholder: "Religion"),
            figure: (text: nil, placeholder: "Figure"),
            maritalStatus: (text: nil, placeholder: "Material status"),
            height: (text: nil, placeholder: "Height"),
            occupation: (text: nil, placeholder: "Occupation"),
            aboutMe: (text: nil, placeholder: "About me"),
            doneButtonText: "Save/register")
            
            self?.view?.setupProfileElements(with: model)
        }
    }
}
