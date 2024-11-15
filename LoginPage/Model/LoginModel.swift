//
//  Login.swift
//  LoginPage
//
//  Created by Digitalflake on 13/11/24.
//


import Foundation


// MARK: - Welcome
struct LoginModel: Codable {
    
    let status: Int?
    let message: String?
    let result: LoginResponseResult?
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
        self.result = try container.decodeIfPresent(LoginResponseResult.self, forKey: .result)
    }
}

// MARK: - Result
struct LoginResponseResult: Codable {
    let customerID: Int?
    let reqID, expireTime: String?
    let trials: Int?
    let email, mobile: String?
    
    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case reqID = "req_id"
        case expireTime = "expire_time"
        case trials, email, mobile
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.customerID, forKey: .customerID)
        try container.encodeIfPresent(self.reqID, forKey: .reqID)
        try container.encodeIfPresent(self.expireTime, forKey: .expireTime)
        try container.encodeIfPresent(self.trials, forKey: .trials)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.mobile, forKey: .mobile)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.customerID = try container.decodeIfPresent(Int.self, forKey: .customerID)
        self.reqID = try container.decodeIfPresent(String.self, forKey: .reqID)
        self.expireTime = try container.decodeIfPresent(String.self, forKey: .expireTime)
        self.trials = try container.decodeIfPresent(Int.self, forKey: .trials)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.mobile = try container.decodeIfPresent(String.self, forKey: .mobile)
    }
}
