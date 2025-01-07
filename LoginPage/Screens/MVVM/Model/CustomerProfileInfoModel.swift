//
//  CustomerProfileInfoModel.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import Foundation
// MARK: - Welcome
struct Customer: Codable {
    var status: Int?
    var message: String?
    var customerDetails: CustomerDetails?
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.customerDetails, forKey: .customerDetails)
    }
    enum CodingKeys :String, CodingKey{
        case status
        case message
        case customerDetails = "result"
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.customerDetails = try container.decodeIfPresent(CustomerDetails.self, forKey: .customerDetails)
    }
}

// MARK: - Result
struct CustomerDetails: Codable {
    var customerID: Int?
    var email, customerFirstName, customerLastName, referalCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case email
        case customerFirstName = "customer_first_name"
        case customerLastName = "customer_last_name"
        case referalCode
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.customerID, forKey: .customerID)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.customerFirstName, forKey: .customerFirstName)
        try container.encodeIfPresent(self.customerLastName, forKey: .customerLastName)
        try container.encodeIfPresent(self.referalCode, forKey: .referalCode)
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.customerID = try container.decodeIfPresent(Int.self, forKey: .customerID)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.customerFirstName = try container.decodeIfPresent(String.self, forKey: .customerFirstName)
        self.customerLastName = try container.decodeIfPresent(String.self, forKey: .customerLastName)
        self.referalCode = try container.decodeIfPresent(String.self, forKey: .referalCode)
    }
}
