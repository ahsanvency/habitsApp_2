//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class advRewardsSlide: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var advField: UITextField!
    @IBOutlet weak var advPicker: UIPickerView!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    
    var listOfAdvRewards = ["New Tattoo or Piercing", "Pedicure", "Take a Day Off", "Go on Shopping Spree", "Party", "Go Camping", "Weekend Trip", "Attend Festival"]
    
    var advReward: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        backgroundImg.makeBlurImage(targetImageView: backgroundImg, with: .light)
        
        advField.delegate = self
        
        advPicker.delegate = self
        advPicker.dataSource = self
        
        advField.text = "Tap to pick an advanced reward."
        listOfAdvRewards.sort()
        listOfAdvRewards.append("Enter Custom Reward Above.")
        
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = listOfAdvRewards[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Next", size: 15.0)!,NSAttributedStringKey.foregroundColor:blueColor])
        return myTitle
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return listOfAdvRewards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //The user cannot edit the components anymore
        self.advField.endEditing(true)
        //This is the value that was selected by the picker
        return listOfAdvRewards[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.advField.endEditing(true)
        advReward = self.listOfAdvRewards[row]
        
        if advReward == "Enter Custom Reward Above."{
            self.advField.becomeFirstResponder()
        }
        self.advField.text = advReward!
        self.advPicker.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.advField {
            
            if advReward != "Enter Custom Reward Above."{
                self.advPicker.isHidden = false
                textField.endEditing(true)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        advReward = textField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.advField.endEditing(true)
        
    }
}




