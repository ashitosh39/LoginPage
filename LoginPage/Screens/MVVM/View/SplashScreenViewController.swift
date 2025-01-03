//
//  LounchScreenViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 19/11/24.
//

import UIKit
class SplashScreenViewController: UIViewController {

    var userDetailViewModel: UserDetailsViewModel?
    var userDetailsModelResult : UserDetailsModelResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.userDetailViewModel = UserDetailsViewModel()
        self.userDetailViewModel?.delegate = self
        redirectUI()
    }

    func redirectUI(){
        if UserDefaults.standard.string(forKey: "token") != nil , let customerID = UserDefaults.standard.value(forKey: "customerID") {
                self.userDetailViewModel?.getUserDetails()
            
        } else {
            print("Token not found")
            // Redirect to login page
            DispatchQueue.main.async{
                if let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.navigationController?.pushViewController(LoginViewController, animated: true)
                }
            }
        }
    }


    func checkUserNew(){
        print("customerID...",UserDefaults.standard.value(forKey: "customerID"))
        if userDetailsModelResult?.customerFirstName?.lowercased() == "humpy" || self.userDetailsModelResult?.customerLastName?.lowercased() == "customer" {
//         if userDetailsModelResult?.customerFirstName == "Humpy" && userDetailsModelResult?.customerLastName == "Customer" {

             
                // redirect to updateProfileViewController
                DispatchQueue.main.async{
                    if let upv = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController {
                        
                        upv.userdata = self.userDetailsModelResult
                        self.navigationController?.pushViewController(upv, animated: true)
                    }
                }
        }else if UserDefaults.standard.value(forKey: "warehouseID") != nil{
            DispatchQueue.main.async{
                if let dashBoard = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardScreenViewController") as? DashBoardScreenViewController {
                    self.navigationController?.pushViewController(dashBoard, animated: true)
                }
            }
        }else{
            // redirect to Home Page
            DispatchQueue.main.async{
                if let selectCity = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? SelectCityViewController {
                    self.navigationController?.pushViewController(selectCity, animated: true)
                }
            }

        }
        


    }

}


extension SplashScreenViewController: UserDetailsModelDelegate {
    func userDataFetch(with result: Result<UserDetailsModel, any Error>) {
        switch result {
        case .success(let data):
            self.userDetailsModelResult = data.userDetailsModelResult
            self.checkUserNew()
            DispatchQueue.main.async {
                let alertSecond = UIAlertController(title: "Success", message: "User data fetched successfully", preferredStyle: .alert)
                alertSecond.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertSecond, animated: true, completion: nil)
            }
        case .failure(let error):
            print("Request error: \(error)")
        }
    }
}





 



