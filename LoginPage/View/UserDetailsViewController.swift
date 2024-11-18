//
//  UserDetailsViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 18/11/24.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    
    var userData : UserDetailsModel?
    
    override func viewDidLoad() {
     
        getUserDetails()
        
       
        
    }
    
    
    func getUserDetails() {
        // Ensure the base URL is valid
        let customerId = UserDefaults.standard.integer(forKey: "customerID")
        let token = UserDefaults.standard.string(forKey: "token")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let userAgent: String = "iOS"+"/"+appVersion+"/" + UIDevice.current.systemVersion
                
                
        guard let url = URL(string: "https://uat-api.humpyfarms.com/api/customers/getCustomerDetails") else {
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
        
        var request = URLRequest(url: finalUrl)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.httpMethod = "GET" // GET request doesn't need a body
        
        // Perform the network request
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Ensure data is not nil
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Print the raw response for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawString)")
            }
            
            // Try to decode the response data
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(UserDetailsModel.self, from: data)
                
                self.userData = decodedResponse // Store the decoded user data
                print("Successfully parsed user details: \(String(describing: self.userData))")
                UserDefaults.standard.set(self.userData?.result, forKey: "userData")
            } catch let decodeError {
                print("Error decoding JSON: \(decodeError.localizedDescription)")
            }
        }
        
        // Start the task
        task.resume()
        
    }
    
}








//        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
//        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6MzUyMjUsImlhdCI6MTczMTY2MzIzMywiZXhwIjoxNzMyMDk1MjMzfQ.gBjZnjzrc9mRuSCBzUA4SN_CdofJAYFki9WGzTx1QhE", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            // Check for errors
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received.")
//                return
//            }
//
//            // Print the raw data to inspect the response format
//            if let rawString = String(data: data, encoding: .utf8) {
//                print("Raw Response: \(rawString)")
//            }
//
//            // Parse the response using JSONDecoder
//            do {
//                let decodedResponse = try self?.jsonDecoder?.decode([UserDetailsModel].self, from: data)
//                if let decodedResponse = decodedResponse {
//                    DispatchQueue.main.async {
//                        self?.user = decodedResponse
//                        // You can now update the UI with the `user` array.
//                        print("Successfully parsed user data: \(decodedResponse)")
//                    }
//                }
//            } catch let decodeError {
//                print("Error decoding JSON: \(decodeError.localizedDescription)")
//            }
//        }
//
//        task.resume()
//    }

//
