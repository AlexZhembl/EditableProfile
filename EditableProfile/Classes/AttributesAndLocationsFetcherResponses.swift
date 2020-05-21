//
//  AttributesAndLocationsFetcherResponses.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/21/20.
//

import Foundation

struct UserProfileLocationsResponse: Decodable {
    let cities: [CityInfo]
    
    struct CityInfo: Decodable {
        let lat: String
        let lon: String
        let city: String
    }
}

struct UserProfileAttributesResponse: Decodable {
    let gender: [Attribute]
    let ethnicity: [Attribute]
    let religion: [Attribute]
    let figure: [Attribute]
    let maritalStatus: [Attribute]
    
    private enum CodingKeys: String, CodingKey {
        case gender
        case ethnicity
        case religion
        case figure
        case maritalStatus = "marital_status"
    }
    
    struct Attribute: Decodable {
        let uid: String
        let name: String
        
        private enum CodingKeys: String, CodingKey {
            // let's never use id as propery for safety purp.
            case uid = "id"
            case name
        }
    }
}
