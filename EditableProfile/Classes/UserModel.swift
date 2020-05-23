//
//  UserModel.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/22/20.
//

import UIKit

final class UserModel: Codable {
	var picture: UIImage?
	var displayName: String
	var realName: String?
	var location: UserLocation
	var bDay: Date
	var gender: UserAttribute
	var ethnicity: UserAttribute?
	var religion: UserAttribute?
	var figure: UserAttribute?
	var maritalStatus: UserAttribute
	var height: String
	var occupation: String?
	var aboutMe: String?
	
	private enum CodingKeys: String, CodingKey {
		case picture
		case displayName
		case realName
		case location
		case bDay
		case gender
		case ethnicity
		case religion
		case figure
		case maritalStatus
		case height
		case occupation
		case aboutMe
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		displayName = try container.decode(String.self, forKey: .displayName)
		location = try container.decode(UserLocation.self, forKey: .location)
		bDay = try container.decode(Date.self, forKey: .bDay)
		gender = try container.decode(UserAttribute.self, forKey: .gender)
		maritalStatus = try container.decode(UserAttribute.self, forKey: .maritalStatus)
		height = try container.decode(String.self, forKey: .height)
		
		realName = try container.decodeIfPresent(String.self, forKey: .realName)
		ethnicity = try container.decodeIfPresent(UserAttribute.self, forKey: .ethnicity)
		religion = try container.decodeIfPresent(UserAttribute.self, forKey: .religion)
		figure = try container.decodeIfPresent(UserAttribute.self, forKey: .figure)
		occupation = try container.decodeIfPresent(String.self, forKey: .occupation)
		aboutMe = try container.decodeIfPresent(String.self, forKey: .aboutMe)
		
		if let imageData = try container.decodeIfPresent(Data.self, forKey: .picture) {
			picture = UIImage(data: imageData)
		}
		else {
			picture = nil
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(displayName, forKey: .displayName)
		try container.encode(location, forKey: .location)
		try container.encode(bDay, forKey: .bDay)
		try container.encode(gender, forKey: .gender)
		try container.encode(maritalStatus, forKey: .maritalStatus)
		try container.encode(height, forKey: .height)
		
		try container.encodeIfPresent(realName, forKey: .realName)
		try container.encodeIfPresent(ethnicity, forKey: .ethnicity)
		try container.encodeIfPresent(religion, forKey: .religion)
		try container.encodeIfPresent(figure, forKey: .figure)
		try container.encodeIfPresent(occupation, forKey: .occupation)
		try container.encodeIfPresent(aboutMe, forKey: .aboutMe)
		
		try container.encodeIfPresent(picture?.pngData(), forKey: .picture)
	}
}

struct UserAttribute: Codable {
	let uid: String
	let name: String
	
	private enum CodingKeys: String, CodingKey {
		case uid = "id"
		case name
	}
}

struct UserLocation: Codable {
	let lat: String
	let lon: String
	let city: String
}
