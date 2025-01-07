//
//  UpdateProfileViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//
//9588664712
import UIKit

class UpdateProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var refrelCodeView: UIView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var referralCodeVerify: UIView!
    
    
//    var referralCodeViewModel : ReferralCodeViewModel?
    var referralCodeViewModel: ReferralCodeViewModel!
//    var refferalResult: ReferralResult?
    var userdata: UserDetailsModelResult?
    //    var customer = [Customer].self
    var customerProfileViewModel : CustomerProfileViewModel?
    var customerDatails : CustomerDetails?
    var originalViewYPosition: CGFloat = 0
    var verifiedReferral : String?
    var userDetailsModel : UserDetailsModel?
    var userDetailsViewModel : UserDetailsViewModel?
    var userDetailsModelResult : UserDetailsModelResult?
    var referralCode : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDetailsViewModel = UserDetailsViewModel()
        self.userDetailsViewModel?.delegate = self
        
//        self.userDetailsViewModel?.getUserDetails()
        
        referralCodeViewModel = ReferralCodeViewModel(delegate: self)
        self.navigationItem.hidesBackButton = true
        
        customerProfileViewModel = CustomerProfileViewModel()
        self.customerProfileViewModel?.delegate = self
        
        let isRefferalScreen = UserDefaults.standard.bool(forKey: "isRefferalScreen")
        refrelCodeView.isHidden = true
        //         Use if-else statement to show/hide refrelCodeView
        if isRefferalScreen{
            refrelCodeView.isHidden = false  // Hide the referral code view when isRefferalScreen is true
            
        }else{
            refrelCodeView.isHidden = true // Show the referral code view when isRefferalScreen is false
        }
        
        
        // Populate user details if available
        if let userDetails = userdata {
            firstName.text = userDetails.customerFirstName ?? ""
            lastName.text = userDetails.customerLastName ?? ""
            email.text = userDetails.email ?? ""
        }
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        //                refralCode.delegate = self
        
        originalViewYPosition = self.view.frame.origin.y
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // This is called when the text field is tapped, the keyboard should automatically open.
        self.originalViewYPosition
    }
    deinit {
        // Remove observers when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    // Handle keyboard will show notification
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            // Move the view up by the height of the keyboard
            let keyboardHeight = keyboardFrame.height + 30
            
            // Check if the text field is going to be hidden behind the keyboard
            if let mobileTextFieldYPosition = firstName.superview?.convert(firstName.frame.origin, to: self.view).y {
                let spaceBelowTextField = self.view.frame.height - mobileTextFieldYPosition - firstName.frame.height
                
                // Only move the view if the text field is behind the keyboard
                if spaceBelowTextField < keyboardHeight {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame.origin.y = self.originalViewYPosition - (keyboardHeight - spaceBelowTextField)
                    }
                }
            }
        }
    }
    func addDoneButtonOnKeyboard(to textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [doneButton]
        textField.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction() {
        view.endEditing(true)  // Dismiss the keyboard
    }
    
    // Handle keyboard will hide notification
    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset the view position when the keyboard hides
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = self.originalViewYPosition
        }
    }
    @IBAction func referralCodeButton(_ sender: Any) {
        
        // Check if the referralCode text field is not empty
        guard let referralCode = referralCodeTextField.text, !referralCode.isEmpty else {
                   showAlert(message: "Please enter a referral code.")
                   return
               }
               
               print("Referral code entered: \(referralCode)") // Debug statement
               
               // Call the validateReferralCode method on the ViewModel
        referralCodeViewModel.validateReferralCode(forReferralCode: referralCode)
        
    }
    
    @IBAction func proceedButton(_ sender: Any) {
        
        guard let firstName = firstName.text, !firstName.isEmpty,
              let lastName = lastName.text, !lastName.isEmpty,
              let email = email.text, !email.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        let firstNameLowercased = firstName.lowercased()
        let lastNameLowercased = lastName.lowercased()
        
        if firstNameLowercased == "humpy" || lastNameLowercased == "customer"{
            showAlert(message: "Please Change the Name ")
            return
        }

        guard let customerId = UserDefaults.standard.value(forKey: "customerID") as? Int else {
            print("Error: Customer ID not found.")
            showAlert(message: "Customer ID not found.")
            return
        }
    

        self.customerProfileViewModel?.customerProfile(firstName: firstName, lastName: lastName, email: email, referralCode: verifiedReferral ?? "",customerId : customerId)
        
    }

    
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}


