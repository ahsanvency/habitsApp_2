//
//  fancyField.swift
//  Habits
//
//  Created by Ahsan Vency on 1/21/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import DTTextField

class fancyField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 0
        layer.cornerRadius = 5.0;
        layer.masksToBounds = true;
        textColor = blueColor
    }

}
