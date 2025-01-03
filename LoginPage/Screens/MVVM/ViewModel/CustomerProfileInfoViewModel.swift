//
//  CustomerProfileInfo.swift
//  LoginPage
//
//  Created by Digitalflake on 26/12/24.
//



import Foundation

protocol CustomerProfileInfo: AnyObject {
    func customerProfile(with result: Result<Customer, Error>)
}

class CustomerProfileViewModel {
    weak var delegate: CustomerProfileInfo?
    
    init(delegate: CustomerProfileInfo? = nil) {
        self.delegate = delegate
    }
    
    func customerProfile(firstName: String, lastName: String, email: String, referralCode: String,customerId : Int) {
        // Ensure customerId exists
//        guard let customerId = UserDefaults.standard.value(forKey: "customerID") as? String else {
//            print("Error: Customer ID not found.")
//            return
//        }
        
        let parameters: [String: Any] = [
            "customer_id": customerId,
            "customer_first_name": firstName,
            "customer_last_name": lastName,
            "email": email,
            "referralCode": referralCode
        ]
        
        do {
            // Convert parameters to JSON data
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            // Create URL request
            var request = URLRequest(url: URL(string: "https://qa-api.humpyfarms.com/api/customers/saveCustomerProfileInfo")!,  timeoutInterval: 60)
            request.httpMethod = "POST"
            
            // Get token from UserDefaults
            guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
                print("Error: Token not found.")
                return
            }
            // Set request headers
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            
            // Send the request
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                // Check for errors
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.delegate?.customerProfile(with: .failure(error))
                    return
                }
                
                // Check for valid response
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Error: Invalid response.")
                    self.delegate?.customerProfile(with: .failure(NSError(domain: "INVALID_RESPONSE", code: -1, userInfo: nil)))
                    return
                }
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                // Handle HTTP error status codes
                if httpResponse.statusCode != 200 {
                    let serverError = NSError(domain: "HTTPError", code: httpResponse.statusCode,
                                              userInfo: [NSLocalizedDescriptionKey: "Failed to connect to the server."])
                    self.delegate?.customerProfile(with: .failure(serverError))
                    return
                }
                
                // Handle empty or nil data
                guard let data = data, !data.isEmpty else {
                    print("Error: Received empty data")
                    let emptyDataError = NSError(domain: "EmptyData", code: -2, userInfo: [NSLocalizedDescriptionKey: "Received empty or nil data."])
                    self.delegate?.customerProfile(with: .failure(emptyDataError))
                    return
                }
                
                // Optionally print the response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
                
                // Attempt to decode the customer response
                do {
                    let customerResponse = try JSONDecoder().decode(Customer.self, from: data)
                    if customerResponse.status == 200, let customerResult = customerResponse.customerDetails {
                        self.delegate?.customerProfile(with: .success(customerResponse))
                    } else {
                        let decodingError = NSError(domain: "DecodingError", code: customerResponse.status ?? 000,
                                                     userInfo: [NSLocalizedDescriptionKey: customerResponse.message ?? "Unknown Error"])
                        self.delegate?.customerProfile(with: .failure(decodingError))
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    self.delegate?.customerProfile(with: .failure(error))
                }
            }
            
            // Start the request
            task.resume()
            
        } catch {
            // Handle serialization error
            print("Error serializing JSON: \(error.localizedDescription)")
            self.delegate?.customerProfile(with: .failure(error))
        }
    }
}


//class CustomerProfileViewModel {
//    weak var delegate: CustomerProfileInfo?
//
//    init(delegate: CustomerProfileInfo? = nil) {
//        self.delegate = delegate
//    }
//
//    func customerProfile(firstName: String, lastName: String, email: String) {
//        let parameters: [String: Any] = [
//            "firstName": firstName,
//            "lastName": lastName,
//            "email": email
//        ]
//
//        do {
//            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            var request = URLRequest(url: URL(string: "https://qa-api.humpyfarms.com/api/customers/saveCustomerProfileInfo")!, timeoutInterval: 30.0)
//            request.httpMethod = "POST"
//            request.setValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "Accept")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = postData
//
//            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//                guard let self = self else { return }
//
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                    self.delegate?.customerProfile(with: .failure(error))
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    print("Error: Invalid response")
//                    self.delegate?.customerProfile(with: .failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
//                    return
//                }
//
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                if httpResponse.statusCode != 200 {
//                    let serverError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to connect to the server."])
//                    self.delegate?.customerProfile(with: .failure(serverError))
//                    return
//                }
//
//                guard let data = data, !data.isEmpty else {
//                    print("Error: Received empty or nil data")
//                    let emptyDataError = NSError(domain: "EmptyData", code: -2, userInfo: [NSLocalizedDescriptionKey: "Received empty or nil data."])
//                    self.delegate?.customerProfile(with: .failure(emptyDataError))
//                    return
//                }
//
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("Response data: \(responseString)")
//                }
//
//                do {
//                    // Assuming the response model for saving customer profile is `Customer`
//                    let profileResponse = try JSONDecoder().decode(Customer.self, from: data)
//
//                    // Check if the status is 200 before passing success
//                    if profileResponse.status == 200 {
//                        self.delegate?.customerProfile(with: .success(profileResponse))
//                    } else {
//                        // Handle any server-specific errors
//                        let decodingError = NSError(domain: "ProfileError", code: profileResponse.status ?? 000, userInfo: [NSLocalizedDescriptionKey: profileResponse.message ?? "Unknown error."])
//                        self.delegate?.customerProfile(with: .failure(decodingError))
//                    }
//                } catch {
//                    print("Decoding error: \(error.localizedDescription)")
//                    self.delegate?.customerProfile(with: .failure(error))
//                }
//            }
//            task.resume()
//        } catch {
//            print("Error serializing JSON: \(error.localizedDescription)")
//            self.delegate?.customerProfile(with: .failure(error))
//        }
//    }
//
//}
