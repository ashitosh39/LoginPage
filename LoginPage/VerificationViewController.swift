//
//  VarificationViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 13/11/24.
//

import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var otp1: UITextField!
    @IBOutlet weak var otp2: UITextField!
    @IBOutlet weak var otp3: UITextField!
    @IBOutlet weak var otp4: UITextField!
    @IBOutlet weak var otp5: UITextField!
    @IBOutlet weak var otp6: UITextField!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var verifyButton: UIControl!
    
    var mobileNumberText: String?
    var requestId: String?
    var originalViewYPosition: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the mobile number label
        if let mobile = mobileNumberText {
            mobileNo.text = "Please enter 6 digit verification code sent to +91 \(mobile)"
        }
        
        // Set all text fields delegates and keyboard types
        let otpFields: [UITextField] = [otp1, otp2, otp3, otp4, otp5, otp6]
        for otpField in otpFields {
            otpField.delegate = self
            otpField.keyboardType = .numberPad  // Numeric keyboard for OTP fields
            addDoneButtonOnKeyboard(to: otpField)
        }
        
        // Optionally, disable the "Verify" button initially
        verifyButton.isEnabled = false
        
        originalViewYPosition = self.view.frame.origin.y
        
        // Observers for keyboard appearance
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
            
            // Create the "Done" button
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
            
            // Add the "Done" button to the toolbar
            doneToolbar.items = [doneButton]
            
            // Set the toolbar as the input accessory view for the text field
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
            let keyboardHeight = keyboardFrame.height + 30
            
            // Check if the first OTP field is visible and adjust the view if needed
            if let otp1FrameInView = otp1.superview?.convert(otp1.frame.origin, to: self.view) {
                let spaceBelowTextField = self.view.frame.height - otp1FrameInView.y - otp1.frame.height
                if spaceBelowTextField < keyboardHeight {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame.origin.y = self.originalViewYPosition! - (keyboardHeight - spaceBelowTextField)
                    }
                }
            }
        }
    }
    
    // Handle keyboard will hide notification
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = self.originalViewYPosition!
        }
    }
    
    // Handle return key press to move to the next text field or hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case otp1:
            otp2.becomeFirstResponder()
        case otp2:
            otp3.becomeFirstResponder()
        case otp3:
            otp4.becomeFirstResponder()
        case otp4:
            otp5.becomeFirstResponder()
        case otp5:
            otp6.becomeFirstResponder()
        case otp6:
            otp6.resignFirstResponder()  // Dismiss the keyboard when last field is reached
        default:
            return true
        }
        return false
    }
    
    // UITextFieldDelegate method to handle OTP input (numeric only and 1 digit per field)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Ensure that the entered string is a single digit and numeric
        if let _ = string.rangeOfCharacter(from: CharacterSet.decimalDigits), string.count == 1 {
            // Prevent entering more than one character
            if updatedText.count > 1 {
                return false
            }
            
            // Automatically move to the next field after entering a digit
            if textField == otp1 {
                otp1.text = string
                otp2.becomeFirstResponder()
            } else if textField == otp2 {
                otp2.text = string
                otp3.becomeFirstResponder()
            } else if textField == otp3 {
                otp3.text = string
                otp4.becomeFirstResponder()
            } else if textField == otp4 {
                otp4.text = string
                otp5.becomeFirstResponder()
            } else if textField == otp5 {
                otp5.text = string
                otp6.becomeFirstResponder()
            } else if textField == otp6 {
                otp6.text = string
                otp6.resignFirstResponder() // Close keyboard when last field is filled
                // Enable the "Verify" button when OTP is complete
                verifyButton.isEnabled = true
            }
            return true
        } else if string.isEmpty {
            // Allow the user to delete a character
            return true
        } else {
            return false // Prevent non-numeric input
        }
    }
    
    @IBAction func verifyBtnAction(_ sender: Any) {
        print("verifyBtnAction")
        
        if let otpText1 = otp1.text, let otpText2 = otp2.text, let otpText3 = otp3.text, let otpText4 = otp4.text, let otpText5 = otp5.text, let otpText6 = otp6.text {
            let otp = otpText1 + otpText2 + otpText3 + otpText4 + otpText5 + otpText6
            
            // Check if OTP is complete (6 digits)
            if otp.count == 6, let otp = Int(otp) {
                verifyOtp(otp: otp)
            } else {
                // Show an alert if OTP is not complete
                let alert = UIAlertController(title: "Error", message: "Please enter a valid 6 digit OTP", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter complete 6 digit OTP", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func verifyOtp(otp: Int) {
        guard let requestId = self.requestId else {
            print("Request ID is missing")
            return
        }
        
        // Prepare the parameters to send in the request
        let parameters = [
            "otp": otp,
            "request_id": requestId
        ] as [String : Any]
        
        // Convert the parameters to JSON data
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Failed to serialize JSON data")
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: URL(string: "https://uat-api.humpyfarms.com/api/customers/verifyMobileOtp")!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(postData.count)", forHTTPHeaderField: "Content-Length")
        request.addValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        print("POST DATA \(postData)")
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Try to parse the response
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(OTPRespons.self, from: data)
                DispatchQueue.main.async {
                    // Handle the response (e.g., show a success message or navigate to the next screen)
                    if let token = responseObject.result?.token {
                        print("OTP Verification successful: \(token)")
                        let alert = UIAlertController(title: "Successful", message: token, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        // Navigate to the next screen or show success
                    }
                }
            } catch {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            //                DispatchQueue.main.async {
            //                    // Navigate to the next screen
            //                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NextScreenIdentifier")
            //                    self.navigationController?.pushViewController(nextVC!, animated: true)
            //                }
            
        }
        
        task.resume()
    }
}

