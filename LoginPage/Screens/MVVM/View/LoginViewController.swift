//
//  MobileNoLoginViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import UIKit

class MobileNoLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterMobileNO: UITextField!
    @IBOutlet weak var loginBtn: UIControl!
    
    
    var loginViewModel: LoginViewModel?
    var loginResult: LoginResponseResult?
    var originalViewYPosition: CGFloat?
    @IBOutlet weak var checkmarkButton: UIButton!  // Round button outlet
    var isCheckmarkSelected: Bool = false         // To keep track of the checkmark state
 
    override func viewDidLoad() {
        super.viewDidLoad()
        checkmarkButton.layer.borderWidth = 0
        checkmarkButton.layer.cornerRadius = 12
        checkmarkButton.layer.backgroundColor = UIColor.black.cgColor
        checkmarkButton.layer.cornerCurve = .continuous
        self.navigationItem.hidesBackButton = true
        enterMobileNO.delegate = self
        
        // Disable the login button initially
        loginBtn.isEnabled = false
        loginBtn.alpha = 0.5
        
        self.loginViewModel = LoginViewModel()
        self.loginViewModel?.delegate = self
        // Store the original Y position of the view
        originalViewYPosition = self.view.frame.origin.y
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    deinit {
        // Remove observers when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    // Function to add the "Done" button to the keyboard
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
    // Automatically show the keyboard when the text field becomes active
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // This is called when the text field is tapped, the keyboard should automatically open.
        self.originalViewYPosition
    }
    
    // Handle keyboard will show notification
    @objc func keyboardWillShow(_ notification: Notification) {
        // Get the keyboard size
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            // Move the view up by the height of the keyboard
            let keyboardHeight = keyboardFrame.height + 30
            
            // Check if the text field is going to be hidden behind the keyboard
            if let mobileTextFieldYPosition = enterMobileNO.superview?.convert(enterMobileNO.frame.origin, to: self.view).y {
                let spaceBelowTextField = self.view.frame.height - mobileTextFieldYPosition - enterMobileNO.frame.height
                
                // Only move the view if the text field is behind the keyboard
                if spaceBelowTextField < keyboardHeight {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame.origin.y = self.originalViewYPosition! - (keyboardHeight - spaceBelowTextField)
                    }
                }
            }
        }
    }
    
    //         Handle keyboard will hide notification
    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset the view position when the keyboard hides
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = self.originalViewYPosition!
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the updated text after the change
        guard let text = textField.text else { return true }
        
        // Calculate the new text length after replacement
        let newLength = text.count + string.count - range.length
        let allowedCharacters = CharacterSet.decimalDigits
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil && string != "" {
            return false // Block non-numeric characters
        }
        
        // Enable/Disable login button based on the number of digits entered
        if newLength == 10 {
            loginBtn.isEnabled = true
            loginBtn.alpha = 1 // Fully visible when enabled
        } else {
            loginBtn.isEnabled = false
            loginBtn.alpha = 0.5  // Semi-transparent when disabled
        }
        
        return true  // Allow text change
    }
    func navigateToVerificationViewController(withData: LoginResponseResult) {
        // Instantiate the VerificationViewController from storyboard
        DispatchQueue.main.async {
            if let vvc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
                // Pass the mobile number to the VerificationViewController
                vvc.mobileNumberText = self.enterMobileNO.text
                vvc.requestId = withData.reqID
                self.navigationController?.pushViewController(vvc, animated: true)
                // Navigate to the VerificationViewController
            }
        }
    }
   
    @IBAction func checkmarkButtonTapped(_ sender: Any) {
    
    // Toggle the checkmark selected state
           isCheckmarkSelected.toggle()
           
           // Update the button's image based on the selected state
           if isCheckmarkSelected {
               // Display filled checkmark (selected state)
               
               checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
           } else {
               // Display empty checkmark (unselected state)
               checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
           }
           
           // Optional debug print to track the state
           print("Checkmark selected: \(isCheckmarkSelected ? "Yes" : "No")")
      
    }

    
    @IBAction func loginBtn(_ sender: Any) {
        guard let mobileNumber = enterMobileNO.text, mobileNumber.count == 10 else {
                return // No action if the number is not 10 digits
            }
            
            // Debugging log to verify loginBtn action is triggered
            print("Login Button Tapped")
            
            // Determine whether to send OTP via WhatsApp or SMS
            let canSendWhatsApp = isCheckmarkSelected ? 1 : 0
            
            // Debugging log to verify the WhatsApp selection state
            print("Sending OTP via: \(canSendWhatsApp == 1 ? "WhatsApp" : "SMS")")
            
            // Call API to send OTP
            self.loginViewModel?.login(mobile: mobileNumber, canSendWhatsApp: canSendWhatsApp)
        }
}

extension MobileNoLoginViewController: LoginViewModelDelegate {
    func loginMobileNo(with result: Result<LoginModel, any Error>) {
        switch result {
        case .success(let data):
            if let loginResult = data.result {
                self.loginResult = loginResult
                DispatchQueue.main.async {
                    let otpSentMessage = self.isCheckmarkSelected ? "The OTP has been successfully sent to your mobile number via WhatsApp." : "The OTP has been successfully sent to your mobile number via SMS."
                    
                    let alert = UIAlertController(title: "OTP Sent", message: otpSentMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Navigate to OTP verification screen after user taps OK
                        self.navigateToVerificationViewController(withData: loginResult)
                    }))
                    self.present(alert, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "An error occurred while parsing the response from the server.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
                            
