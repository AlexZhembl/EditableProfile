//
//  UserProfileAttributesAndLocationsFetcherTests.swift
//  EditableProfileTests
//
//  Created by Aliaksei Zhemblouski on 5/24/20.
//

import Swinject
import Quick
import Nimble
@testable import EditableProfile

final class UserProfileAttributesAndLocationsFetcherTests: QuickSpec {

	override func spec() {
		var fabricMock: HTTPFabricMock!
		var container: Container!
		
		beforeEach {
			container = Container()
			fabricMock = HTTPFabricMock()

			container.register(UserProfileAttributesAndLocationsFetcher.self) { r in
				return UserProfileAttributesAndLocationsFetcherImpl(httpFabric: fabricMock)
			}
		}
		
		describe("Returned data") {
			context("When response is valid") {
				it("fetch locations") {
					fabricMock.resultingString = HTTPFabricMock.ResultingString.validLocations.rawValue
					let fetcher = container.resolve(UserProfileAttributesAndLocationsFetcher.self)!
					
					var locations: UserProfileLocationsResponse?
					waitUntil { done in
						fetcher.fetchLocations { locationsResponse in
							locations = locationsResponse
							done()
						}
					}
					expect(locations).toEventuallyNot(beNil())
				}
				it("fetch attributes") {
					fabricMock.resultingString = HTTPFabricMock.ResultingString.validAttributes.rawValue
					let fetcher = container.resolve(UserProfileAttributesAndLocationsFetcher.self)!
					
					var attributes: UserProfileAttributesResponse?
					waitUntil { done in
						fetcher.fetchAttributes { attributesResponse in
							attributes = attributesResponse
							done()
						}
					}
					expect(attributes).toEventuallyNot(beNil())
				}
			}
			
			context("When response is invalid") {
				beforeEach {
					fabricMock.resultingString = HTTPFabricMock.ResultingString.invalid.rawValue
				}
				it("fetch locations") {
					let fetcher = container.resolve(UserProfileAttributesAndLocationsFetcher.self)!
					
					var locations: UserProfileLocationsResponse?
					waitUntil { done in
						fetcher.fetchLocations { locationsResponse in
							locations = locationsResponse
							done()
						}
					}
					expect(locations).toEventually(beNil())
				}
				it("fetch attributes") {
					let fetcher = container.resolve(UserProfileAttributesAndLocationsFetcher.self)!
					
					var attributes: UserProfileAttributesResponse?
					waitUntil { done in
						fetcher.fetchAttributes { attributesResponse in
							attributes = attributesResponse
							done()
						}
					}
					expect(attributes).toEventually(beNil())
				}
			}
			
			context("When response is empty") {
				it("fetch locations") {
					fabricMock.resultingString = HTTPFabricMock.ResultingString.emptyLocations.rawValue
					let fetcher = container.resolve(UserProfileAttributesAndLocationsFetcher.self)!
					
					var locations: UserProfileLocationsResponse?
					waitUntil { done in
						fetcher.fetchLocations { locationsResponse in
							locations = locationsResponse
							done()
						}
					}
					expect(locations).toEventually(beNil())
				}
				it("fetch attributes") {
					fabricMock.resultingString = HTTPFabricMock.ResultingString.emptyAttributes.rawValue
					let fetcher = container.resolve(UserProfileAttributesAndLocationsFetcher.self)!
					
					var attributes: UserProfileAttributesResponse?
					waitUntil { done in
						fetcher.fetchAttributes { attributesResponse in
							attributes = attributesResponse
							done()
						}
					}
					expect(attributes).toEventually(beNil())
				}
			}
		}
	}
}

fileprivate final class HTTPFabricMock: HTTPFabric {
	
	enum ResultingString: String {
		// Array with at least one city
        case validLocations = "{\"cities\":[{\"lat\":\"56°09'N\", \"lon\":\"10°13'E\", \"city\":\"Aarhus\"}]}"
		// All attrubutes with at least one option
		case validAttributes = "{\"gender\":[{\"id\":\"123\", \"name\":\"Male\"}], \"ethnicity\":[{\"id\":\"123\", \"name\":\"Male\"}], \"religion\":[{\"id\":\"123\", \"name\":\"Male\"}], \"figure\":[{\"id\":\"123\", \"name\":\"Male\"}], \"marital_status\":[{\"id\":\"123\", \"name\":\"Male\"}]}"
		
        case invalid = ""
        case emptyLocations = "{\"cities\":[]}"
		case emptyAttributes = "{\"gender\":[], \"ethnicity\":[], \"religion\":[], \"figure\":[], \"maritalStatus\":[{\"id\":\"123\", \"name\":\"Male\"}]}"
    }
    
    var resultingString = ResultingString.validLocations.rawValue
	
	func makeRequest<Response>(_ request: HTTPURLRequestConvertible,
							   completionHandler: @escaping (Result<Response, Error>) -> Void) where Response : Decodable {
		let data = resultingString.data(using: .utf8)!
        if let response = try? JSONDecoder().decode(Response.self, from: data) {
            completionHandler(.success(response))
        } else {
			let error = NSError(domain: "test", code: 1, userInfo: ["reason" :"Failure"])
            completionHandler(.failure(error))
        }
	}
}
