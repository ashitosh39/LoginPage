//
//  SideMenuViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 10  // Set the corner radius (adjust as needed)
        containerView.layer.masksToBounds = true  // Ensure the subviews are clipped to the corner
        
    }
    

    

}
