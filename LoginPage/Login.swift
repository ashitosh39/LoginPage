//
//  Login.swift
//  LoginPage
//
//  Created by Digitalflake on 13/11/24.
//


import Foundation

// Model for the Login API Request
struct Login : Codable {
    var status: String
    var message: String
    var data: LoginData?
    
    struct LoginData: Codable {
        var otpSent: Bool  // Flag indicating whether the OTP was sent
        var mobile: String // The mobile number associated with the OTP
    }
}
