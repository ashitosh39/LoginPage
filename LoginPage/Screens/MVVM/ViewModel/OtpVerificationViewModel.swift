//
//  OtpVerificationViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import Foundation


protocol VerificationViewModelDelegate: AnyObject {
    func otpVerificationLoading(with result: Result<OtpVarificationModel, Error>)
}

class VerificationViewModel {
    weak var delegate: VerificationViewModelDelegate?
    init(delegate: VerificationViewModelDelegate? = nil) {
        self.delegate = delegate
    }

    func verifyOtp(otp: Int, requestId: String) {
        // Ensure that OTP and requestId are not empty or invalid
        guard otp > 0, !requestId.isEmpty else {
            print("Invalid OTP or Request ID.")
            return
        }
        
        let parameters : [String : Any] = [
            "otp": otp,
            "request_id": requestId
        ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Failed to serialize JSON data")
            return
        }
        
        var request = URLRequest(url: URL(string: "https://qa-api.humpyfarms.com/api/customers/verifyMobileOtp")!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(postData.count)", forHTTPHeaderField: "Content-Length")
        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task  = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.delegate?.otpVerificationLoading(with: .failure(error))
                return
            }
            
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
                self.delegate?.otpVerificationLoading(with: .failure(error))
                return
            }
            
            if httpResponse.statusCode != 200 {
                let serverError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to connect to the server."])
                self.delegate?.otpVerificationLoading(with: .failure(serverError))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                let emptyDataError = NSError(domain: "EmptyData", code: -2, userInfo: [NSLocalizedDescriptionKey: "Received empty or nil data."])
                self.delegate?.otpVerificationLoading(with: .failure(emptyDataError))
                return
            }
            
            // Log the raw response data
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Server Response: \(jsonString)")
            }
            
            // Decode the response data
            do {
                let verifyResponse = try JSONDecoder().decode(OtpVarificationModel.self, from: data)
                if verifyResponse.status == 200, let verifyResult = verifyResponse.result {
                    // If the response is successful and token is present
                    if let token = verifyResult.token {
                        print("OTP Verification successful: \(token)")
                        self.delegate?.otpVerificationLoading(with: .success(verifyResponse))
                    } else {
                        // Handle the case where the token is missing
                        let missingTokenError = NSError(domain: "MissingToken", code: -3, userInfo: [NSLocalizedDescriptionKey: "Token is missing in the response."])
                        self.delegate?.otpVerificationLoading(with: .failure(missingTokenError))
                    }
                } else {
                    // If status is not 200 or other failure condition
                    let decodingError = NSError(domain: "VerificationFailed", code: verifyResponse.status ?? 000, userInfo: [NSLocalizedDescriptionKey: verifyResponse.message ?? "Unknown error."])
                    self.delegate?.otpVerificationLoading(with: .failure(decodingError))
                }
            } catch {
                print("Failed to decode response: \(error)")
                self.delegate?.otpVerificationLoading(with: .failure(error))
            }
        }
        
        task.resume()
    }
}

//        // Create a URLSession data task
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//            do{
//                let verifyResponse = try JSONDecoder().decode(OtpVarificationModel.self, from: data)
//                if verifyResponse.status == 200, let verifyResult = verifyResponse.result {
//                    self.delegate?.didfinishloading(with: )
//                }
//
//               }
           
            
            // Try to parse the response
//            do {
//                let decoder = JSONDecoder()
//                let responseObject = try decoder.decode(OtpVarificationModel.self, from: data)
//                DispatchQueue.main.async {
//                    // Handle the response (e.g., show a success message or navigate to the next screen)
//                    if let token = responseObject.result?.token {
//                        print("OTP Verification successful: \(token)")
//                        let alert = UIAlertController(title: "Successful", message: token, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                        // Navigate to the next screen or show success
//                    }
//                }
//            } catch {
//                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//            //                DispatchQueue.main.async {
//            //                    // Navigate to the next screen
//            //                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NextScreenIdentifier")
//            //                    self.navigationController?.pushViewController(nextVC!, animated: true)
//            //                }
//
//        }
        
      
    
    
