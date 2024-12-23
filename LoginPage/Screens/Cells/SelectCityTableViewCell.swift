//
//  SelectCityTableViewCell.swift
//  LoginPage
//
//  Created by Digitalflake on 20/12/24.
//

import UIKit

class SelectCityTableViewCell: UITableViewCell {
 
    @IBOutlet weak var cityImage: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tickMarkImageView: UIImageView!
    var isSelectedCell: Bool = false {
           didSet {
               // Update the UI to reflect the selection state
               if isSelectedCell {
//                  self.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
                   self.contentView.backgroundColor = UIColor.cyan// Change to selected color (light blue)
                   tickMarkImageView.isHidden = false  // Show the tick mark
               } else {
                   self.contentView.backgroundColor = UIColor.white  // Change to default color (white)
                   tickMarkImageView.isHidden = true  // Hide the tick mark
               }
           }
       }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tickMarkImageView.isHidden = true // By default, hide the tick mark
                self.contentView.backgroundColor = UIColor.white // Set default background color
            }
    }
       
  
    

