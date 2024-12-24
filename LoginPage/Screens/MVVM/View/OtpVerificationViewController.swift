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
    @IBOutlet weak var countdownLabel: UILabel!
//    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var resendLabel: UILabel!
   
    private var countdownTimer: Timer?
    private var countdownValue = 30
    var isWhatsAppSelected: Bool = false
       
    var loginViewModel: LoginViewModel?
    var loginResult: LoginResponseResult?
    var verificationViewModel: VerificationViewModel?
    var mobileNumberText: String?
    var originalViewYPosition: CGFloat?
    var requestId: String?
  
    var userDetailViewModel : UserDetailsViewModel?
    var userDetailsModelResult : UserDetailsModelResult?
    var otpVerificationResult : OtpVarificationModel?
    override func viewDidLoad() {
        super.viewDidLoad()
//        initiate delegate
        loginViewModel = LoginViewModel()
        loginViewModel?.delegate = self
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
            otpField.addTarget(self, action: #selector(otpFieldDidChange), for: .editingChanged)
            addDoneButtonOnKeyboard(to: otpField)
        }
        
        verifyButton.isEnabled = false
        originalViewYPosition = self.view.frame.origin.y
        
        // Observers for keyboard appearance
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        updateResendLabelUI()
        
    }
    
    func updateResendLabelUI() {
        // Set up the attributed text for the label
        let fullText = "Didn't receive the code? RESEND"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Set default style (black color for the first part)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 26))
        
        // Set red color to "RESEND"
        let resendRange = (fullText as NSString).range(of: "RESEND")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: resendRange)
        
        // Set the attributed text to the label
        resendLabel.attributedText = attributedString
        
        // Make the label interactive
        resendLabel.isUserInteractionEnabled = true
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapResend(_:)))
        resendLabel.addGestureRecognizer(tapGesture)
    

    }
    @objc func handleTapResend(_ gesture: UITapGestureRecognizer) {
        // Get the location of the tap in the label
        let location = gesture.location(in: gesture.view)
        
        // Check if the tap is within the "RESEND" part of the label
        if let label = gesture.view as? UILabel {
            let text = label.attributedText?.string ?? ""
            let range = (text as NSString).range(of: "RESEND")
            
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: label.bounds.size)
            let textStorage = NSTextStorage(attributedString: label.attributedText!)
            
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            
            let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer)
            
            if NSLocationInRange(glyphIndex, range) {
                // "RESEND" tapped, perform your action
                print("Resend label tapped")
                
                // Ensure mobileNumberText is a String and can be used in the API request
                if let mobile = mobileNumberText, !mobile.isEmpty {
                    // Here, isWhatsAppSelected is assumed to be a Bool, so passing 0 for SMS and 1 for WhatsApp
                    let canSendWhatsApp = isWhatsAppSelected ? 1 : 0
                    
                    // Ensure to call login with correct parameters
                    self.loginViewModel?.login(mobile: mobile, canSendWhatsApp: canSendWhatsApp)
                    
                    // Start the countdown timer for resend
                    startCountdown()
                    countdownLabel.isHidden = false
                } else {
                    print("Mobile number is missing or invalid")
                }
            }
        }
    }


    
    override func viewWillAppear(_ animated: Bool) {
        startCountdown()
        updateCountdown()
    }
   
    func startCountdown() {
        countdownValue = 30 // Reset countdown value
                
                // Update the countdown label initially
          resendLabel.isEnabled = true
           resendLabel.alpha = 0.5 // Dim the resend label when it is disabled
    
                // Create the timer that updates every second
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    @objc func updateCountdown() {
            countdownValue -= 1
            // Update the countdown label every second
            countdownLabel.text = "00:\(countdownValue)"
        resendLabel.isUserInteractionEnabled = false

        resendLabel.alpha = 0.5 // Dim the resend label when it is disabled
            // When the countdown reaches 0
       
        if countdownValue == 0 {
                countdownTimer?.invalidate() // Stop the timer
                countdownTimer = nil
            countdownLabel.isHidden = true
            resendLabel.isUserInteractionEnabled = true

            resendLabel.alpha = 1.0
//                resendButton.isEnabled = true // Enable the button again
//                countdownLabel.isHidden = true // Hide the countdown label
            }
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
    
//     UITextFieldDelegate method to handle OTP input (numeric only and 1 digit per field)
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
    
            // Ensure that the entered string is a single digit and numeric
            if let _ = string.rangeOfCharacter(from: CharacterSet.decimalDigits), string.count == 1 {
                // Prevent entering more than one character
                if updatedText.count > 1 {
                    return false
                }
                return true
            } else if string.isEmpty {
                // Allow the user to delete a character
                return true
            } else {
                return false // Prevent non-numeric input
            }
        }
     
    // This function is called whenever a text field's text changes
    @objc func otpFieldDidChange(_ textField: UITextField) {
        // If the current field is empty and the user backspaced, move focus to the previous field
        if textField.text?.isEmpty == true {
            switch textField {
            case otp2:
                otp1.becomeFirstResponder()
            case otp3:
                otp2.becomeFirstResponder()
            case otp4:
                otp3.becomeFirstResponder()
            case otp5:
                otp4.becomeFirstResponder()
            case otp6:
                otp5.becomeFirstResponder()
            default:
                break
            }
        } else if textField.text?.count == 1{
            moveToNextEmptyField(from: textField)
            // Automatically move to the next field when text is entered
            switch textField {
            case otp1 where otp1.text?.count == 1:
                otp2.becomeFirstResponder()
            case otp2 where otp2.text?.count == 1:
                otp3.becomeFirstResponder()
            case otp3 where otp3.text?.count == 1:
                otp4.becomeFirstResponder()
            case otp4 where otp4.text?.count == 1:
                otp5.becomeFirstResponder()
            case otp5 where otp5.text?.count == 1:
                otp6.becomeFirstResponder()
            case otp6 where otp6.text?.count == 1:
                otp6.resignFirstResponder()// Close keyboard when last field is filled
            default:
                break
            }
        }
        
        // Check if all OTP fields are filled to enable the Verify button
        checkOTPFields()
        // After a user enters a digit, move focus to the first empty text field
       
    }
    func moveToNextEmptyField(from currentField: UITextField) {
        let otpFields = [otp1, otp2, otp3, otp4, otp5, otp6]
        
        // Find the index of the current field
        if let currentIndex = otpFields.firstIndex(where: { $0 == currentField }) {
            // Loop through the remaining fields to find the next empty one
            for index in (currentIndex + 1)..<otpFields.count {
                if otpFields[index]?.text?.isEmpty == true {
                    otpFields[index]?.becomeFirstResponder()
                }
            }
        }
    }
    // Check if all OTP fields are filled, enable or disable the Verify button accordingly
    func checkOTPFields() {
        let otpFields = [otp1, otp2, otp3, otp4, otp5, otp6]
        let allFieldsFilled = otpFields.allSatisfy { $0?.text?.count == 1 }
        
        // Enable or disable the verify button based on whether all OTP fields are filled
        verifyButton.isEnabled = allFieldsFilled
    }
    
    func navigateToNormalViewController() {
        if self.userDetailsModelResult?.customerFirstName == "Humpy" && self.userDetailsModelResult?.customerLastName == "Customer"{
            // redirect to updateProfileViewController
            DispatchQueue.main.async{
                if let updateProfileView = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController {
                    
                    updateProfileView.userdata = self.userDetailsModelResult
                    self.navigationController?.pushViewController(updateProfileView, animated: true)
                }
                
            }
            
        }else{
            DispatchQueue.main.async{
                if let selectCity = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? SelectCityViewController {
                    self.navigationController?.pushViewController(selectCity, animated: true)
                }
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
//                    countdownLabel.isHidden = false
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

extension VerificationViewController: UserDetailsModelDelegate {
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
                        let alert = UIAlertController(title: "Successful", message: "WELCOME \(self.userDetailsModelResult?.customerFirstName ?? "") \(self.userDetailsModelResult?.customerLastName ?? "")", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.navigateToNormalViewController()}))
                        self.present(alert, animated: true, completion: nil)
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

extension VerificationViewController : LoginViewModelDelegate {
    func didfinishLogin(with result: Result<LoginModel, any Error>) {
        switch result {
        case .success(let loginModel):
            // Handle successfull login
            print("Login successful: \(loginModel)")
            // Proceed with OTP verification
            if mobileNumberText != nil {
                self.requestId = loginModel.result?.reqID
                self.startCountdown() // Start the countdown timer for OTP
                self.countdownLabel.isHidden = false
            }
        case .failure(let error):
            printContent("requast error: \(error)")
        }
    }
}
