//
//  UserModelProviderTests.swift
//  EditableProfileTests
//
//  Created by Aliaksei Zhemblouski on 5/23/20.
//

import Swinject
import Quick
import Nimble
@testable import EditableProfile

final class UserModelProviderTests: QuickSpec {

	override func spec() {
		var userModelProvider: UserModelProvider!
		var container: Container!
		
		beforeEach {
			container = Container()
			container.register(UserModelProvider.self) { r in
				return UserModelProviderImpl(settings: r.resolve(UserModelProviderSettings.self)!)
			}
		}
		
		describe("Storage interaction") {
			context("When user does not exists") {
				beforeEach {
					container.register(UserModelProviderSettings.self) { _ in
						let mock = UserModelProviderSettingsMock()
						mock.userData = nil
						return mock
					}
				}
				
				it("fetch nothing") {
					userModelProvider = container.resolve(UserModelProvider.self)!
					let userModel = userModelProvider.fetchUserModel()
					expect(userModel).to(beNil())
				}
			
				it("register new user") {
					expect(userModelProvider.isUserRegistered).to(equal(false))
					
					userModelProvider = container.resolve(UserModelProvider.self)!
					userModelProvider.syncUserModel(UserModel())
					
					expect(userModelProvider.isUserRegistered).to(equal(true))
				}
			}
			
			context("When user exists") {
				beforeEach {
					container.register(UserModelProviderSettings.self) { _ in
						let mock = UserModelProviderSettingsMock()
						let data = try! JSONEncoder().encode(UserModel())
						mock.userData = data
						return mock
					}
				}
				
				it("fetch model") {
					userModelProvider = container.resolve(UserModelProvider.self)!
					let userModel = userModelProvider.fetchUserModel()
					expect(userModel).toNot(beNil())
				}
			
				it("remove user") {
					expect(userModelProvider.isUserRegistered).to(equal(true))
					
					userModelProvider = container.resolve(UserModelProvider.self)!
					userModelProvider.syncUserModel(nil)
					
					expect(userModelProvider.isUserRegistered).to(equal(false))
				}
			}
		}
	}
}

fileprivate final class UserModelProviderSettingsMock: UserModelProviderSettings {
	var userData: Data?
}
