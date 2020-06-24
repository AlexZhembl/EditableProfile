//
//  UserProfileModelFabricTests.swift
//  EditableProfileTests
//
//  Created by Aliaksei Zhemblouski on 5/24/20.
//

import Swinject
import Quick
import Nimble
@testable import EditableProfile

final class UserProfileModelFabricTests: QuickSpec {

	override func spec() {
		var container: Container!
		let textGeneratingClosure: (Int) -> String = { limit in
			return String((0 ..< limit).map { _ in "0" })
		}
		
		beforeEach {
			container = Container()
			container.register(UserProfileModelFrabric.self) { r in
				return UserProfileModelFrabricImpl()
			}
		}
		
		describe("Text limits") {
			var elements: [UserProfileElementsView.Element] = []
			context("limits are in borders") {
				beforeEach {
					elements = [.displayName((textGeneratingClosure(256), nil)),
								.realName((textGeneratingClosure(256), nil)),
								.occupation((textGeneratingClosure(256), nil)),
								.aboutMe((textGeneratingClosure(5000), nil))]
				}
				it("Should validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!

					elements.forEach {
						expect(fabric.isElementValid($0)).to(equal(true))
					}
				}
			}
			context("limits are out of borders") {
				beforeEach {
					elements = [.displayName((textGeneratingClosure(257), nil)),
								.realName((textGeneratingClosure(257), nil)),
								.occupation((textGeneratingClosure(257), nil)),
								.aboutMe((textGeneratingClosure(5001), nil))]
				}
				it("Should invalidate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					
					elements.forEach {
						expect(fabric.isElementValid($0)).to(equal(false))
					}
				}
			}
		}
		
		describe("Data fields correctness") {
			context("Height input") {
				it("should validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					
					expect(fabric.isElementValid(.height(("100", nil), isEnabled: true))).to(equal(true))
					expect(fabric.isElementValid(.height(nil, isEnabled: true))).to(equal(true))
				}
				it("should not validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					
					expect(fabric.isElementValid(.height(("xyz", nil), isEnabled: true))).to(equal(false))
					expect(fabric.isElementValid(.height(("1000", nil), isEnabled: true))).to(equal(false))
				}
			}
			context("b-day input") {
				it("should validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					
					expect(fabric.isElementValid(.bDay((Date(timeIntervalSinceNow: -100), nil)))).to(equal(true))
				}
				it("should not validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					
					expect(fabric.isElementValid(.bDay((Date(timeIntervalSinceNow: 1), nil)))).to(equal(false))
					expect(fabric.isElementValid(.bDay(nil))).to(equal(false))
				}
			}
			context("Attributes input") {
				it("should validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					let attr: [UserProfileElementsView.Element] = [.gender((UserAttribute(uid: "", name: ""), nil)),
																   .ethnicity((UserAttribute(uid: "", name: ""), nil)),
																   .religion((UserAttribute(uid: "", name: ""), nil)),
																   .figure((UserAttribute(uid: "", name: ""), nil)),
																   .maritalStatus((UserAttribute(uid: "", name: ""), nil))]
					attr.forEach {
						expect(fabric.isElementValid($0)).to(equal(true))
					}
				}
				it("should not validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					let attr: [UserProfileElementsView.Element] = [.gender(nil),
																   .maritalStatus(nil)]
					attr.forEach {
						expect(fabric.isElementValid($0)).to(equal(false))
					}
				}
			}
			context("Location input") {
				it("should validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
				
					expect(fabric.isElementValid(.location((UserLocation(lat: "", lon: "", city: ""), nil)))).to(equal(true))
				}
				it("should not validate") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					
					expect(fabric.isElementValid(.location(nil))).to(equal(false))
				}
			}
		}
		
		describe("Mandatory fields checking") {
			var elements: Set<UserProfileElementsView.Element> = []
			beforeEach {
				elements = [.displayName((textGeneratingClosure(13), nil)),
							.realName((textGeneratingClosure(123), nil)),
							.bDay((Date(timeIntervalSinceNow: -100), nil)),
							.gender((UserAttribute(uid: "", name: ""), nil)),
							.maritalStatus((UserAttribute(uid: "", name: ""), nil)),
							.location((UserLocation(lat: "", lon: "", city: ""), nil))
							]
			}
			context("Not enough mandatory elements") {
				it("should throw error") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					
					let copySet = elements
					copySet.forEach {
						elements = copySet
						elements.remove($0)
						let model = try? fabric.createModel(from: elements)
						expect(model).to(beNil())
					}
				}
			}
			
			context("Not enough mandatory elements") {
				beforeEach { elements.removeFirst() }
				it("should throw error") {
					let fabric = container.resolve(UserProfileModelFrabric.self)!
					
					let model = try? fabric.createModel(from: elements)
					expect(model).to(beNil())
				}
			}
		}
        
        describe("Test images with primary and secondary") {
            it ("Shoud store profile pict as primary (in profile pic field)") {
                
                let fabric = container.resolve(UserProfileModelFrabric.self)!
                
                let primaryImage = UIImage()
                let secondaryImage = UIImage()
                let elements: Set<UserProfileElementsView.Element> = [.displayName((textGeneratingClosure(13), nil)),
                                                                   .realName((textGeneratingClosure(123), nil)),
                                                                   .bDay((Date(timeIntervalSinceNow: -100), nil)),
                                                                   .gender((UserAttribute(uid: "", name: ""), nil)),
                                                                   .maritalStatus((UserAttribute(uid: "", name: ""), nil)),
                                                                   .location((UserLocation(lat: "", lon: "", city: ""), nil)),
                                                                   
                                                                   .profileImage(primaryImage),
                                                                   .anotherProfileImage(secondaryImage),
                                                                   .pictureSwitch(false),
                ]
                guard let model = try? fabric.createModel(from: elements) else {
                    return
                }
                
                if model.picture === primaryImage && model.anotherPicture === secondaryImage {
                    expect(false).to(equal(false))
                }
                else {
                     expect(false).to(equal(true))
                }
            }
            
            it ("Shoud store profile pict as secondary (in another profile pic field)") {
                
                let fabric = container.resolve(UserProfileModelFrabric.self)!
                
                let primaryImage = UIImage()
                let secondaryImage = UIImage()
                let elements: Set<UserProfileElementsView.Element> = [.displayName((textGeneratingClosure(13), nil)),
                                                                      .realName((textGeneratingClosure(123), nil)),
                                                                      .bDay((Date(timeIntervalSinceNow: -100), nil)),
                                                                      .gender((UserAttribute(uid: "", name: ""), nil)),
                                                                      .maritalStatus((UserAttribute(uid: "", name: ""), nil)),
                                                                      .location((UserLocation(lat: "", lon: "", city: ""), nil)),
                                                                      
                                                                      .profileImage(primaryImage),
                                                                      .anotherProfileImage(secondaryImage),
                                                                      .pictureSwitch(true),
                ]
                guard let model = try? fabric.createModel(from: elements) else {
                    return
                }
                
                if model.picture === secondaryImage && model.anotherPicture === primaryImage {
                    expect(false).to(equal(false))
                }
                else {
                    expect(false).to(equal(true))
                }
            }
        }
	}
}
