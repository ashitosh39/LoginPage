//
//  CustomerProfileInfoModel.swift
//  LoginPage
//
//  Created by Digitalflake on 26/12/24.
//

import Foundation


// MARK: - Welcome
struct Customer: Codable {
    var status: Int?
    var message: String?
    var customerDetails: CustomerDetails?
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
