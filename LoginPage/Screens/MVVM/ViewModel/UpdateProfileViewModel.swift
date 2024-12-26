//
//  UpdateProfileViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 19/11/24.
//
import Foundation
import UIKit

protocol UpdateProfileViewModelDelegate: AnyObject {
    func verifyReferralCode(with result: Result<ReferralCode, Error>)
}

class UpdateProfileViewModel {
    
    weak var delegate: UpdateProfileViewModelDelegate?
    
    init(delegate: UpdateProfileViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func verifyReferralCode(withReferralCode: String) {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let userAgent: String = "iOS" + "/" + appVersion + "/" + UIDevice.current.systemVersion
        
        guard let referralurl = URL(string: "https://uat-api.humpyfarms.com/api/configFeatures/validate/referralCode") else {
            print("Invalid URL")
            return
        }
        var components = URLComponents(url: referralurl, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "referral_code", value: "\(withReferralCode)")
        ]
        
        guard let finalUrl = components?.url else {
            print("Failed to construct the URL with query parameters")
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "token")
        var request = URLRequest(url: finalUrl, timeoutInterval: 30.0)
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // Handle error if no data is returned
            if let error = error {
                self?.delegate?.verifyReferralCode(with: .failure(error))
                return
            }
            
            // Check if response is valid
            guard let data = data else {
                let error = NSError(domain: "UpdateProfile", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                self?.delegate?.verifyReferralCode(with: .failure(error))
                return
            }
            
            do {
                // Parse the data into the ReferralCode model
                let referralCodeResponse = try JSONDecoder().decode(ReferralCode.self, from: data)
                
                // Check the status code to determine if the referral code was valid
                if let status = referralCodeResponse.status, status == 1 {
                    self?.delegate?.verifyReferralCode(with: .success(referralCodeResponse))
                } else {
                    let error = NSError(domain: "UpdateProfile", code: -1, userInfo: [NSLocalizedDescriptionKey: referralCodeResponse.message ?? "Unknown error"])
                    self?.delegate?.verifyReferralCode(with: .failure(error))
                }
            } catch {
                // Handle JSON parsing error
                self?.delegate?.verifyReferralCode(with: .failure(error))
            }
        }
        
        task.resume()
    }
}
