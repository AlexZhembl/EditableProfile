//
//  RootUITests.swift
//  RootUITests
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import XCTest
import Swinject
import Quick
import Nimble
@testable import EditableProfile

var app: XCUIApplication!

final class RootUITests: QuickSpec {

	override func spec() {
		app = XCUIApplication()
		app.launch()
		self.continueAfterFailure = false
		
		describe("viewDidAppear") {
			context("Edit profile button") {
				beforeEach {
					
				}
				it("Should be hidden") {
					let button = app.buttons["changeProfileButton"]
					expect(button.isHittable).to(equal(false))
				}
				
				it("Should be shown") {
					
				}
			}
		}
	}

    func testRootButtons() throws {
        app.buttons["Register new user"].tap()
        app.buttons["Change existing profile"].tap()
    }
}
