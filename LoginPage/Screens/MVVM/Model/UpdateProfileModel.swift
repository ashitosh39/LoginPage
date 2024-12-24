//
//  UpdateProfileModel.swift
//  LoginPage
//
//  Created by Digitalflake on 27/11/24.
//

import Foundation


// MARK: - Welcome
struct ReferralCode: Codable {
    var status: Int?
    var message: String?
    var result: ReferralResult?
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
        self.result = try container.decodeIfPresent(ReferralResult.self, forKey: .result)
    }
}

// MARK: - Result
struct ReferralResult: Codable {
    var referrerCustomerID: Int?
    var referralCode: String?

    enum CodingKeys: String, CodingKey {
        case referrerCustomerID = "referrer_customer_id"
        case referralCode = "referral_code"
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.referrerCustomerID, forKey: .referrerCustomerID)
        try container.encodeIfPresent(self.referralCode, forKey: .referralCode)
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.referrerCustomerID = try container.decodeIfPresent(Int.self, forKey: .referrerCustomerID)
        self.referralCode = try container.decodeIfPresent(String.self, forKey: .referralCode)
    }
}
