//
//  HomeViewViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 19/11/24.
//

import UIKit
import Kingfisher
class SelectCityViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var selectCityTableView: UITableView!
    
    @IBOutlet weak var proceedButton: UIButton!
    
    var selectCityViewModel: SelecteCityViewModel?
    var results = [Results]()  // Store the array of Results (Cities)
  
    var selectedCityIndex: IndexPath? // Store the selected row's index path
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCityViewModel = SelecteCityViewModel(delegate: self)
        selectedCityIndex = nil
            // Start fetching cities
        selectCityViewModel?.cityData()
            
            selectCityTableView.delegate = self
            selectCityTableView.dataSource = self
        registerXIBWithTableView()
    }
    func registerXIBWithTableView() {
        let nib = UINib(nibName: "SelectCityTableViewCell", bundle: nil)
        self.selectCityTableView.register(nib, forCellReuseIdentifier: "SelectCityTableViewCell")
    }
    func didReceiveCityData(_ cities: [Results]) {
            self.results = cities  // Update the city model data
            self.selectCityTableView.reloadData()  // Reload the table view with new data
        }
        
        // Delegate method to handle failure
        func didFailWithError(_ error: String) {
            // Handle the error (e.g., show an alert)
            print("Error: \(error)")
        }

    @IBAction func ProceedButton(_ sender: Any) {
        guard let selectedCityIndex = selectedCityIndex else {
                // If no city is selected, show an alert
                showAlert(message: "Please select a city to proceed.")
                return
            }

            // Get the selected city's ID (or index) - you need to update this based on your data model
            let selectedCity = results[selectedCityIndex.row]
        guard let cityId = selectedCity.cityID else {
                showAlert(message: "City ID is missing.")
                return
            }

            // Create the API URL with the city ID
            let urlString = "https://uat-api.humpyfarms.com/api/warehouse/getWarehouseByCity?city_id=\(cityId)"
            
            // Convert the URL string into a valid URL object
            guard let url = URL(string: urlString) else {
                showAlert(message: "Invalid URL.")
                return
            }

            // Create the URL request
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
            request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6MzU5MTUsImlhdCI6MTczNDk1ODA3MywiZXhwIjoxNzM1MzkwMDczfQ.JVsOcRjMRDuhAZmhSGsMRpEkHGHbZUUVPkgnb_OsxPk", forHTTPHeaderField: "Authorization")

            // HTTP Method
            request.httpMethod = "GET"  // Since you're using GET, no need to add httpBody here.

            // Perform the API call
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle network errors
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.showAlert(message: "Network error: \(error.localizedDescription)")
                    }
                    return
                }

                // Check if we got a response and valid data
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "No data received.")
                    }
                    return
                }

                // Attempt to parse the JSON response (Assuming the response is in JSON format)
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response: \(responseJSON)") // Log the response for debugging
                    // You can now handle the response here, such as updating the UI
                } catch {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Failed to parse response.")
                    }
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }

            // Start the network request
            task.resume()
        print("Proceed button tapped")
        }
//    func showAlert(message: String) {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: "City Fetching", message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    }
    
    




extension SelectCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return the number of rows in the table view (i.e., the number of cities)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count  // Return the number of cities
    }
    
    // Configure each table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityTableViewCell", for: indexPath) as! SelectCityTableViewCell
        
        let city = results[indexPath.row]
        
        // Bind city name to the label
        cell.cityNameLabel.text = city.cityName
        
        // Safely unwrap the optional cityImageURL
        if let imageUrlString = city.cityImageURL, let imageUrl = URL(string: imageUrlString) {
            cell.cityImage.kf.setImage(with: imageUrl)
        } else {
            cell.cityImage.image = UIImage(named: "defaultImage") // Use a default image if needed
        }
        
        // Set the selection state for the tick mark drawing
        cell.isSelectedCell = indexPath == selectedCityIndex

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if the tapped row is already selected
        if selectedCityIndex == indexPath {
            // If tapped on the same row, deselect it
            selectedCityIndex = nil
        } else {
            // Otherwise, select the new row
            selectedCityIndex = indexPath
        }

        // Reload the table to update the selection state
        tableView.reloadData()
    }

    
    // Optionally, set row height for a consistent layout
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.00
    }
}
extension SelectCityViewController: SelectCityViewModelDelegate {
    
    // Delegate method to handle the response from the ViewModel
    func selectCity(with result: Result<[Results], any Error>) {
        switch result {
        case .success(let cities):
            if cities.isEmpty {
                showAlert(message: "No cities found")
            } else {
                self.results = cities  // Update the city model data
                DispatchQueue.main.async {
                    self.selectCityTableView.reloadData()  // Reload the table view with the new data
                }
            }
        case .failure(let error):
            showAlert(message: "Failed to fetch cities: \(error.localizedDescription)")
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "City Fetching", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


//if you click on any row of the  tableview, thet row should be selected and a tick mark logo should appear on the right side of the image in that row
