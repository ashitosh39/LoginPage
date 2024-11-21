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
        self.userDetailViewModel = UserDetailsViewModel()
        self.userDetailViewModel?.delegate = self
        redirectUI()
    }

    func redirectUI(){
        if let token = UserDefaults.standard.string(forKey: "token"){
            if let userData = UserDefaults.standard.value(forKey: "userData") as? UserDetailsModelResult{
                self.userDetailsModelResult = userData
                checkUserNew()
            }else {
                print("UserData not found")
                //call get  userdetails Api
                self.userDetailViewModel?.getUserDetails()
            }
        }else {
            print("Token not found")
            //redirect to login page
            self.navigationController?.pushViewController(LoginViewController(), animated: true)

        }
    }

    func checkUserNew(){
        if self.userDetailsModelResult?.customerFirstName == "Humpy" && self.userDetailsModelResult?.customerLastName == "Customer"{
            // redirect to updateProfileViewController
            self.navigationController?.pushViewController(UpdateProfileViewController(), animated: true)

        }else{
            // redirect to Home Page
            self.navigationController?.pushViewController(HomeViewViewController(), animated: true)

        }
    }

}

extension SplashScreenViewController: UserDetailsModelDelegate{
    func userDataFetch(with result: Result<UserDetailsModel, any Error>) {
        switch result {
        case .success(let data):
            if let userData = data.result {
                UserDefaults.standard.set(userData, forKey: "userData")
                self.userDetailsModelResult = userData
                self.checkUserNew()
            }
            DispatchQueue.main.async {
                let alertSecond = UIAlertController(title: "Success", message: "User data fetched successfully", preferredStyle: .alert)
                alertSecond.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertSecond, animated: true, completion: nil)
            }

        case .failure(let error):
            printContent("requast error: \(error)")

        }
    }


}


//import UIKit
//
//class SplashScreenViewController: UIViewController {
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
//            if let userData = UserDefaults.standard.value(forKey: "userData") as? UserDetailsModelResult{
//                self.userDetailsModelResult = userData
//                checkUserNew()
//            } else {
//                print("UserData not found")
//                // Call get userdetails API
//                self.userDetailViewModel?.getUserDetails()
//            }
//        } else {
//            print("Token not found")
//            // Redirect to login page
//            self.navigateToLoginPage()
//        }
//    }
//    
//    func checkUserNew(){
//        guard let userDetails = self.userDetailsModelResult else { return }
//        
//        if userDetails.customerFirstName == "Humpy" && userDetails.customerLastName == "Customer" {
//            // Redirect to UpdateProfileViewController
//            navigateToUpdateProfilePage()
//        } else {
//            // Redirect to Home Page
//            navigateToHomePage()
//        }
//    }
//    
//    // Navigation functions
//    func navigateToLoginPage() {
//        DispatchQueue.main.async {
//            let loginVC = LoginViewController()
//            self.navigationController?.pushViewController(loginVC, animated: true)
//        }
//    }
//    
//    func navigateToUpdateProfilePage() {
//        DispatchQueue.main.async {
//            let updateProfileVC = UpdateProfileViewController()
//            self.navigationController?.pushViewController(updateProfileVC, animated: true)
//        }
//    }
//    
//    func navigateToHomePage() {
//        DispatchQueue.main.async {
//            let homeVC = HomeViewViewController()
//            self.navigationController?.pushViewController(homeVC, animated: true)
//        }
//    }
//}
//
//extension SplashScreenViewController: UserDetailsModelDelegate {
//    func userDataFetch(with result: Result<UserDetailsModel, any Error>) {
//        switch result {
//        case .success(let data):
//            if let userData = data.result {
//                UserDefaults.standard.set(userData, forKey: "userData")
//                self.userDetailsModelResult = userData
//                self.checkUserNew()
//            }
//            
//            // Make sure UIAlertController is presented on the main thread
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "Success", message: "User data fetched successfully", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//            
//        case .failure(let error):
//            print("Request error: \(error)")
//        }
//    }
//}
//
//
//
//
//
