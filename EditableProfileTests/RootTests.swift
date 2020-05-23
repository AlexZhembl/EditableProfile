//
//  RootTests.swift
//  EditableProfileTests
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import Swinject
import Quick
import Nimble
@testable import EditableProfile

final class RootTests: QuickSpec {

	override func spec() {
		var rootVCMock: RootVCMock!
		var userModelProviderMock: UserModelProviderMock!
		var container: Container!
		
		beforeEach {
			container = Container()
			rootVCMock = RootVCMock()
			userModelProviderMock = UserModelProviderMock()

			container.register(RootViewModel.self) { r in
				let model = RootViewModelImpl(userModelProvider: userModelProviderMock,
											  router: RootRouterMock())
				model.view = rootVCMock
				return model
			}
		}
		
		describe("Root buttons appereance") {
			context("User unregistered") {
				beforeEach {
					userModelProviderMock.isUserRegistered = false
				}
				
				it("show only register button") {
					let model = container.resolve(RootViewModel.self)!
					model.viewWillAppear()
					
					expect(rootVCMock.registerButton != nil).to(equal(true))
					expect(rootVCMock.changeProfileButton != nil).to(equal(true))
					
					expect(rootVCMock.changeProfileButton?.isHidden).to(equal(true))
				}
			}
				
			context("User registered") {
				beforeEach {
					userModelProviderMock.isUserRegistered = true
				}
				
				it("Show both") {
					let model = container.resolve(RootViewModel.self)!
					model.viewWillAppear()
					
					expect(rootVCMock.registerButton != nil).to(equal(true))
					expect(rootVCMock.changeProfileButton != nil).to(equal(true))
					
					expect(rootVCMock.changeProfileButton?.isHidden).to(equal(false))
				}
			}
		}
	}
}

fileprivate struct RootRouterMock: RootRouter {
	func presentUserProfileViewController() { }
}

fileprivate final class UserModelProviderMock: UserModelProvider {
	var isUserRegistered: Bool = false
	
	func fetchUserModel() -> UserModel? {
		return nil
	}
	
	func syncUserModel(_ model: UserModel?) { }
}

fileprivate final class RootVCMock: RootView {
	var registerButton: RootButtonModel?
	var changeProfileButton: RootButtonModel?
	
	func setupButtons(register: RootButtonModel, changeProfile: RootButtonModel) {
		registerButton = register
		changeProfileButton = changeProfile
	}
}