extension UpdateProfileViewController: ReferralCodeViewModelDelegate {
    
    func referralCodeVerify(with referralCodeResult: Result<ReferralResult, Error>) {
        switch referralCodeResult {
        case .success(let referralCode):
            if let code = referralCode.referralCode, code.isEmpty {
                print("Referral code cannot be empty.")
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Referral code verified successfully.")
//                    self.referralCodeVerify.isHidden = true
                }
            }

        case .failure(let error):
            // Handle failure (e.g., invalid referral code)
            print("Failed to verify referral code: \(error.localizedDescription)")
            
            // Show an error alert
            showAlert(message: "Failed to verify referral code: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.refrelCodeView.isHidden = false
            }
        }

    }
    
}




   
extension UpdateProfileViewController: CustomerProfileInfo {
    func customerProfile(with profileResult: Result<Customer, Error>) {
        switch profileResult {
        case .success(let customer):
            if let customerProfileData = customer.customerDetails {
                self.customerDatails = customerProfileData
                if let customerFirstName = customerProfileData.customerFirstName,
                   let customerLastName = customerProfileData.customerLastName,
                   let customerEmail = customerProfileData.email {
                   
                    print("customerprofileInfo saved successfully: \(customerFirstName) \(customerLastName) \(customerEmail)")
                    DispatchQueue.main.async {
                        self.showAlert(message: "CustomerprofileInfo saved successfully")
                        if let selectCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? SelectCityViewController {
                            self.navigationController?.pushViewController(selectCityVC, animated: true)
                        }
                    }
                }
            }
            
        case .failure(let error):
            print("Error \(error.localizedDescription)")
        }
    }
}
extension UpdateProfileViewController : UserDetailsModelDelegate{
    func userDataFetch(with result: Result<UserDetailsModel, any Error>) {
        switch result {
        case .success(let data):
            // Encode object
            if let userData = data.userDetailsModelResult {
                self.userDetailsModelResult = userData
                
                do {
                    let encoder = JSONEncoder()
                    let encodedData = try encoder.encode(self.userDetailsModelResult)
                    UserDefaults.standard.set(encodedData, forKey: "userDetails")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Successful", message: "WELCOME \(self.userDetailsModelResult?.customerFirstName ?? "") \(self.userDetailsModelResult?.customerLastName ?? "")", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } catch {
                    print("Failed to encode user data: \(error)")
                }
            }
            
            
        case .failure(let error):
            print("requast error: \(error)")
            
        }
    }
    
    
}

