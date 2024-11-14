//
//  ViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 12/11/24.
//

import UIKit
//, UITextFieldDelegate
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterMobileNO: UITextField!
    
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterMobileNO.delegate = self
                loginBtn.isEnabled = false
                loginBtn.alpha = 0.5
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Enable/Disable login button based on the number of digits entered
        if let text = textField.text, text.count == 9 {
                        loginBtn.isEnabled = true
                        loginBtn.alpha = 0
            // Make it fully visible
        } else {
                        loginBtn.isEnabled = false
                        loginBtn.alpha = 0.5  // Make it semi-transparent
        }
        return true  // Allow the text change to happen
    }
    
    
    @IBAction func loginBtn(_ sender: UIButton) {
//         Check if the login button is enabled
                    if loginBtn.isEnabled {
             guard let mobileNumber = enterMobileNO.text else {
                 return}
             postData(mobile: mobileNumber)
         }
        else {
            print("Login button is disabled")
        }
    }

    func postData(mobile: String) {
            // Create JSON payload for the login request
            let parameters: [String: Any] = [
                "mobile": mobile,
                "can_whatsapp_send": 0  // You may adjust this depending on whether you want to enable WhatsApp messages
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
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data {
                        // Decode the response to check if OTP is sent
                        do {
                            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                            
                            if loginResponse.status == "success" {
                                // OTP was sent successfully
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "OTP Sent", message: "The OTP has been successfully sent to your mobile number.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alert, animated: true) {
                                        // Navigate to OTP verification screen after user taps OK
                                        self.navigateToOTPVerification()
                                    }
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
                        }
                    }
                }
                task.resume()
            } catch {
                print("Error serializing JSON: \(error.localizedDescription)")
            }
        }
        
        func navigateToOTPVerification() {
            // Instantiate the OTP verification screen from the storyboard
            if let verificationVC = self.storyboard?.instantiateViewController(identifier: "VarificationViewController") as? VarificationViewController {
                self.navigationController?.pushViewController(verificationVC, animated: true)
            }
        }
    }
       
    

