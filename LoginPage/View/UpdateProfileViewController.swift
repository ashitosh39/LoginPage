//
//  UpdateProfileViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 19/11/24.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var refralCode: UITextField!
    
    @IBOutlet weak var refrelCodeView: UIView!
    
    var userdata: UserDetailsModelResult?
//   var originalViewYPosition: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view’s original Y position
        //            originalViewYPosition = self.view.frame.origin.y00
        
        
        
        
        // Observe keyboard notifications
        //            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //
        // Retrieve isRefferalScreen value from UserDefaults
        
        let isRefferalScreen = UserDefaults.standard.bool(forKey: "isRefferalScreen")
          
        
        
        
        // Use if-else statement to show/hide refrelCodeView
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
    }
    
    //        deinit {
    //            // Remove observers when the view controller is deallocated
    //            NotificationCenter.default.removeObserver(self)
    //        }
    
    // Handle keyboard appearance
    //        @objc func keyboardWillShow(_ notification: Notification) {
    //            // Get the keyboard size from the notification's user info
    //            if let userInfo = notification.userInfo,
    //               let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
    //
    //                let keyboardHeight = keyboardFrame.height
    //                let spaceBelowTextField = self.view.frame.height - (self.view.frame.origin.y + keyboardHeight)
    //
    //                // Adjust the view upwards to make room for the keyboard
    //                if spaceBelowTextField < keyboardHeight {
    //                    UIView.animate(withDuration: 0.3) {
    //                        self.view.frame.origin.y = self.originalViewYPosition - (keyboardHeight - spaceBelowTextField)
    //                    }
    //                }
    //            }
    //        }
    //
    //        // Handle keyboard disappearance
    //        @objc func keyboardWillHide(_ notification: Notification) {
    //            // Restore the view to its original position when the keyboard hides
    //            UIView.animate(withDuration: 0.3) {
    //                self.view.frame.origin.y = self.originalViewYPosition
    //            }
    //        }
    
    // UITextFieldDelegate method to handle return key behavior (moving to next text field or dismissing the keyboard)
    //        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //            switch textField {
    //            case firstName:
    //                lastName.becomeFirstResponder()
    //            case lastName:
    //                email.becomeFirstResponder()
    //            case email:
    //                refralCode.becomeFirstResponder()
    //            case refralCode:
    //                refralCode.resignFirstResponder()  // Dismiss the keyboard
    //            default:
    //                return true
    //            }
    //            return false
    //        }
}



