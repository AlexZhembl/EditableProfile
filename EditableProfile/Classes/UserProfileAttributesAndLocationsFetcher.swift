//
//  UserProfileAttributesAndLocationsFetcher.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/21/20.
//

import Foundation

protocol UserProfileAttributesAndLocationsFetcher {
    func fetchLocations(with completion: @escaping (UserProfileLocationsResponse?) -> Void)
    func fetchAttributes(with completion: @escaping (UserProfileAttributesResponse?) -> Void)
}

final class UserProfileAttributesAndLocationsFetcherImpl: UserProfileAttributesAndLocationsFetcher {
    
    private let httpFabric: HTTPFabric
    
    init(httpFabric: HTTPFabric) {
        self.httpFabric = httpFabric
    }
    
    func fetchLocations(with completion: @escaping (UserProfileLocationsResponse?) -> Void) {
        let request = UserProfileAttributesAndLocationsFetcherRequest.locations
        httpFabric.makeRequest(request) { (result: Result<UserProfileLocationsResponse, Error>) in
            switch result {
            case .failure(let error):
                print("error with locations: \(error)")
                completion(nil)
            case .success(let response):
				guard response.cities.first != nil else {
					completion(nil)
					return
				}
                completion(response)
            }
        }
    }
    
    func fetchAttributes(with completion: @escaping (UserProfileAttributesResponse?) -> Void) {
        let request = UserProfileAttributesAndLocationsFetcherRequest.attrubutes
        httpFabric.makeRequest(request) { (result: Result<UserProfileAttributesResponse, Error>) in
            switch result {
            case .failure(let error):
                print("error with attributes: \(error)")
                completion(nil)
            case .success(let response):
				guard response.gender.first != nil,
				response.ethnicity.first != nil,
				response.religion.first != nil,
				response.figure.first != nil,
				response.maritalStatus.first != nil else {
					completion(nil)
					return
				}
                completion(response)
            }
        }
    }
}

fileprivate enum UserProfileAttributesAndLocationsFetcherRequest: HTTPURLRequestConvertible {
    case locations
    case attrubutes
    
    private enum Constants {
        // Better is to pass it from injection, but not today...
        static let baseURLPath = "http://localhost:8080/en/"
        static let timeoutInterval: TimeInterval = 10 * 1000
    }
    
    var path: String {
        switch self {
        case .locations: return "locations/cities.json"
        case .attrubutes: return "single_choice_attributes.json"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: Constants.baseURLPath) else {
            throw NSError(domain: "", code: -1, userInfo: ["Reason" : "Cannot create url from \(Constants.baseURLPath)"])
        }
      
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = "GET"
        request.timeoutInterval = Constants.timeoutInterval
      
        return request
    }
}
