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
        if UserDefaults.standard.string(forKey: "token") != nil {
            if let userData = UserDefaults.standard.data(forKey: "userDetails") {
                let decoder = JSONDecoder()
                if let decodedUserData = try? decoder.decode(UserDetailsModelResult.self, from: userData ) {
                    self.userDetailsModelResult = decodedUserData
                    checkUserNew()
                } else {
                    print("Failed to decode user data")
                    // Handle error
                }
            } else {
                print("UserData not found")
                // Call get user details API
                self.userDetailViewModel?.getUserDetails()
            }
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
        if self.userDetailsModelResult?.customerFirstName == "Humpy" && self.userDetailsModelResult?.customerLastName == "Customer"{
            // redirect to updateProfileViewController
            DispatchQueue.main.async{
                if let upv = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController {
                    
                    upv.userdata = self.userDetailsModelResult
                    self.navigationController?.pushViewController(upv, animated: true)
                }
            }

        }else{
            // redirect to Home Page
            DispatchQueue.main.async{
                self.navigationController?.pushViewController(HomeViewViewController(), animated: true)
            }

        }
    }

}
//
extension SplashScreenViewController: UserDetailsModelDelegate {
    func userDataFetch(with result: Result<UserDetailsModel, any Error>) {
        switch result {
        case .success(let data):
            if let userData = data.result {
                
                do {
                    let encoder = JSONEncoder()
                    let encodedData = try encoder.encode(self.userDetailsModelResult)
                    UserDefaults.standard.set(encodedData, forKey: "userDetails")
                    self.userDetailsModelResult = userData
                    self.checkUserNew()
                    DispatchQueue.main.async {
                        let alertSecond = UIAlertController(title: "Success", message: "User data fetched successfully", preferredStyle: .alert)
                        alertSecond.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertSecond, animated: true, completion: nil)
                    }
                } catch {
                    print("Failed to encode user data: \(error)")
                }
                
            }
            

        case .failure(let error):
            print("Request error: \(error)")
        }
    }
}
//
//    
    
    //    var userDetailViewModel: UserDetailsViewModel?
    //    var userDetailsModelResult : UserDetailsModelResult?
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        self.userDetailViewModel = UserDetailsViewModel()
    //        self.userDetailViewModel?.delegate = self
    //        redirectUI()
    //    }
    //
    //    func redirectUI(){
    //        if UserDefaults.standard.string(forKey: "token") != nil{
    //            if let userData = UserDefaults.standard.value(forKey: "userDetails") as? UserDetailsModelResult{
    //                self.userDetailsModelResult = userData
    //                checkUserNew()
    //            } else {
    //                self.userDetailViewModel?.getUserDetails()
    //            }
    //        }
    //    }
    //    func checkUserNew(){
    //        if ((self.userDetailsModelResult?.isNew!) != nil) == true{
    //            self.performSegue(withIdentifier: "toNewUser", sender: nil)
    //        } else {
    //            self.performSegue(withIdentifier: "toUser", sender: nil)
    //        }
    //    }
    //}
    //
    //extension SplashScreenViewController: UserDetailsModelDelegate{
    //    func userDataFetch(with result: Result<UserDetailsModel, any Error>) {
    //        switch result {
    //        case .success(let data):
    //            if let userData = data.result {
    //                UserDefaults.standard.set(userData, forKey: "userDetails")
    //                self.userDetailsModelResult = userData
    //                self.checkUserNew()
    //            }
    //            DispatchQueue.main.async {
    //                let alertSecond = UIAlertController(title: "Success", message: "User data fetched successfully", preferredStyle: .alert)
    //                alertSecond.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    //                self.present(alertSecond, animated: true, completion: nil)
    //            }
    //
    //        case .failure(let error):
    //            printContent("requast error: \(error)")
    //
    //        }
    //    }
    //}
  
    
