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

    func customerProfile(firstName: String, lastName: String, email: String) {
        let parameters: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]

        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: URL(string: "https://uat-api.humpyfarms.com/api/customers/saveCustomerProfileInfo")!, timeoutInterval: 30.0)
            request.httpMethod = "POST"
            request.setValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData

            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.delegate?.customerProfile(with: .failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Error: Invalid response")
                    self.delegate?.customerProfile(with: .failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                    return
                }

                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    let serverError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to connect to the server."])
                    self.delegate?.customerProfile(with: .failure(serverError))
                    return
                }

                guard let data = data, !data.isEmpty else {
                    print("Error: Received empty or nil data")
                    let emptyDataError = NSError(domain: "EmptyData", code: -2, userInfo: [NSLocalizedDescriptionKey: "Received empty or nil data."])
                    self.delegate?.customerProfile(with: .failure(emptyDataError))
                    return
                }

                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }

                do {
                    // Assuming the response model for saving customer profile is `CustomerProfile`
                    let profileResponse = try JSONDecoder().decode(Customer.self, from: data)
                    if profileResponse.status == 200 {
                        self.delegate?.customerProfile(with: .success(profileResponse))
                    } else {
                        let decodingError = NSError(domain: "ProfileError", code: profileResponse.status ?? 000, userInfo: [NSLocalizedDescriptionKey: profileResponse.message ?? "Unknown error."])
                        self.delegate?.customerProfile(with: .failure(decodingError))
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    self.delegate?.customerProfile(with: .failure(error))
                }
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            self.delegate?.customerProfile(with: .failure(error))
        }
    }
}




//import Foundation
//
//// Delegate Protocol for Customer Profile Updates
//protocol CustomerProfileInfo: AnyObject {
//    func customerProfile(with result: Result<Customer, Error>)
//}
//
//// ViewModel for Customer Profile
//class CustomerProfileViewModel {
//    weak var delegate: CustomerProfileInfo?
//
//    init(delegate: CustomerProfileInfo? = nil) {
//        self.delegate = delegate
//    }
//
//    // Method to send customer profile information
//    func customerProfile(firstName: String, lastName: String, email: String) {
//        let parameters: [String: Any] = [
//            "firstName": firstName,
//            "lastName": lastName,
//            "email": email
//        ]
//
//        // Serializing JSON data
//        do {
//            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            
//            // Setting up URLRequest
//            guard let url = URL(string: "https://uat-api.humpyfarms.com/api/customers/saveCustomerProfileInfo") else {
//                print("Error: Invalid URL")
//                return
//            }
//            var request = URLRequest(url: url, timeoutInterval: 30.0)
//            request.httpMethod = "POST"
//            request.setValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "Accept")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = postData
//
//            // Perform the network request
//            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//                guard let self = self else { return }
//
//                // Error handling for network issues
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                    self.delegate?.customerProfile(with: .failure(error))
//                    return
//                }
//
//                // Ensure valid HTTP response
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    let responseError = NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
//                    self.delegate?.customerProfile(with: .failure(responseError))
//                    return
//                }
//
//                // Handle non-200 status codes
//                if httpResponse.statusCode != 200 {
//                    let serverError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with HTTP status code \(httpResponse.statusCode)"])
//                    self.delegate?.customerProfile(with: .failure(serverError))
//                    return
//                }
//
//                // Handle empty or nil data
//                guard let data = data, !data.isEmpty else {
//                    let emptyDataError = NSError(domain: "EmptyData", code: -2, userInfo: [NSLocalizedDescriptionKey: "Received empty or nil data."])
//                    self.delegate?.customerProfile(with: .failure(emptyDataError))
//                    return
//                }
//
//                // Debug: Print raw response data
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("Response Data: \(responseString)")
//                }
//
//                // Decode response data
//                do {
//                    let profileResponse = try JSONDecoder().decode(Customer.self, from: data)
//
//                    // Assuming 'status' is the key that tells whether the response is successful
//                    if profileResponse.status == 200 {
//                        self.delegate?.customerProfile(with: .success(profileResponse))
//                    } else {
//                        let profileError = NSError(domain: "ProfileError", code: profileResponse.status ?? 000, userInfo: [NSLocalizedDescriptionKey: profileResponse.message ?? "Unknown error"])
//                        self.delegate?.customerProfile(with: .failure(profileError))
//                    }
//                } catch {
//                    print("Decoding Error: \(error.localizedDescription)")
//                    self.delegate?.customerProfile(with: .failure(error))
//                }
//            }
//            task.resume()
//
//        } catch {
//            // Error in JSON serialization
//            print("Error serializing JSON: \(error.localizedDescription)")
//            self.delegate?.customerProfile(with: .failure(error))
//        }
//    }
//}
