//
//  UserModelProvider.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/22/20.
//

import Foundation

protocol UserModelProviderSettings: AnyObject {
	var userData: Data? { get set }
}

protocol UserModelProvider {
	var isUserRegistered: Bool { get }
	
	func fetchUserModel() -> UserModel?
	func syncUserModel(_ model: UserModel?)
}

final class UserModelProviderImpl: UserModelProvider {
	
	private let settings: UserModelProviderSettings
	
	init(settings: UserModelProviderSettings) {
		self.settings = settings
	}
	
	var isUserRegistered: Bool { settings.userData != nil }
	
	func fetchUserModel() -> UserModel? {
		guard let model = settings.userData else {
			return nil
		}
		
		let decoder = JSONDecoder()
		return try? decoder.decode(UserModel.self, from: model)
	}
	
	func syncUserModel(_ model: UserModel?) {
		guard let model = model else {
			settings.userData = nil
			print("User removed")
			return
		}
	
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(model) {
			settings.userData = encoded
		}
		else {
			assertionFailure("Could not create userData")
		}
	}
}
