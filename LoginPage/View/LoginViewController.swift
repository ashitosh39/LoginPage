//
//  ViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 12/11/24.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterMobileNO: UITextField!
    
    
    @IBOutlet weak var loginBtn: UIControl!
    var loginViewModel: LoginViewModel?
    var loginResult: LoginResponseResult?
    var originalViewYPosition: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        enterMobileNO.delegate = self
        enterMobileNO.keyboardType = .numberPad
        addDoneButtonOnKeyboard(to: enterMobileNO)
        enterMobileNO.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        // Disable the login button initially
        checkOTPFields()
        
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
    
    // Action when the "Done" button is pressed
    @objc func doneButtonAction() {
        view.endEditing(true)  // Dismiss the keyboard
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
        
//        checkOTPFields()
        
        return true  // Allow text change
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        checkOTPFields()
    }
    func navigateToVerificationViewController(withData: LoginResponseResult) {
        // Instantiate the VerificationViewController from storyboard
        if let vvc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
            // Pass the mobile number to the VerificationViewController
            vvc.mobileNumberText = withData.mobile
            vvc.requestId = withData.reqID
            self.navigationController?.pushViewController(vvc, animated: true)
            // Navigate to the VerificationViewController
            
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let mobileNumber = enterMobileNO.text, mobileNumber.count == 10 else {
            return // No action if the number is not 10 digits
        }
        // Call API to send OTP
        self.loginViewModel?.login(mobile: mobileNumber)
    }
    
    func checkOTPFields() {
        let allFieldsFilled = enterMobileNO.text?.count == 10
        if allFieldsFilled{
            loginBtn.isEnabled = true
            loginBtn.alpha = 1
        }else{
            loginBtn.isEnabled = false
            loginBtn.alpha = 0.8
        }
        // Enable or disable the verify button based on whether all OTP fields are filled
        
    }
    
}

extension LoginViewController: LoginViewModelDelegate{
    func didfinishLogin(with result: Result<LoginModel, any Error>) {
            switch result {
            case .success(let data):
                if let loginResult = data.result{
                    // OTP was sent successfully
                    self.loginResult = loginResult
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "OTP Sent", message: "The OTP has been successfully sent to your mobile number.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            // Navigate to OTP verification screen after user taps OK
                            self.navigateToVerificationViewController(withData: loginResult)
                        }))
                        self.present(alert, animated: true)
                    }
                }else{
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
