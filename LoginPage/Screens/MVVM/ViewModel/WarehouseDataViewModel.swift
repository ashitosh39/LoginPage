//
//  WarehouseDataViewModel.swift
//  LoginPage
//
//  Created by Digitalflake on 23/12/24.


import Foundation

protocol WarehouseDataViewModelDelegate: AnyObject {
    func wareHouseDataFetched(with houseResult: Result<[WareHouse], Error>)  // Updated to pass an array of WareHouse
}

class WareHouseDataViewModel {
    weak var delegate: WarehouseDataViewModelDelegate?
    private var jsonDecoder: JSONDecoder!
    
    init(delegate: WarehouseDataViewModelDelegate? = nil) {
        self.delegate = delegate
        self.jsonDecoder = JSONDecoder()
    }
    
    // In the ViewModel (WarehouseDataViewModel)
    
    func fetchWareHouseData(forCityID cityID: Int) {
        // Construct the URL with cityId as a query parameter
        guard var urlComponents = URLComponents(string: "https://qa-api.humpyfarms.com/api/warehouse/getWarehouseByCity") else {
            print("Invalid URL")
            return
        }
        
        // Add the query parameter "cityId" to the URL
        urlComponents.queryItems = [URLQueryItem(name: "city_id", value: "\(cityID)")]
        
        // Ensure the final URL is valid
        guard let urlString = urlComponents.url else {
            print("Invalid URL with query parameters")
            return
        }
        // Fetch token from UserDefaults
        guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
            print("No token found in UserDefaults")
            return
        }
        
        var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        // Perform the API call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("Error: Invalid response status code")
                    return
                }
            }
            
            guard let data = data else {
                print("No data received from the server")
                return
            }
            
            // Print raw response data for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawString)")  // This will help us understand what the server is returning
            }
            
            // Attempt to parse the JSON response
            do {
                // Decode the response into a House object
                let decodedResponse = try self.jsonDecoder.decode(House.self, from: data)
                DispatchQueue.main.async {
                    if let wareHouses = decodedResponse.wareHouses, !wareHouses.isEmpty {
                        self.delegate?.wareHouseDataFetched(with: .success(wareHouses))
                    } else {
                        self.delegate?.wareHouseDataFetched(with: .failure(NSError(domain: "NoWareHouseData", code: 404, userInfo: nil)))
                    }
                }
            } catch let decodeError {
                print("Error decoding JSON: \(decodeError.localizedDescription)")
                DispatchQueue.main.async {
                    self.delegate?.wareHouseDataFetched(with: .failure(decodeError))
                }
            }
        }
        
        // Start the network request
        task.resume()
    }
    
}


//
//func fetchHouseData(forCityId cityId: Int) {
//    guard let urlString = URL(string: "https://qa-api.humpyfarms.com/api/warehouse/getWarehouseByCity?city_id=\(cityId)") else {
//        print("Invalid URL")
//        return
//    }
//
//    // Fetch token from UserDefaults
//    guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
//        print("No token found in UserDefaults")
//        return
//    }
//
//    var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
//    request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
//    request.setValue(token, forHTTPHeaderField: "Authorization")
//    request.httpMethod = "GET"
//
//    // Perform the API call
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//            DispatchQueue.main.async {
//                self.delegate?.wareHouseDataFetched(with: .failure(error))
//            }
//            return
//        }
//
//        if let httpResponse = response as? HTTPURLResponse {
//            if httpResponse.statusCode == 404 {
//                print("Error: No warehouse data found for city ID \(cityId).")
//                DispatchQueue.main.async {
//                    let error = NSError(domain: "NoWareHouseData", code: 404, userInfo: [NSLocalizedDescriptionKey: "No warehouse data found for the selected city."])
//                    self.delegate?.wareHouseDataFetched(with: .failure(error))
//                }
//                return
//            } else if httpResponse.statusCode != 200 {
//                print("Error: Invalid response status code \(httpResponse.statusCode).")
//                DispatchQueue.main.async {
//                    let error = NSError(domain: "InvalidStatusCode", code: httpResponse.statusCode, userInfo: nil)
//                    self.delegate?.wareHouseDataFetched(with: .failure(error))
//                }
//                return
//            }
//        }
//
//        guard let data = data else {
//            print("No data received from the server")
//            DispatchQueue.main.async {
//                let error = NSError(domain: "NoData", code: 404, userInfo: nil)
//                self.delegate?.wareHouseDataFetched(with: .failure(error))
//            }
//            return
//        }
//
//        // Print the raw response data for debugging
//        if let rawString = String(data: data, encoding: .utf8) {
//            print("Raw Response: \(rawString)")  // This will help us understand what the server is returning
//        }
//
//        // Attempt to parse the JSON response
//        do {
//            // Decode the response into a `House` object
//            let decodedResponse = try self.jsonDecoder.decode(House.self, from: data)
//            DispatchQueue.main.async {
//                if let wareHouses = decodedResponse.wareHouses, !wareHouses.isEmpty {
//                    self.delegate?.wareHouseDataFetched(with: .success(wareHouses))
//                } else {
//                    self.delegate?.wareHouseDataFetched(with: .failure(NSError(domain: "NoWareHouseData", code: 404, userInfo: nil)))
//                }
//            }
//        } catch let decodeError {
//            print("Error decoding JSON: \(decodeError.localizedDescription)")
//            DispatchQueue.main.async {
//                self.delegate?.wareHouseDataFetched(with: .failure(decodeError))
//            }
//        }
//    }
//
//    // Start the network request
//    task.resume()
//}
