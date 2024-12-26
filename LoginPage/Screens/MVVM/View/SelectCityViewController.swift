//
//  HomeViewViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 19/11/24.
//

import UIKit
import Kingfisher
class SelectCityViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var selectCityCollectionView: UICollectionView!
    
   
    @IBOutlet weak var proceedButton: UIButton!
    
    var selectCityViewModel: SelectCityViewModel?
    var results : [Results] = []  // Store the array of Results (Cities)
  
    var selectedCityIndex: IndexPath? // Store the selected row's index path
    var wareHouseDataViewModel: WareHouseDataViewModel?
    var house : House?
    
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCityViewModel = SelectCityViewModel(delegate: self)
        selectedCityIndex = nil
            // Start fetching cities
        selectCityViewModel?.cityData()
            
        selectCityCollectionView.delegate = self
        selectCityCollectionView.dataSource = self
        
        registerXIBWithTableView()
    }
    func registerXIBWithTableView() {
        let nib = UINib(nibName: "SelectCityCollectionViewCell", bundle: nil)
        self.selectCityCollectionView.register(nib, forCellWithReuseIdentifier: "SelectCityCollectionViewCell")
    }
//    func didReceiveCityData(_ cities: [Results]) {
//            self.results = cities  // Update the city model data
//            self.selectCityTableView.reloadData()  // Reload the table view with new data
//        }
//        
//        // Delegate method to handle failure
//        func didFailWithError(_ error: String) {
//            // Handle the error (e.g., show an alert)
//            print("Error: \(error)")
//        }

    @IBAction func ProceedButton(_ sender: Any) {
        guard let selectedCityIndex = selectedCityIndex else {
                    showAlert(message: "Please select a city to proceed.")
                    return
                }
        let selectedCity = results[selectedCityIndex.row]
                
                // Fetch the warehouse data for the selected city
        fetchWareHouseData(forCity: selectedCity)
        
        DispatchQueue.main.async {
            if let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardScreenViewController") as? DashBoardScreenViewController {
                self.navigationController?.pushViewController(dashboardVC, animated: true)
            }
        }
           
    }

           
        }
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "City Select", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           
        }
    }

extension SelectCityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCityCollectionViewCell", for: indexPath) as! SelectCityCollectionViewCell
        
        let city = results[indexPath.row]
        
        cell.cityNameLabel.text = city.cityName
        
        
        if let imageurlString = city.cityImageURL, let imageUrl = URL(string: imageurlString) {
            cell.cityImage.kf.setImage(with: imageUrl)
        }else {
            cell.cityImage.image = UIImage(named: "defaultImage")
        }
        
        cell.isSelectedCell = indexPath == selectedCityIndex
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCityIndex == indexPath {
            selectedCityIndex = nil
        }else{
            selectedCityIndex = indexPath
        }
        collectionView.reloadData()
    }

//    func collectionView(_ collectionView: UICollectionView,heightForItemAt indexPath: IndexPath) -> CGFloat {
//        return 180.00
//    }

   
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//                let width = (selectCityCollectionView.frame.width)/2
//                let height = 100.0
//                return CGSize(width: width, height: height)
//            
//            }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                if collectionView == selectCityCollectionView {
                    return CGSize(width: 112, height: 158) // Collection View size right?
                }
                else {
                    return CGSize(width: 0, height: 0)
                }

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
                    self.selectCityCollectionView.reloadData()  // Reload the table view with the new data
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

extension SelectCityViewController: WarehouseDataViewModelDelegate {
    func wareHouseDataFetched(with houseResult: Result<[House], any Error>) {
        switch houseResult {
            case .success(let houses):
            if let wareHouseData = houses.first {
                if let warehousesID = wareHouseData.warehouseID {
                    UserDefaults.standard.set(warehousesID, forKey: "warehouseID")
                    print("warehouseID Id save successfully : \(warehousesID)")
                }
                let alert = UIAlertController(title: "No Warehouses Found", message: "Please try again later", preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "OK", style: .default))
                               present(alert, animated: true)
                           }
            
            if houses.isEmpty {

                let alert = UIAlertController(title: "No Warehouses Found", message: "Please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        case .failure(let error):
            showAlert(message: "failed to fetch warehouses: \(error.localizedDescription)")
        }
    }
}

