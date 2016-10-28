//
//  ButtonTableViewCell.swift
//  StyleKitSample
//
//  Created by Eric Kille on 10/22/16.
//  Copyright © 2016 Tonic Design. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
