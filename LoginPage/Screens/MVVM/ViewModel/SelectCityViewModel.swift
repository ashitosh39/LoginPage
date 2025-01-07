//
//  SelectCityViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import Foundation
import UIKit

protocol SelectCityViewModelDelegate: AnyObject {
    // Expect an array of 'Results' (cities)
    func selectCity(with result: Result<[CitiesResults], Error>)
}

class SelectCityViewModel {
    weak var delegate: SelectCityViewModelDelegate?
    private var jsonDecoder: JSONDecoder!
    
    init(delegate: SelectCityViewModelDelegate? = nil) {
        self.delegate = delegate
        self.jsonDecoder = JSONDecoder() // Initialize the JSONDecoder
    }
    
    func cityData() {
        guard let url = URL(string: "https://uat-api.humpyfarms.com/api/cities/ActiveCities") else {
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
    
