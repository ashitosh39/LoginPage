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
    var wareHouseDataViewModel: WareHouseDataViewModel?
    var house : House?
    
            
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
                    showAlert(message: "Please select a city to proceed.")
                    return
                }
        let selectedCity = results[selectedCityIndex.row]
                
                // Fetch the warehouse data for the selected city
        fetchWareHouseData(forCity: selectedCity)
           
    }

           
        }
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "City Select", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           
        }
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



