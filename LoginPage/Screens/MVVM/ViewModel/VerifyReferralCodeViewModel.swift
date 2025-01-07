//
//  VerifyReferralCodeViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//


import Foundation

protocol ReferralCodeViewModelDelegate: AnyObject {
    func referralCodeVerify(with referralCodeResult: Result<ReferralResult, Error>)
}

class ReferralCodeViewModel {
    
    weak var delegate: ReferralCodeViewModelDelegate?
    
    init(delegate: ReferralCodeViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func validateReferralCode( forReferralCode referralCode: String) {
        
        guard var urlComponents = URLComponents(string: "https://uat-api.humpyfarms.com/api/configFeatures/validate/referralCode?referral_code") else {
            print("Invalid URL")
            return
        }
        urlComponents.queryItems = [URLQueryItem(name: "referral_code", value: referralCode)]
        
        guard let urlString = urlComponents.url else {
            print("Invalid URL")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token not found")
            return
        }
        
        var request = URLRequest(url: urlString, timeoutInterval: 30)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                   print("Error: Invalid response status code")
                    return
                }
            }
            
            guard let data =  data else{
                print("No data received from the server")
                return
            }
            
            if let rawString = String(data: data, encoding: .utf8) {
                print("Response: \(rawString)")
            }
            do {
                let decodedResponse = try JSONDecoder().decode(ReferralCode.self,from: data)
                DispatchQueue.main.async {
                    if let referralCode = decodedResponse.referralResult {
                        self.delegate?.referralCodeVerify(with: .success(referralCode))
                    } else {
                        self.delegate?.referralCodeVerify(with: .failure(NSError(domain: "NoReferralCode", code: 400, userInfo: nil)))
                    }
                }
                
            }catch let decodeError {
                print("Error decoding JSON: \(decodeError.localizedDescription)")
                DispatchQueue.main.async {
                    self.delegate?.referralCodeVerify(with: .failure(decodeError))
                }
            }
            
        }
        
        task.resume()
    }
}































































//import Foundation
//import UIKit
//
//protocol ReferralCodeViewModelDelegate: AnyObject {
//    func referralCodeVerify(with referralResult: Result<ReferralCode, Error>)
//}
//
//class ReferralCodeViewModel {
//
//    weak var delegate: ReferralCodeViewModelDelegate?
//    private var jsonDecoder: JSONDecoder
//
//    init(delegate: ReferralCodeViewModelDelegate? = nil) {
//        self.delegate = delegate
//        self.jsonDecoder = JSONDecoder()  // Initialize JSONDecoder here
//    }
//
//    func verifyReferralCode(withReferralCode referralCode: String) {
//        // Construct the URL with query parameter for the referral code
//        guard let referralUrl = URL(string: "https://qa-api.humpyfarms.com/api/configFeatures/validate/referralCode?code=\(referralCode)") else {
//            print("Invalid URL")
//            return
//        }
//
//        // Get the authorization token from UserDefaults
//       guard let token = UserDefaults.standard.string(forKey: "token") as? String else {
//           print("No token found in Userdefaults")
//           return
//        }
////        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
////        let userAgent: String = "iOS" + "/" + appVersion + "/" + UIDevice.current.systemVersion
//        // Create the URL request
//        var request = URLRequest(url: referralUrl, timeoutInterval: 30.0)  // Set reasonable timeout interval
//        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
//        request.setValue(token, forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"  // Using GET method here
//
//        // Start the network task
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            // Handle error if no data is returned
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
////                self.delegate?.referralCodeVerify(with: .failure(error))
//                return
//            }
//
//            // Check if response is valid and status code is 200
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Error: Invalid response status code \(httpResponse.statusCode)")
//                if httpResponse.statusCode != 200 {
//                    print ("Error Invalid response status code")
//                    return
//                }
//            }
//            guard let data else {
//                print("No data received from the server")
//                return
//            }
//            if  let rawString = String(data: data, encoding: .utf8) {
//                print("Raw Response: \(rawString)")
//            }
//
//
//            // Guard for data availability
////            guard let data = data else {
////                print("No data received")
////                DispatchQueue.main.async {
////                    let error = NSError(domain: "ReferralCodeError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server."])
////                    self.delegate?.referralCodeVerify(with: .failure(error))
////                }
////                    return
////
////            }
//            do {
//                // Try to decode the response into ReferralCode model
//                let referralCodeResponse = try self.jsonDecoder.decode(ReferralCode.self, from: data)
//                DispatchQueue.main.async {
//                    if let referralCodeResponse = referralCodeResponse.referralResult, ((referralCodeResponse.referralCode?.isEmpty) == nil) {
//
//                    }
//                    // If status is 1, it means the referral code is valid
//                    if referralCodeResponse.status == 1 {
//                        self.delegate?.referralCodeVerify(with: .success(referralCodeResponse))
//                    } else {
//                        // If status is not 1, it's an error or invalid code
//                        let error = NSError(domain: "ReferralCodeError", code: -1, userInfo: [NSLocalizedDescriptionKey: referralCodeResponse.message ?? "Unknown error"])
//                        self.delegate?.referralCodeVerify(with: .failure(error))
//                    }
//                } else {
//                    // If the response can't be parsed correctly
//                    let error = NSError(domain: "ReferralCodeError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format."])
//                    self.delegate?.referralCodeVerify(with: .failure(error))
//                }
//            } catch {
//                // Handle decoding error
//                print("Error decoding response: \(error)")
//                self.delegate?.referralCodeVerify(with: .failure(error))
//            }
//        }
//
//        task.resume()
//    }
//}
