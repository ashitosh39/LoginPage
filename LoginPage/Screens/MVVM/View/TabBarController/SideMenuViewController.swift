//
//  SideMenuViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    private var isContainerViewOpen = true
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
    }
    @IBAction func sideMenuBarCancelButton(_ sender: Any) {
      
        
        isContainerViewOpen.toggle()
            
            
            UIView.animate(withDuration: 0.3) {
                if self.isContainerViewOpen {
                    // If the container is open, show it
                    self.containerView.frame.origin.x = 0 // or position it as required
                } else {
                    // If the container is closed, move it off-screen
                    self.containerView.frame.origin.x = -self.containerView.frame.width // Move off-screen to the left
                }
              
            }
        containerView.isHidden = !isContainerViewOpen
        print("Cancel button Clicked")
    }
    
    @IBAction func homeButton(_ sender: Any) {
        
        
    }
    
    @IBAction func mySubScription(_ sender: Any) {
        
        
    }
    
    @IBAction func myVacationButton(_ sender: Any) {
        
        
    }
    
    @IBAction func referralFriendButton(_ sender: Any) {
        
        
    }
    @IBAction func hummpyAppButtun(_ sender: Any) {
        
        
    }
    @IBAction func rateingButtun(_ sender: Any) {
        
        
    }
    @IBAction func repostAnIssueButton(_ sender: Any) {
        
        
    }
    
    
}
