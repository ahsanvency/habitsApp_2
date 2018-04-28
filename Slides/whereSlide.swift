//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class whereSlide: UIView {
    
    
    @IBOutlet weak var consistencyLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var whereField: UITextField!
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        whereField.attributedPlaceholder = NSAttributedString(string: "Tap To Enter A Location",
                                                              attributes: [NSAttributedStringKey.foregroundColor: blueColor])
        
//        backgroundImg.makeBlurImage(targetImageView: backgroundImg, with: .light)
        
    }
}



