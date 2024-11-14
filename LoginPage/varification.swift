//
//  varification.swift
//  LoginPage
//
//  Created by Digitalflake on 13/11/24.
//

import Foundation

// Model for the Login API Response
struct LoginResponses: Codable {
    var status: String  // Status of the request (e.g., "success", "failure")
    var message: String  // Message to describe the result (e.g., "OTP sent", "Invalid number")
    var data: LoginData?  // Optional data field (for example, OTP sent time or session info)
    
    struct LoginData: Codable {
        var otpSent: Bool  // A flag to indicate whether OTP was sent
        var mobile: String  // The mobile number to confirm the login
    }
    
    // You can create an initializer for default values if needed
    init(status: String, message: String, data: LoginData? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}








