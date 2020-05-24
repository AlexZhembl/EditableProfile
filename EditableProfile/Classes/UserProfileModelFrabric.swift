//
//  UserProfileModelFrabric.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/23/20.
//

import Foundation

protocol UserProfileModelFrabric {
	func isElementValid(_ element: UserProfileElementsView.Element) -> Bool
	func error(for element: UserProfileElementsView.Element) -> String
	func createModel(from elements: Set<UserProfileElementsView.Element>) throws -> UserModel
}

final class UserProfileModelFrabricImpl: UserProfileModelFrabric {
	
	func isElementValid(_ element: UserProfileElementsView.Element) -> Bool {
		return element.validate()
	}
	
	func error(for element: UserProfileElementsView.Element) -> String {
		return element.errorString
	}
	
	func createModel(from elements: Set<UserProfileElementsView.Element>) throws -> UserModel {
		let mandatory = UserProfileElementsView.Element.mandatory
		guard mandatory.isSubset(of: elements) else {
			throw NSError(domain: "", code: -1, userInfo: ["reason": "Elements array not contains mandatory fields"])
		}
		guard elements.first(where: { !$0.validate() }) == nil else {
			throw NSError(domain: "", code: -1, userInfo: ["reason": "Some of elements are invalid"])
		}

		return UserModel(elements: elements)
	}
}

fileprivate extension UserModel {
	
	convenience init(elements: Set<UserProfileElementsView.Element>) {
		self.init()
		elements.forEach { element in
			switch element {
			case .profileImage(let image): 	picture = image
			case .displayName(let content): displayName = content?.text
			case .realName(let content): 	realName = content?.text
			case .location(let content): 	location = content?.loc
			case .bDay(let date):		    bDay = date?.date
			case .gender(let attr): 		gender = attr?.attr
			case .ethnicity(let attr): 		ethnicity = attr?.attr
			case .religion(let attr): 		religion = attr?.attr
			case .figure(let attr): 		figure = attr?.attr
			case .maritalStatus(let attr): 	maritalStatus = attr?.attr
			case .height(let content, _):   height = content?.text
			case .occupation(let content):  occupation = content?.text
			case .aboutMe(let content): 	aboutMe = content?.text
			case .doneButton(_): 			break
			}
		}
	}
}

fileprivate extension UserProfileElementsView.Element {
	
	private enum Constants {
		static let freeTextMaxLenght = 256
		static let aboutMeTextMaxLenght = 5000
		static let heightRange = Range<Int>(uncheckedBounds: (lower: 50, upper: 250))
		static let bDayRange = Range<Date>(uncheckedBounds: (lower: Date(timeIntervalSince1970: 0),
															 upper: Date()))
	}
	
	static var mandatory: Set<UserProfileElementsView.Element> {
		return [.displayName(nil), .realName(nil), .location(nil), .bDay(nil), .gender(nil), .maritalStatus(nil)]
	}
	
	var isMandatory: Bool {
		return UserProfileElementsView.Element.mandatory.contains(self)
	}
	
	func validate() -> Bool {
		switch self {
		case .profileImage(let image):
			return image != nil || !isMandatory
			
		case .displayName(let content),
			 .realName(let content),
			 .occupation(let content):
			guard let text = content?.text, text.count > 0 else {
				return !isMandatory
			}
			return text.count <= Constants.freeTextMaxLenght
		
		case .bDay(let content):
			guard let date = content?.date else {
				return !isMandatory
			}
			return Constants.bDayRange.contains(date)
		
		case .location(let content):
			return content?.loc != nil || !isMandatory

		case .gender(let content),
			 .ethnicity(let content),
			 .religion(let content),
			 .figure(let content),
			 .maritalStatus(let content):
			return content?.attr != nil || !isMandatory
			
		case .height(let content, _):
			guard let text = content?.text, text.count > 0 else {
				return !isMandatory
			}
			guard let intValue = Int(text), Constants.heightRange.contains(intValue) else {
				return false
			}
			return true
			
		case .aboutMe(let content):
			guard let text = content?.text, text.count > 0 else {
				return !isMandatory
			}
			return text.count <= Constants.aboutMeTextMaxLenght
		default:
			return true
		}
	}
	
	var errorString: String {
		switch self {
		case .profileImage:
			return "You should choose an image"
			
		case .displayName,
			 .realName,
			 .occupation:
			return "Text should be in range 1...256"
		
		case .bDay:
			return "bDay should be between 1970 and nowday"
			
		case .location:
			return "You should choos form list"
			
		case .gender,
			 .ethnicity,
			 .religion,
			 .figure,
			 .maritalStatus:
			return "Choose one of the options"
			
		case .height:
			return "Enter correct Int value (50-250)"
			
		case .aboutMe:
			return "Text should be in range 1...5000"
		default:
			return ""
		}
	}
}
