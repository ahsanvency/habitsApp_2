//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class intRewardsSlide: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var intField1: UITextField!
    @IBOutlet weak var intPicker1: UIPickerView!
    @IBOutlet weak var intField2: UITextField!
    @IBOutlet weak var intPicker2: UIPickerView!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    
    var listOfIntRewards1 = ["Eat Out", "Dessert", "Watch TV", "Call a Friend", "Enjoy a Long Shower", "Work on Your Hobby", "Buy a New Game", "Buy a New Book", "Play Video Games", "Attend Sporting Game", "Drink Wine", "Get House Cleaned", "Play Outdoors"]
    var listOfIntRewards2 = [String]()
    
    var intReward1: String?
    var intReward2: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listOfIntRewards2 = listOfIntRewards1
        
        intField1.delegate = self
        intField2.delegate = self
        
        intPicker1.delegate = self
        intPicker1.dataSource = self
        intPicker2.delegate = self
        intPicker2.dataSource = self
        
        
        intField1.text = "Tap to pick an intermediate reward."
        intField2.text = "Tap to pick an intermediate reward."
        listOfIntRewards1.sort()
        listOfIntRewards2.sort()
        listOfIntRewards1.append("Enter Custom Reward Above")
        listOfIntRewards2.append("Enter Custom Reward Above")
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = listOfIntRewards1[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Next", size: 15.0)!,NSAttributedStringKey.foregroundColor:blueColor])
        return myTitle
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        var countRow : Int = listOfIntRewards1.count
        
        if pickerView == intPicker2{
            countRow = listOfIntRewards2.count
        }
        
        return countRow
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == intPicker1{
            let reward = listOfIntRewards1[row]
            return reward
        }else if pickerView == intPicker2{
            let reward = listOfIntRewards2[row]
            return reward
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == intPicker1{
            intReward1 = self.listOfIntRewards1[row]
            
            if intReward1 == "Enter Custom Reward Above"{
                self.intField1.becomeFirstResponder()
            }
            self.intField1.text = intReward1!
            self.intPicker1.isHidden = true
            self.intField2.isHidden = false
            self.intField2.isEnabled = true
            
        }else if pickerView == intPicker2{
            intReward2 = self.listOfIntRewards2[row]
            if intReward2 == "Enter Custom Reward Above"{
                self.intField2.becomeFirstResponder()
            }
            self.intField2.text = intReward2
            self.intPicker2.isHidden = true
            self.intField1.isEnabled = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.intField1{
            self.intPicker1.isHidden = false
            self.intField2.isHidden = true
            
            if intReward1 != "Enter Custom Reward Above"{
                intField2.isEnabled = false
                textField.endEditing(true)}
            
        }
        if textField == self.intField2{
            self.intPicker2.isHidden = false
            if intReward2 != "Enter Custom Reward Above"{
                textField.endEditing(true)
                intField1.isEnabled = false}
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.intField1 {
            intReward1 = textField.text
        }
        if textField == self.intField2{
            intReward2 = textField.text
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.intField2.endEditing(true)
        self.intField1.endEditing(true)
    }
}



