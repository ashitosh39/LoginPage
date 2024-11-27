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
        let userAgent: String = "iOS"+"/"+appVersion+"/" + UIDevice.current.systemVersion
     

        // Ensure the referral code is properly added to the URL
        guard let referralurl = URL(string: "https://uat-api.humpyfarms.com/api/configFeatures/validate/referralCode?referral_code=") else {
            print("Invalid URL")
            return
        }
        var components = URLComponents(url: referralurl, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "referralCode", value: "\(withReferralCode)")
        ]
        
        guard let finalUrl = components?.url else {
            print("Failed to construct the URL with query parameters")
            return
        }
        var request = URLRequest(url: referralurl, timeoutInterval: 30.0)
        request.addValue("iOS/1.0/18.1", forHTTPHeaderField: "User-Agent")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6MzU5MTUsImlhdCI6MTczMTkzMzg0MywiZXhwIjoxNzMyMzY1ODQzfQ.04ok2lMB_n4CO0rnpMxism94RrVgmvaOx-4ZvaVOxLk", forHTTPHeaderField: "Authorization")
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
                self?.delegate?.verifyReferralCode(with: .success(referralCodeResponse))
            } catch {
                // Handle JSON parsing error
                self?.delegate?.verifyReferralCode(with: .failure(error))
            }
        }
        
        task.resume()
    }
}
