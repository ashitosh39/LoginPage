//
//  SelectCityCollectionViewCell.swift
//  LoginPage
//
//  Created by Digitalflake on 26/12/24.
//

import UIKit

class SelectCityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityImage: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var tickImage: UIImageView!
    
    var isSelectedCell : Bool = false{
        didSet{
            if isSelectedCell {
                // self.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
//                self.contentView.backgroundColor = UIColor.cyan// Change to selected color (light blue)
                tickImage.isHidden = false
            }else{
                self.contentView.backgroundColor = UIColor.white  // Change to default color (white)
                tickImage.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
     
        tickImage.isHidden = true
        self.contentView.backgroundColor = UIColor.white  // Change to default color (white)
}
}

