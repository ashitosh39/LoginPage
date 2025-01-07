//
//  HomeViewController.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    
    
    
    @IBOutlet weak var sideMenuBarButton: UIButton!
    
    private var isContainerViewOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.isHidden = true
               
               // Add a tap gesture recognizer to detect taps outside the container
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideContainer(_:)))
               self.view.addGestureRecognizer(tapGesture)
        
               containerView.layer.cornerRadius = 20  // Set the corner radius (adjust as needed)
               containerView.layer.masksToBounds = true  // Ensure the subviews are clipped to the corner
        
    }
    
    @IBAction func sideMenuBarButtonTapped(_ sender: UIButton) {
           // Toggle the visibility of the container view
           isContainerViewOpen.toggle()
           
           // Show or hide the container view based on the state
           containerView.isHidden = !isContainerViewOpen
        
        sideMenuBarButton.isHidden = isContainerViewOpen
        tabBarController?.tabBar.isHidden = isContainerViewOpen
       }
       
       // Method to handle tap outside the container view
    @objc func handleTapOutsideContainer(_ sender: UITapGestureRecognizer) {
           if isContainerViewOpen {
               // Check if the tap occurred outside the containerView
               let location = sender.location(in: self.view)
               if !containerView.frame.contains(location) {
                   // Close the container view if tapped outside
                   isContainerViewOpen = false
                   containerView.isHidden = true
                   
                   // Show the sideMenuBarButton again when the container is hidden
                   sideMenuBarButton.isHidden = false
                   tabBarController?.tabBar.isHidden = false
               }
           }
       }

}