//import UIKit
//
//class UpdateProfileViewController: UIViewController, UITextFieldDelegate {
//
//    @IBOutlet weak var firstName: UITextField!
//    @IBOutlet weak var lastName: UITextField!
//    @IBOutlet weak var email: UITextField!
//    @IBOutlet weak var refralCode: UITextField!
//    @IBOutlet weak var refrelCodeView: UIView!
//    @IBOutlet weak var proceedButton: UIButton!
//    @IBOutlet weak var referralCodeVerify: UIView!
//
//    var updateProfileViewModel: UpdateProfileViewModel?
//    var refferalResult: ReferralResult?
//    var userdata: UserDetailsModelResult?
//    var customer = [Customer].self
//    var customerProfileViewModel: CustomerProfileViewModel?
//
//    var originalViewYPosition: CGFloat = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        updateProfileViewModel = UpdateProfileViewModel()
//        self.updateProfileViewModel?.delegate = self
//        self.navigationItem.hidesBackButton = true
//
//        customerProfileViewModel = CustomerProfileViewModel()
//        let isRefferalScreen = UserDefaults.standard.bool(forKey: "isRefferalScreen")
//        referralCodeVerify.isHidden = true
//        refrelCodeView.isHidden = !isRefferalScreen  // Dynamically toggle referral code view
//
//        // Populate user details if available
//        if let userDetails = userdata {
//            firstName.text = userDetails.customerFirstName ?? ""
//            lastName.text = userDetails.customerLastName ?? ""
//            email.text = userDetails.email ?? ""
//        }
//
//        firstName.delegate = self
//        lastName.delegate = self
//        email.delegate = self
//
//        originalViewYPosition = self.view.frame.origin.y
//
//        // Observe keyboard events
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    // Handle keyboard will show notification
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let userInfo = notification.userInfo,
//           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//
//            let keyboardHeight = keyboardFrame.height + 30
//            if let mobileTextFieldYPosition = firstName.superview?.convert(firstName.frame.origin, to: self.view).y {
//                let spaceBelowTextField = self.view.frame.height - mobileTextFieldYPosition - firstName.frame.height
//                if spaceBelowTextField < keyboardHeight {
//                    UIView.animate(withDuration: 0.3) {
//                        self.view.frame.origin.y = self.originalViewYPosition - (keyboardHeight - spaceBelowTextField)
//                    }
//                }
//            }
//        }
//    }
//
//    // Handle keyboard will hide notification
//    @objc func keyboardWillHide(_ notification: Notification) {
//        UIView.animate(withDuration: 0.3) {
//            self.view.frame.origin.y = self.originalViewYPosition
//        }
//    }
//
//    // Show a custom alert
//    func showAlert(message: String) {
//        let alert = UIAlertController(title: "Profile Update", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true)
//    }
//
//    // Proceed Button Action - to trigger profile update
//    @IBAction func proceedButtonTapped(_ sender: Any) {
//        guard let firstName = firstName.text, !firstName.isEmpty,
//              let lastName = lastName.text, !lastName.isEmpty,
//              let email = email.text, !email.isEmpty else {
//            showAlert(message: "Please fill in all fields.")
//            return
//        }
//
//        // Call the customerProfile method from the ViewModel with the unwrapped values
//        customerProfileViewModel?.customerProfile(firstName: firstName, lastName: lastName, email: email)
//    }
//}
//
//// Conform to CustomerProfileInfo to handle API response
//extension UpdateProfileViewController: CustomerProfileInfo {
//    func customerProfile(with result: Result<Customer, Error>) {
//        switch result {
//        case .success(let customer):
//            // Handle successful profile update
//            showAlert(message: "Profile Updated Successfully")
//
//            // Optionally, navigate to another screen after success (e.g., SelectCityViewController)
//            if let selectCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? SelectCityViewController {
//                self.navigationController?.pushViewController(selectCityVC, animated: true)
//            }
//
//        case .failure(let error):
//            // Handle error scenario
//            showAlert(message: "Failed to update profile: \(error.localizedDescription)")
//        }
//    }
//}
//
//// Your existing code to implement UpdateProfileViewModelDelegate and Referral verification will remain the same
//extension UpdateProfileViewController : UpdateProfileViewModelDelegate {
//    func verifyReferralCode(with result: Result<ReferralCode, any Error>) {
//        switch result {
//        case .success(let referralCode):
//            showAlert(message: "Referral code verified successfully.")
//            referralCodeVerify.isHidden = true
//        case .failure(let error):
//            showAlert(message: "Failed to verify referral code: \(error.localizedDescription)")
//            referralCodeVerify.isHidden = false
//        }
//    }
//}
//
