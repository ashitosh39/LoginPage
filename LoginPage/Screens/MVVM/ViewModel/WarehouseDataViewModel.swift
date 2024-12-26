//
//  WarehouseDataViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 23/12/24.
//

import Foundation


protocol WarehouseDataViewModelDelegate: AnyObject {
    func wareHouseDataFetched(with result: Result<[House], Error>)
}
class WareHouseDataViewModel {
    weak var delegate: WarehouseDataViewModelDelegate?
    init(delegate: WarehouseDataViewModelDelegate? = nil) {
        self.delegate = delegate
    }
}
func fetchWareHouseData(forCity selectedCity: Results) {
    guard let cityId = selectedCity.cityID else {
        print("No City ID available")
        return
    }

    // Construct the URL string with the city ID
    let urlString = "https://uat-api.humpyfarms.com/api/warehouse/getWarehouseByCity?city_id=\(cityId)"
    
    // Convert the URL string into a URL object
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    let token = UserDefaults.standard.string(forKey: "token")
    // Create the URLRequest
    var request = URLRequest(url: url, timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
    request.setValue(token, forHTTPHeaderField: "Authorization")

    // HTTP Method
    request.httpMethod = "GET"
    
    // Perform the API call
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Handle network errors
        if let error = error {
            print("Error: \(error.localizedDescription)")
            DispatchQueue.main.async {
             
            }
            return
        }
        
        // Check if we got a response and valid data
        guard let data = data else {
            DispatchQueue.main.async {
                print("No data recived from the server")
            }
            return
        }
        
        // Attempt to parse the JSON response
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
            print("Response: \(responseJSON)") // Log the response for debugging
        
         
        } catch {
          
            print("Error parsing JSON: \(error.localizedDescription)")
            
            print("Error parsing data from the server")
        }
    }
    
    // Start the network request
    task.resume()
}
