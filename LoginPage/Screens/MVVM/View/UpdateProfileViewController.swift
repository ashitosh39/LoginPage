//
//  UpdateProfileViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 19/11/24.
//

import UIKit

class UpdateProfileViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var refralCode: UITextField!
    
    @IBOutlet weak var refrelCodeView: UIView!
    
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet weak var referralCodeVerify: UIView!
    
    
    var updateProfileViewModel : UpdateProfileViewModel?
    var refferalResult: ReferralResult?
    var userdata: UserDetailsModelResult?
    var customer = [Customer].self
    var customerProfileViewModel : CustomerProfileViewModel?
    
    var originalViewYPosition: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfileViewModel = UpdateProfileViewModel()
        self.updateProfileViewModel?.delegate = self
        self.navigationItem.hidesBackButton = true
        
        customerProfileViewModel = CustomerProfileViewModel()
        let isRefferalScreen = UserDefaults.standard.bool(forKey: "isRefferalScreen")
        referralCodeVerify.isHidden = true
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
    
    @IBAction func referalCodeVerify(_ sender: Any) {
        
        
        
    }
    
    @IBAction func proceedButton(_ sender: Any) {
        
        guard let firstName = firstName.text, !firstName.isEmpty,
                  let lastName = lastName.text, !lastName.isEmpty,
                  let email = email.text, !email.isEmpty else {
                showAlert(message: "Please fill in all fields.")
                return
            }
            
          
        DispatchQueue.main.async {
            if let selectCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? SelectCityViewController {
                self.navigationController?.pushViewController(selectCityVC, animated: true)
            }
        }
            
            // Call the customerProfile method from the ViewModel with the unwrapped values
            /*customerProfileViewModel?.customerProfile(firstName: firstName, lastName: lastName, email: email)*/
        

        
        self.customerProfileViewModel?.customerProfile(firstName: firstName, lastName: lastName, email: email)
    }
}

extension UpdateProfileViewController : UpdateProfileViewModelDelegate{
    func verifyReferralCode(with result: Result<ReferralCode, any Error>) {
        switch result {
        case .success(let referralCode):
            showAlert(message: "Referral code verified successfully.")
            DispatchQueue.main.async {
      
                self.referralCodeVerify.isHidden = true
            }
        case .failure(let error):
            // Handle error (e.g., network or parsing error)
            showAlert(message: "Failed to verify referral code: \(error.localizedDescription)")
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            DispatchQueue.main.async {
             
                self.referralCodeVerify.isHidden = false
            }
        }
    }
    
    // Show an alert with a message
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Referral Code Verification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UpdateProfileViewController: CustomerProfileInfo {
    func customerProfile(with result: Result<Customer, Error>) {
        switch result {
        case .success(let customer):
            // Handle successful profile update
            showAlert(message: "Profile Updated Successfully")
            
            // Optionally, you can navigate to another screen after successful profile update
           
            
        case .failure(let error):
            // Handle error scenario
            showAlert(message: "Failed to update profile: \(error.localizedDescription)")
        }
    }
}




