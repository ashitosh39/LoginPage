//
//  LoginViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import Foundation
protocol LoginViewModelDelegate: AnyObject {
    func loginMobileNo(with : Result <LoginModel, Error>)
}

class LoginViewModel {
    weak var delegate : LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func login(mobile: String, canSendWhatsApp: Int) {
        let parameters: [String: Any] = [
            "mobile": mobile,
            "can_whatsapp_send": 1 // This is crucial
        ]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: URL(string: "https://qa-api.humpyfarms.com/api/customers/login")!, timeoutInterval: 30.0)
            request.httpMethod = "POST"
            request.setValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.delegate?.loginMobileNo(with: .failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Error: Invalid response")
                    self.delegate?.loginMobileNo(with: .failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                    return
                }
                
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    let serverError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to connect to the server."])
                    self.delegate?.loginMobileNo(with: .failure(serverError))
                    return
                }
                
                guard let data = data, !data.isEmpty else {
                    print("Error: Received empty or nil data")
                    let emptyDataError = NSError(domain: "EmptyData", code: -2, userInfo: [NSLocalizedDescriptionKey: "Received empty or nil data."])
                    self.delegate?.loginMobileNo(with: .failure(emptyDataError))
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                
                do {
                    let loginResponse = try JSONDecoder().decode(LoginModel.self, from: data)
                    if loginResponse.status == 200, let loginResult = loginResponse.result {
                        self.delegate?.loginMobileNo(with: .success(loginResponse))
                    } else {
                        let decodingError = NSError(domain: "LoginError", code: loginResponse.status ?? 000, userInfo: [NSLocalizedDescriptionKey: loginResponse.message ?? "Unknown error."])
                        self.delegate?.loginMobileNo(with: .failure(decodingError))
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    self.delegate?.loginMobileNo(with: .failure(error))
                }
            }
            task.resume()
            
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            self.delegate?.loginMobileNo(with: .failure(error))
        }
    }
}
