//
//  UserDetailsViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import Foundation
import UIKit

protocol UserDetailsModelDelegate: AnyObject {
    func userDataFetch(with result: Result<UserDetailsModel, Error>)
    
}

class UserDetailsViewModel {
    
    weak var delegate: UserDetailsModelDelegate?
    init(delegate: UserDetailsModelDelegate? = nil) {
        self.delegate = delegate
       
    }
    func getUserDetails() {
        // Ensure the base URL is valid
        guard let customerId = UserDefaults.standard.value(forKey: "customerID") as? Int else{
            return
        }
        let token = UserDefaults.standard.value(forKey: "token")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let userAgent: String = "iOS" + "/" + appVersion + "/" + UIDevice.current.systemVersion
        
        guard let url = URL(string: "https://qa-api.humpyfarms.com/api/customers/getCustomerDetails") else {
            print("Invalid URL")
            return
        }
        
        // Create the URLComponents and add the query parameter
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "customer_id", value: "\(customerId)")
        ]
        
        guard let finalUrl = components?.url else {
            print("Failed to construct the URL with query parameters")
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: finalUrl)
        request.setValue(token as? String, forHTTPHeaderField: "Authorization")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.httpMethod = "GET" // GET request doesn't need a body
        
        // Perform the network request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // Handle error
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.delegate?.userDataFetch(with: .failure(error))
                return
            }
            
            // Ensure data is not nil
            guard let data = data else {
                print("No data received")
                let emptyDataError = NSError(domain: "EmptyData", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received."])
                self.delegate?.userDataFetch(with: .failure(emptyDataError))
                return
            }
            
            // Print the raw response for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawString)")
            }
            
            // Try to decode the response data
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserDetailsModel.self, from: data)
                
                // Check if the response status is 200 and process the data
                if userData.status == 200, let user = userData.userDetailsModelResult {
                    self.delegate?.userDataFetch(with: .success(userData))
                } else {
                    let serverError = NSError(domain: "ServerError", code: userData.status ?? 0, userInfo: [NSLocalizedDescriptionKey: userData.message ?? "Unknown error"])
                    self.delegate?.userDataFetch(with: .failure(serverError))
                }
            } catch let decodeError {
                print("Error decoding JSON: \(decodeError.localizedDescription)")
                self.delegate?.userDataFetch(with: .failure(decodeError))
            }
        }
        
        // Start the task
        task.resume()
    }

}
