//
//  ViewModelFile.swift
//  LoginPage
//
//  Created by Digitalflake on 15/11/24.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didfinishLogin(with : Result <LoginModel, Error>)
}
class LoginViewModel {
    weak var delegate : LoginViewModelDelegate?
    init(delegate: LoginViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func login(mobile: String) {
        // Create JSON payload for the login request
        let parameters: [String: Any] = [
            "mobile": mobile,
            "can_whatsapp_send": 0  // Adjust this if necessary
        ]
        
        // Convert dictionary to JSON data
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Create URL request for the login API
            var request = URLRequest(url: URL(string: "https://uat-api.humpyfarms.com/api/customers/login")!, timeoutInterval: 30.0)
            request.httpMethod = "POST"
            request.setValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            
            // Send the request
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return } // Safely unwrap self
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // Check the HTTP status code
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode != 200 {
                        print("Failed to connect to the server. Please try again later.")

                    }
                }
                
                // Check if data is nil or empty
                guard let data = data, !data.isEmpty else {
                    print("Error: Received empty or nil data")
                    self.delegate?.didfinishLogin(with: .failure(error ?? "Error: Received empty or nil data"))
                    return
                }
                
                // Log the raw response data for debugging purposes
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                
                // Decode the response to check if OTP is sent
                do {
                    let loginResponse = try JSONDecoder().decode(LoginModel.self, from: data)
                    
                    if loginResponse.status == 200 , let loginResult = loginResponse.result{
                        self.delegate?.didfinishLogin(with: .success(loginResponse))
                        
                    } else {
                        self.delegate?.didfinishLogin(with: .failure(error!))
                    }
                } catch {
                    self.delegate?.didfinishLogin(with: .failure(error))
                }
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
}
