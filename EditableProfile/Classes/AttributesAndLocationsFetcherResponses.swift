//
//  AttributesAndLocationsFetcherResponses.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/21/20.
//

import Foundation

struct UserProfileLocationsResponse: Decodable {
    let cities: [UserLocation]
}

struct UserProfileAttributesResponse: Decodable {
    let gender: [UserAttribute]
    let ethnicity: [UserAttribute]
    let religion: [UserAttribute]
    let figure: [UserAttribute]
    let maritalStatus: [UserAttribute]
    
    private enum CodingKeys: String, CodingKey {
        case gender
        case ethnicity
        case religion
        case figure
        case maritalStatus = "marital_status"
    }
}
