//
//  ViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 12/11/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterMobileNO: UITextField!
    
    
    @IBOutlet weak var loginBtn: UIControl!
    
    var loginResult: LoginResponseResult?
    var originalViewYPosition: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        enterMobileNO.delegate = self
        
        // Disable the login button initially
        loginBtn.isEnabled = false
        loginBtn.alpha = 0.5
        
        // Store the original Y position of the view
        originalViewYPosition = self.view.frame.origin.y
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        // Remove observers when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    // Automatically show the keyboard when the text field becomes active
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // This is called when the text field is tapped, the keyboard should automatically open.
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
        postData(mobile: mobileNumber)
    }
    
    func postData(mobile: String) {
        // Create JSON payload for the login request
        let parameters: [String: Any] = [
            "mobile": mobile,
            "can_whatsapp_send": 0  // Adjust this if necessary
        ]
        
        // Convert dictionary to JSON data
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Create URL request for the login API
            var request = URLRequest(url: URL(string: "https://uat-api.humpyfarms.com/api/customers/login")!, timeoutInterval: 30.0)
            request.httpMethod = "POST"
            request.setValue("iOS/1.5.7/18.0.1", forHTTPHeaderField: "User-Agent")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            
            // Send the request
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return } // Safely unwrap self
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // Check the HTTP status code
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode != 200 {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "Failed to connect to the server. Please try again later.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        return
                    }
                }
                
                // Check if data is nil or empty
                guard let data = data, !data.isEmpty else {
                    print("Error: Received empty or nil data")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "No data received from the server.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    return
                }
                
                // Log the raw response data for debugging purposes
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                
                // Decode the response to check if OTP is sent
                do {
                    let loginResponse = try JSONDecoder().decode(LoginModel.self, from: data)
                    
                    if loginResponse.status == 200 , let loginResult = loginResponse.result{
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
                    } else {
                        // Handle failure scenario, show error message from the server
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: loginResponse.message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                } catch {
                    print("Error parsing response: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "An error occurred while parsing the response from the server.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
}