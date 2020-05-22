//
//  UserProfileViewModel.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import Foundation

protocol UserProfileViewModel {
    func viewDidLoad()
	func didInteractElement(_ element: UserProfileElementsView.Element)
	func singleChoicePickerDidSelect(_ choice: SingleChoicePickerViewChoicable, for element: UserProfileElementsView.Element)
}

final class UserProfileViewModelImpl: UserProfileViewModel {
	typealias Element = UserProfileElementsView.Element
	
    weak var view: UserProfileView?
    private let router: UserProfileRouter
    private let attributesAndLocationsFetcher: UserProfileAttributesAndLocationsFetcher
	
	private var attributes: UserProfileAttributesResponse?
    
    init(router: UserProfileRouter, attributesAndLocationsFetcher: UserProfileAttributesAndLocationsFetcher) {
        self.router = router
        self.attributesAndLocationsFetcher = attributesAndLocationsFetcher
    }
    
    func viewDidLoad() {
        attributesAndLocationsFetcher.fetchAttributes { [weak self] attributes in
			self?.attributes = attributes
        }
        
        attributesAndLocationsFetcher.fetchLocations { locs in
            print(locs)
        }
		let content: [Element] = [.profileImage(nil),
								  .displayName((text: nil, placeholder: "Display name")),
								  .realName((text: nil, placeholder: "Real name")),
								  .location((text: nil, placeholder: "Your location")),
								  .bDay((text: nil, placeholder: "Birthday date")),
								  .gender((text: nil, placeholder: "Your gender")),
								  .ethnicity((text: nil, placeholder: "Ethnicity")),
								  .religion((text: nil, placeholder: "Religion")),
								  .figure((text: nil, placeholder: "Figure")),
								  .maritalStatus((text: nil, placeholder: "Material status")),
								  .height((text: nil, placeholder: "Height"), isEnabled: true),
								  .occupation((text: nil, placeholder: "Occupation")),
								  .aboutMe((text: nil, placeholder: "About me")),
								  .doneButton((text: "Save/register", placeholder: ""))]
		view?.updateElementsView(with: content)
    }
	
	func didInteractElement(_ element: Element) {
		switch element {
		case .profileImage:
			router.presentImagePicker { [weak self] image in
				guard let image = image else {
					print("No image choosed")
					return
				}

				self?.view?.updateElementsView(with: [.profileImage(image)])
			}
		case .ethnicity(let content): view?.showSingleChoicePicker(for: .ethnicity(content), with: attributes?.ethnicity ?? [])
		case .gender(let content): view?.showSingleChoicePicker(for: .gender(content), with: attributes?.gender ?? [])
		case .religion(let content): view?.showSingleChoicePicker(for: .religion(content), with: attributes?.religion ?? [])
		case .figure(let content): view?.showSingleChoicePicker(for: .figure(content), with: attributes?.figure ?? [])
		case .maritalStatus(let content): view?.showSingleChoicePicker(for: .maritalStatus(content), with: attributes?.maritalStatus ?? [])
		default:
			break
		}
	}
	
	func singleChoicePickerDidSelect(_ choice: SingleChoicePickerViewChoicable, for element: Element) {
		//let updatedElement = element.update(choice.title)
		view?.updateElementsView(with: [])
		view?.dismissSinglePicker()
	}
}

extension UserProfileAttributesResponse.Attribute: SingleChoicePickerViewChoicable {
	var title: String { name }
}
