//
//  UserProfileViewModel.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/20/20.
//

import Foundation

protocol UserProfileViewModel {
    func viewDidLoad()
	func didInteractElement(_ element: UserProfileElementsView.Element, value: String?)
	func singleChoicePickerDidSelect(_ choice: SingleChoicePickerViewChoicable, for element: UserProfileElementsView.Element)
}

final class UserProfileViewModelImpl: UserProfileViewModel {
	typealias Element = UserProfileElementsView.Element
	
    private let router: UserProfileRouter
    private let attributesAndLocationsFetcher: UserProfileAttributesAndLocationsFetcher
	private let userModelProvider: UserModelProvider
	private let elementsValidator: UserProfileElementsValidator
	weak var view: UserProfileView?
	  
	private var attributes: UserProfileAttributesResponse?
	private var locations: UserProfileLocationsResponse?
	private var viewElements: Set<Element> = []
	private lazy var bDayFormatter: DateFormatter = {
		let formatter = DateFormatter()
		return formatter
	}()
    
	init(router: UserProfileRouter,
		 attributesAndLocationsFetcher: UserProfileAttributesAndLocationsFetcher,
		 userModelProvider: UserModelProvider,
		 elementsValidator: UserProfileElementsValidator) {
        self.router = router
        self.attributesAndLocationsFetcher = attributesAndLocationsFetcher
		self.userModelProvider = userModelProvider
		self.elementsValidator = elementsValidator
    }
    
    func viewDidLoad() {
        attributesAndLocationsFetcher.fetchAttributes { [weak self] attributes in
			self?.attributes = attributes
        }
        
        attributesAndLocationsFetcher.fetchLocations { [weak self] locations in
			self?.locations = locations
        }
		
		let model = userModelProvider.fetchUserModel()
	
		viewElements = [.profileImage(model?.picture),
						.displayName((text: model?.displayName, placeholder: "Display name")),
						.realName((text: model?.realName, placeholder: "Real name")),
						.location((loc: model?.location, placeholder: "Your location")),
						.bDay((date: model?.bDay, placeholder: "Birthday date")),
						.gender((attr: model?.gender, placeholder: "Your gender")),
						.ethnicity((attr: model?.ethnicity, placeholder: "Ethnicity")),
						.religion((attr: model?.religion, placeholder: "Religion")),
						.figure((attr: model?.figure, placeholder: "Figure")),
						.maritalStatus((attr: model?.maritalStatus, placeholder: "Material status")),
						.height((text: model?.height, placeholder: "Height"), isEnabled: true),
						.occupation((text: model?.occupation, placeholder: "Occupation")),
						.aboutMe((text: model?.aboutMe, placeholder: "About me")),
						.doneButton((text: "Save/register", placeholder: ""))]
		view?.updateElementsView(with: Array(viewElements))
    }
	
	func didInteractElement(_ element: Element, value: String?) {
		var updElement: Element?
		switch element {
		case .profileImage:
			router.presentImagePicker { [weak self] image in
				guard let image = image else {
					print("No image choosed")
					return
				}
				
				let updated = Element.profileImage(image)
				self?.viewElements.update(with: updated)
				self?.view?.updateElementsView(with: [updated])
			}
		case .displayName:
			updElement = .displayName((value, nil))
		case .realName:
			updElement = .realName((value, nil))
		case .location:
			guard let query = value else {
				return
			}
			let realQuey = query.trimmingCharacters(in: .whitespacesAndNewlines)
			let filtered = realQuey.count == 0 ?
				locations?.cities : locations?.cities.filter { $0.city.starts(with: query) }
			viewElements.update(with: element)
			view?.showSingleChoicePicker(for: element, with: filtered ?? [])
		case .bDay:
				// show single picker for date ?
				break
		case .gender:
			view?.showSingleChoicePicker(for: element, with: attributes?.gender ?? [])
		case .ethnicity:
			view?.showSingleChoicePicker(for: element, with: attributes?.ethnicity ?? [])
		case .religion:
			view?.showSingleChoicePicker(for: element, with: attributes?.religion ?? [])
		case .figure:
			view?.showSingleChoicePicker(for: element, with: attributes?.figure ?? [])
		case .maritalStatus:
			view?.showSingleChoicePicker(for: element, with: attributes?.maritalStatus ?? [])
		case .height(_, let isEnabled):
			updElement = .height((value, nil), isEnabled: isEnabled)
		case .occupation:
			updElement = .occupation((value, nil))
		case .aboutMe:
			updElement = .aboutMe((value, nil))
		case .doneButton:
			viewElements.forEach { el in
				if !elementsValidator.isElementValid(el) {
					view?.showError(for: el, error: elementsValidator.error(for: el))
				}
			}
		}
		
		if let upd = updElement {
			viewElements.update(with: upd)
		}
	}
	
	func singleChoicePickerDidSelect(_ choice: SingleChoicePickerViewChoicable, for element: Element) {
		view?.dismissSinglePicker()
		
		let updatedElement: Element
		switch element {
		case .ethnicity:
			let ethnicity = attributes?.ethnicity.first(where: { $0.uid == choice.uid })
			updatedElement = .ethnicity((attr: ethnicity, placeholder: nil))
		case .gender:
			let gender = attributes?.gender.first(where: { $0.uid == choice.uid })
			updatedElement = .gender((attr: gender, placeholder: nil))
		case .religion:
			let religion = attributes?.religion.first(where: { $0.uid == choice.uid })
			updatedElement = .religion((attr: religion, placeholder: nil))
		case .figure:
			let figure = attributes?.figure.first(where: { $0.uid == choice.uid })
			updatedElement = .figure((attr: figure, placeholder: nil))
		case .maritalStatus:
			let maritalStatus = attributes?.maritalStatus.first(where: { $0.uid == choice.uid })
			updatedElement = .maritalStatus((attr: maritalStatus, placeholder: nil))
		case .location:
			let city = locations?.cities.first(where: { $0.uid == choice.uid })
			updatedElement = .location((loc: city, placeholder: nil))
		default:
			assertionFailure("Could not find atribute for choisable")
			return
		}
		
		viewElements.update(with: updatedElement)
		view?.updateElementsView(with: [updatedElement])
	}
}

extension UserLocation: SingleChoicePickerViewChoicable {
	var title: String { city }
	var uid: String { lat + lon }
}

extension UserAttribute: SingleChoicePickerViewChoicable {
	var title: String { name }
}

// MARK: - I just want to store my elements in Set, so I need Hashable -> RawRepresentable

extension UserProfileElementsView.Element: RawRepresentable, Hashable {
	typealias RawValue = Int
	
	var rawValue: RawValue {
		switch self {
		case .profileImage: return 1
		case .displayName: return 2
		case .realName: return 3
		case .location: return 4
		case .bDay: return 5
		case .gender: return 6
		case .ethnicity: return 7
		case .religion: return 8
		case .figure: return 9
		case .maritalStatus: return 10
		case .height: return 11
		case .occupation: return 12
		case .aboutMe: return 13
		case .doneButton: return 14
		}
	}
	
	init?(rawValue: RawValue) {
		return nil
	}
	
	static func == (lhs: UserProfileElementsView.Element, rhs: UserProfileElementsView.Element) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
