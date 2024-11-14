//
//  VarificationViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 13/11/24.
//

import UIKit

class VerificationViewController: UIViewController {

    @IBOutlet weak var mobileNumber: UILabel!
    
    var mobileNumberText: String?
    var requestId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let mobile = mobileNumberText {
           mobileNumber.text = "Please enter 6 digit verification code sent to +91 \(mobile)"
       }
    }
    

   

}
