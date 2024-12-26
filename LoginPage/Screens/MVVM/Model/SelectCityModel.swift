//
//  SelectCityModel.swift
//  LoginPage
//
//  Created by Digitalflake on 20/12/24.
//
import Foundation

// Model for the response
struct CityModel: Codable {
    var status: Int?
    var message: String?
    var result: [Results]?
}

// Result Model for each city
struct Results: Codable {
    var cityID: Int?
    var cityName, stateName: String?
    var cityImageURL: String?
    var sequence, status: Int?

    enum CodingKeys: String, CodingKey {
        case cityID = "city_id"
        case cityName = "city_name"
        case stateName = "state_name"
        case cityImageURL = "city_image_url"
        case sequence, status
    }
}
//

//import Foundation
//
//struct CityModel: Codable {
//    var status: Int?
//    var message: String?
//    var result: [Results]?
//}
//
//// MARK: - Result
//struct Results: Codable {
//    var cityID: Int?
//    var cityName, stateName: String?
//    var cityImageURL: String?
//    var sequence, status: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case cityID = "city_id"
//        case cityName = "city_name"
//        case stateName = "state_name"
//        case cityImageURL = "city_image_url"
//        case sequence, status
//    }
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.cityID = try container.decodeIfPresent(Int.self, forKey: .cityID)
//        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName)
//        self.stateName = try container.decodeIfPresent(String.self, forKey: .stateName)
//        self.cityImageURL = try container.decodeIfPresent(String.self, forKey: .cityImageURL)
//        self.sequence = try container.decodeIfPresent(Int.self, forKey: .sequence)
//        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
//    }
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(self.cityID, forKey: .cityID)
//        try container.encodeIfPresent(self.cityName, forKey: .cityName)
//        try container.encodeIfPresent(self.stateName, forKey: .stateName)
//        try container.encodeIfPresent(self.cityImageURL, forKey: .cityImageURL)
//        try container.encodeIfPresent(self.sequence, forKey: .sequence)
//        try container.encodeIfPresent(self.status, forKey: .status)
//    }
//}
//
