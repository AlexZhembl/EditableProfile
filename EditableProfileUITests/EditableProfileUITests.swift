//
//  EditableProfileUITests.swift
//  EditableProfileUITests
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import XCTest
@testable import Swinject

var app: XCUIApplication!

class EditableProfileUITests: XCTestCase {

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    func testRootButtons() throws {
        app.buttons["Register new user"].tap()
        app.buttons["Change existing profile"].tap()
    }
}
