//
//  UserProfileElementsValidator.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/23/20.
//

import Foundation

protocol UserProfileElementsValidator {
	func isElementValid(_ element: UserProfileElementsView.Element) -> Bool
	func error(for element: UserProfileElementsView.Element) -> String
}

final class UserProfileElementsValidatorImpl: UserProfileElementsValidator {
	
	func isElementValid(_ element: UserProfileElementsView.Element) -> Bool {
		return element.validate()
	}
	
	func error(for element: UserProfileElementsView.Element) -> String {
		return element.errorString
	}
}

fileprivate extension UserProfileElementsView.Element {
	
	private enum Constants {
		static let freeTextMaxLenght = 256
		static let aboutMeTextMaxLenght = 5000
		static let heightRange = Range<Int>(uncheckedBounds: (lower: 50, upper: 250))
	}
	
	var isMandatory: Bool {
		switch self {
		case .profileImage, .displayName, .location, .bDay, .gender:
			return true
		default:
			return false
		}
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
			return true
		
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
			return "Please selecte bDay"
			
		case .location:
			return "You should choos form list"
			
		case .gender,
			 .ethnicity,
			 .religion,
			 .figure,
			 .maritalStatus:
			return "Choose one of the options"
			
		case .height:
			return "Enter correct Int value"
			
		case .aboutMe:
			return "Text should be in range 1...5000"
		default:
			return ""
		}
	}
}
