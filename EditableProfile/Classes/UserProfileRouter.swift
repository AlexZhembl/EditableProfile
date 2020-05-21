//
//  UserProfileRouter.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import UIKit

protocol UserProfileRouter {
    func presentImagePicker(with completion: @escaping (UIImage?) -> Void)
}

final class UserProfileRouterImpl: UserProfileRouter {
    
    private let presentingController: () -> UIViewController?
    private let imagePicker: ImagePicker
    
    init(imagePicker: ImagePicker, presentingController: @escaping () -> UIViewController?) {
        self.presentingController = presentingController
        self.imagePicker = imagePicker
    }
    
    func presentImagePicker(with completion: @escaping (UIImage?) -> Void) {
        guard let presentingController = presentingController() else {
            print("could not find controller")
            return
        }
        
        imagePicker.showPicker(from: presentingController, completion: completion)
    }
}
