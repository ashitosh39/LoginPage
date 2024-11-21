//
//  VarificationViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 13/11/24.
//

import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var otp1: UITextField!
    @IBOutlet weak var otp2: UITextField!
    @IBOutlet weak var otp3: UITextField!
    @IBOutlet weak var otp4: UITextField!
    @IBOutlet weak var otp5: UITextField!
    @IBOutlet weak var otp6: UITextField!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var verifyButton: UIControl!
    
    
    var verificationViewModel: VerificationViewModel?
    var mobileNumberText: String?
    var originalViewYPosition: CGFloat?
    var requestId: String?
    var userDetailViewModel : UserDetailsViewModel?
    var userDetailsModelResult : UserDetailsModelResult?
    var otpVerificationResult : OtpVarificationModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailViewModel = UserDetailsViewModel()
        userDetailViewModel?.delegate = self
        verificationViewModel = VerificationViewModel()
        verificationViewModel?.delegate = self
        // Set up the mobile number label
        
        if let mobile = mobileNumberText {
            mobileNo.text = "Please enter 6 digit verification code sent to +91 \(mobile)"
        }
        let otpFields: [UITextField] = [otp1, otp2, otp3, otp4, otp5, otp6]
        for otpField in otpFields {
            otpField.delegate = self
            otpField.keyboardType = .numberPad
            addDoneButtonOnKeyboard(to: otpField)
        }
        
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
        //        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        //        doneToolbar.items = [doneButton]
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
    func navigateToNormalViewController(withData  : OTPResponsResult) {
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
    
    @IBAction func verifyBtnAction(_ sender: Any){
        // Collect OTP from the text fields
        
        if let otpText1 = otp1.text, let otpText2 = otp2.text, let otpText3 = otp3.text, let otpText4 = otp4.text, let otpText5 = otp5.text, let otpText6 = otp6.text {
            let otp = otpText1 + otpText2 + otpText3 + otpText4 + otpText5 + otpText6
            
            // Attempt to convert the concatenated OTP string into an integer
            if let otpInt = Int(otp) {
                // Pass the OTP and a valid requestId to the ViewModel
                if let requestId = requestId{ // Replace this with the actual requestId you need to pass
                    verificationViewModel?.verifyOtp(otp: otpInt, requestId: requestId)
                }
            } else {
                // Show an error if the OTP is invalid (not a number)
                let alert = UIAlertController(title: "Error", message: "Please enter a valid OTP.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}

extension VerificationViewController: VerificationViewModelDelegate {
    func didFinishLoading(with result: Result<OtpVarificationModel, Error>) {
        switch result {
        case .success(let data):
            // Check if verificationResult is not nil and safely unwrap the token
            if let verificationResult = data.result {
                if let token = verificationResult.token , let customerID = verificationResult.customerID, let isRefferalScreen = verificationResult.isRefferalScreen{
                    print("OTP Verification successful: \(token)")
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(customerID, forKey: "customerID")
                    UserDefaults.standard.set(isRefferalScreen, forKey: "isRefferalScreen")
                    userDetailViewModel?.getUserDetails()
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Successful", message: verificationResult.token, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.navigateToNormalViewController(withData: verificationResult)}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                // If token is nil, show error message
                let alert = UIAlertController(title: "Error", message: "Token missing in the response.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                // Handle error (e.g., show error message)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
extension VerificationViewController : UserDetailsModelDelegate {
    func userDataFetch(with result: Result<UserDetailsModel, any Error>) {
        switch result {
        case .success(let data):
            // Encode object
            if let userData = data.result {
                self.userDetailsModelResult = userData
                
                do {
                    let encoder = JSONEncoder()
                    let encodedData = try encoder.encode(self.userDetailsModelResult)
                    UserDefaults.standard.set(encodedData, forKey: "userDetails")
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
            printContent("requast error: \(error)")
            
        }
    }
}


