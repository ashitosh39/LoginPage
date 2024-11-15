//
//  varification.swift
//  LoginPage
//
//  Created by Digitalflake on 13/11/24.
//

import Foundation

// Model for the Login API Response

struct OTPRespons: Codable {
    let status: Int?
    let message: String?
    let result: OTPResponsResult?
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.result, forKey: .result)
    }
    
    enum CodingKeys: CodingKey {
        case status
        case message
        case result
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.result = try container.decodeIfPresent(OTPResponsResult.self, forKey: .result)
    }
}

// MARK: - Result
struct OTPResponsResult: Codable {
    let token: String?
    let customerID: Int?
    let isRefferalScreen: Bool?

    enum CodingKeys: String, CodingKey {
        case token
        case customerID = "customer_id"
        case isRefferalScreen = "is_refferal_screen"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.token, forKey: .token)
        try container.encodeIfPresent(self.customerID, forKey: .customerID)
        try container.encodeIfPresent(self.isRefferalScreen, forKey: .isRefferalScreen)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
        self.customerID = try container.decodeIfPresent(Int.self, forKey: .customerID)
        self.isRefferalScreen = try container.decodeIfPresent(Bool.self, forKey: .isRefferalScreen)
    }
}







