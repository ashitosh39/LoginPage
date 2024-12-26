//
//  SelecteCityViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 20/12/24.
//

//
import Foundation
import UIKit

protocol SelectCityViewModelDelegate: AnyObject {
    // Expect an array of 'Results' (cities)
    func selectCity(with result: Result<[Results], Error>)
}

class SelectCityViewModel {
    weak var delegate: SelectCityViewModelDelegate?
    private var jsonDecoder: JSONDecoder!
    
    init(delegate: SelectCityViewModelDelegate? = nil) {
        self.delegate = delegate
        self.jsonDecoder = JSONDecoder() // Initialize the JSONDecoder
    }
    
    func cityData() {
        guard let url = URL(string: "https://uat-api.humpyfarms.com/api/cities/ActiveCities?city_id=1") else {
            print("Invalid URL")
            return
        }
        let token = UserDefaults.standard.string(forKey: "token")
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Check the response status code
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("Error: Invalid response status code.")
                    return
                }
            }
            //                if let httpResponse = response as? HTTPURLResponse {
            //                    print("HTTP Status Code: \(httpResponse.statusCode)")
            //                    if httpResponse.statusCode == 401 {
            //                        if let data = data, let errorResponse = String(data: data, encoding: .utf8) {
            //                            print("Unauthorized Response: \(errorResponse)")
            //                        }
            //                    }
            //                }
            
            
            guard let data = data else {
                print("No data received.")
                return
            }
            
            // Log the raw response for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawString)")
            }
            
            do {
                // Decode the response into a CityModel
                let decodedResponse = try self.jsonDecoder.decode(CityModel.self, from: data)
                
                // Check if result is available and notify the delegate
                if let result = decodedResponse.result {
                    DispatchQueue.main.async {
                        // Call the delegate method to pass back the cities
                        self.delegate?.selectCity(with: .success(result))
                    }
                } else {
                    print("No city data found.")
                    // Call the delegate with an error if no result
                    DispatchQueue.main.async {
                        self.delegate?.selectCity(with: .failure(NSError(domain: "No city data", code: 404, userInfo: nil)))
                    }
                }
            } catch let decodeError {
                print("Error decoding JSON: \(decodeError.localizedDescription)")
                // Call the delegate with the error
                DispatchQueue.main.async {
                    self.delegate?.selectCity(with: .failure(decodeError))
                }
            }
        }
        
        task.resume()
    }
    
}
    


//without token


//import Foundation
//import UIKit
//
//// Define a protocol for the delegate to handle the result of the city request
//protocol SelectCityViewModelDelegate: AnyObject {
//    func selectCity(with result: Result<[Results], Error>)
//}
//
//class SelectCityViewModel {
//    weak var delegate: SelectCityViewModelDelegate?
//    private var jsonDecoder: JSONDecoder!
//
//    init(delegate: SelectCityViewModelDelegate? = nil) {
//        self.delegate = delegate
//        self.jsonDecoder = JSONDecoder() // Initialize the JSONDecoder
//    }
//
//    func cityData() {
//        // Ensure the URL is valid
//        guard let url = URL(string: "https://uat-api.humpyfarms.com/api/cities/ActiveCities?city_id=1") else {
//            print("Invalid URL")
//            return
//        }
//
//        // Create the request
//        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
//        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent") // Add the User-Agent header
//        request.addValue("application/json", forHTTPHeaderField: "Accept") // Add Accept header
//        // If an API key or token is required, add it like this:
//        // request.addValue("Bearer YOUR_ACCESS_TOKEN", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET" // Set the HTTP method to GET
//
//        // Make the network request
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            // Handle error if any
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.delegate?.selectCity(with: .failure(error))
//                }
//                return
//            }
//
//            // Check HTTP response status code
//            if let httpResponse = response as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                
//                // Handle forbidden response (403)
//                if httpResponse.statusCode == 403 {
//                    print("Error: Forbidden access (403)")
//                    let statusError = NSError(domain: "API Error", code: 403, userInfo: nil)
//                    DispatchQueue.main.async {
//                        self.delegate?.selectCity(with: .failure(statusError))
//                    }
//                    return
//                }
//
//                // Handle other error responses
//                if httpResponse.statusCode != 200 {
//                    print("Error: Invalid response status code.")
//                    let statusError = NSError(domain: "API Error", code: httpResponse.statusCode, userInfo: nil)
//                    DispatchQueue.main.async {
//                        self.delegate?.selectCity(with: .failure(statusError))
//                    }
//                    return
//                }
//            }
//
//            // Ensure data was received
//            guard let data = data else {
//                print("No data received.")
//                let dataError = NSError(domain: "Data Error", code: 404, userInfo: nil)
//                DispatchQueue.main.async {
//                    self.delegate?.selectCity(with: .failure(dataError))
//                }
//                return
//            }
//
//            // Log the raw response for debugging
//            if let rawString = String(data: data, encoding: .utf8) {
//                print("Raw Response: \(rawString)")
//            }
//
//            // Decode the response into the model
//            do {
//                let decodedResponse = try self.jsonDecoder.decode(CityModel.self, from: data)
//
//                // Check if result is available and return
//                if let result = decodedResponse.result {
//                    DispatchQueue.main.async {
//                        self.delegate?.selectCity(with: .success(result))
//                    }
//                } else {
//                    print("No city data found.")
//                    let noDataError = NSError(domain: "No City Data", code: 404, userInfo: nil)
//                    DispatchQueue.main.async {
//                        self.delegate?.selectCity(with: .failure(noDataError))
//                    }
//                }
//            } catch let decodeError {
//                print("Error decoding JSON: \(decodeError.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.delegate?.selectCity(with: .failure(decodeError))
//                }
//            }
//        }
//
//        task.resume() // Start the request
//    }
//}

    
    
    
    
    
    
    
    
    
    









    
//    func cityData() {
//        guard let url = URL(string: "https://uat-api.humpyfarms.com/api/cities/ActiveCities?city_id=1") else {
//            print("Invalid URL")
//            return
//        }
//        
//        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
//        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
//        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6MzU5MTUsImlhdCI6MTczNTE5MDA4NiwiZXhwIjoxNzM1NjIyMDg2fQ.lca109n1TD5EtnHcD_2dXrfkvj2OAHIdBStH5wURc9o", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//            
//            // Check the response status code
//            if let httpResponse = response as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                
//                if httpResponse.statusCode == 401 {
//                    print("Unauthorized request. Please check your API token.")
//                    return
//                }
//                
//                if httpResponse.statusCode != 200 {
//                    print("Error: Invalid response status code.")
//                    return
//                }
//            }
//            
//            guard let data = data else {
//                print("No data received.")
//                return
//            }
//            
//            do {
//                // Decode the response into a CityModel
//                let decodedResponse = try self.jsonDecoder.decode(CityModel.self, from: data)
//                
//                if let result = decodedResponse.result {
//                    DispatchQueue.main.async {
//                        self.delegate?.selectCity(with: .success(result))
//                    }
//                } else {
//                    print("No city data found.")
//                    DispatchQueue.main.async {
//                        self.delegate?.selectCity(with: .failure(NSError(domain: "No city data", code: 404, userInfo: nil)))
//                    }
//                }
//            } catch let decodeError {
//                print("Error decoding JSON: \(decodeError.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.delegate?.selectCity(with: .failure(decodeError))
//                }
//            }
//        }
//        
//        task.resume()
//    }

    

