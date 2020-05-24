//
//  RootUITests.swift
//  RootUITests
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import XCTest

class RootUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()
    }

    func testRegistrationAndHeightField() {
        app.launch()

		// Move to user profile screen
		XCTAssertTrue(app.buttons["registerButton"].exists)
        app.buttons["registerButton"].tap()
		
		// Wait until locations and attributes will be loaded
		wait(timeInterval: 4)
		guard app.buttons["pictureButton"].exists else {
			// http request failed
			return
		}
		
		// When register heightField could be editable
		XCTAssertTrue(app.textFields["heightField"].isEnabled)
		
		// Fill mandatory fields
		fullFillUserModel()
		app.buttons["doneButton"].tap()
		
		//Wait for dismissing profile VC
		wait(timeInterval: 1)
		
		// changeProfileButton could be displayed
		XCTAssertTrue(app.buttons["changeProfileButton"].isEnabled)
		
		// Let's check heightField now
		app.buttons["changeProfileButton"].tap()
		// Wait until locations and attributes will be loaded
		wait(timeInterval: 4)
		guard app.buttons["pictureButton"].exists else {
			// http request failed
			return
		}
		// When we edit profile heightField could be not editable
		XCTAssertFalse(app.textFields["heightField"].isEnabled)
    }
	
	func fullFillUserModel() {
		app.textFields["displayNameField"].tap()
		app.textFields["displayNameField"].typeText("Alex")
		
		app.textFields["realNameField"].tap()
		wait(timeInterval: 1)
		app.textFields["realNameField"].typeText("Tony")
		
		app.textFields["locationField"].tap()
		wait(timeInterval: 1)
		app.textFields["locationField"].typeText("be")
		wait(timeInterval: 1)
		app.cells.matching(identifier: "SingleChoicePickerViewCell").element(boundBy: 0).tap()
		
		app.buttons["bDayButton"].tap()
		wait(timeInterval: 1)
		app.buttons["datePickerDoneButton"].tap()
		
		app.buttons["genderButton"].tap()
		wait(timeInterval: 1)
		app.cells.matching(identifier: "SingleChoicePickerViewCell").element(boundBy: 0).tap()
		
		app.buttons["maritalStatusButton"].tap()
		wait(timeInterval: 1)
		app.cells.matching(identifier: "SingleChoicePickerViewCell").element(boundBy: 0).tap()
	}
	
	func wait(timeInterval: TimeInterval) {
		let waitExpectation = expectation(description: "locationsAndAttributes")
		let when = DispatchTime.now() + timeInterval
		DispatchQueue.main.asyncAfter(deadline: when) {
		  waitExpectation.fulfill()
		}
		waitForExpectations(timeout: timeInterval + 0.5)
	}
}
