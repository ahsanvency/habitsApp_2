//
//  backgroundGradient.swift
//  Habits
//
//  Created by Ahsan Vency on 3/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class backgroundGradient: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //backgroundColor = seaFoamColor
        
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        
        
        
        let color0 = UIColor(red:13/255, green:76/255, blue:153/255, alpha:0.85).cgColor
        let color1 = UIColor(red:99/255, green:42/255, blue: 91/255, alpha:0.76).cgColor
        let color2 = UIColor(red:186/255, green:7/255, blue: 29/255, alpha:0.71).cgColor
        let color3 = UIColor(red:218/255, green:128/255, blue:125/255, alpha:0.86).cgColor
        let color4 = UIColor(red:247/255, green:240/255, blue: 215/255, alpha:100).cgColor
        layer.colors = [color0,color1,color2,color3,color4]
        self.layer.insertSublayer(layer, at: 0)
    }
}

