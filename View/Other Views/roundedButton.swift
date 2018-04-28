//
//  fancyButton.swift
//  Habits
//
//  Created by Ahsan Vency on 3/1/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class roundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5.0;
        layer.masksToBounds = true;
    }
}
