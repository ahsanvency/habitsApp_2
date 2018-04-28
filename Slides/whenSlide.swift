//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import MultiSelectSegmentedControl

class whenSlide: UIView {
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: MultiSelectSegmentedControl!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    var timeDict:Dictionary = [String:Int]()
    var weekArray = [Int]()
    
    var daysOfWeekStr = ""
    var timeStr = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        let indexSet = NSMutableIndexSet()
        weekArray.forEach(indexSet.add)
        segmentedControl.selectedSegmentIndexes = indexSet as IndexSet!
//        backgroundImg.makeBlurImage(targetImageView: backgroundImg, with: .light)
        

    }
    
    @IBAction func segmentSelected(_ sender: Any) {
        weekArray = []
        for x in segmentedControl.selectedSegmentIndexes{
            weekArray.append(Int(x))
        }
    }
    
    func save(){
        let time = timePicker.date
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: time)
        
        guard let hour = components.hour else
        {   print("error")
            return
        }
        guard let minute = components.minute else
        {
            print("error")
            return
        }
        
        timeDict["hour"] = hour
        timeDict["minute"] = minute
        var daysOfWeekList = ["sa","su","m","t","w","th","f"]
        for x in weekArray{
            daysOfWeekStr += daysOfWeekList[x] + " "
        }
        
        //handles formatting time
        if timeStr == ""{
        if hour > 11 {
            if hour > 12{
                timeStr += String(hour - 12) + ":"
            } else {
                timeStr += String(hour) + ":"
            }
            if minute < 10{
                timeStr +=  "0" + String(minute) + " PM"
                
            } else {
                timeStr += String(minute) + " PM"
            }
        }else {
            if hour == 0 {
                timeStr +=  "12" + ":"
            } else {
                timeStr += String(hour) + ":"
            }
            
            if minute < 10{
                timeStr +=  "0" + String(minute) + " PM"
                
            } else {
                timeStr += String(minute) + " AM"
            }
        }
        }else{
            timeStr = ""
            if hour > 11 {
                if hour > 12{
                    timeStr += String(hour - 12) + ":"
                } else {
                    timeStr += String(hour) + ":"
                }
                if minute < 10{
                    timeStr +=  "0" + String(minute) + " PM"
                    
                } else {
                    timeStr += String(minute) + " PM"
                }
            }else {
                if hour == 0 {
                    timeStr +=  "12" + ":"
                } else {
                    timeStr += String(hour) + ":"
                }
                
                if minute < 10{
                    timeStr +=  "0" + String(minute) + " PM"
                    
                } else {
                    timeStr += String(minute) + " AM"
                }
        }
    }
    }
}

