//
//  HabitCell.swift
//  Habits
//
//  Created by Ahsan Vency on 1/5/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase

class HabitCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var habitPic: UIImageView!
    @IBOutlet weak var whyLbl: UILabel!
    @IBOutlet weak var whenLbl: UILabel!
    @IBOutlet weak var whereLbl: UILabel!
    @IBOutlet weak var progressBar: CustomProgressView!
    
    var success: Double?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 15);
        progressBar.tintColor = blueColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            
            guard let user = Auth.auth().currentUser else {
                return
            }
            let uid = user.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                //getting habit key
                guard let firstKey = value?.allKeys[0] else {
                    return }
                //using habit key to get dict
                let firstDict = value![firstKey] as! Dictionary<String,Any>
                var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
                self.success = rewardsDict!["Success"] as? Double
               
                self.progressBar.progress = Float(self.success!/30)
                self.progressBar.tintColor = blueColor
                
                //getting dict values and assigning them to labels
                self.nameLbl.text = firstDict["name"] as? String
                self.whyLbl.text = firstDict["Why"] as? String
                self.whereLbl.text =  firstDict["Where"] as? String
                self.habitPic.image = UIImage(named: "\(self.nameLbl.text!)" )
                
                
                //updating when feild
                let daysDict: Dictionary = [0:"Sat",1:"Sun",2:"Mon",3:"Tue",4:"Wed",5:"Thu",6:"Fri"]
                
                func getDayOfWeek()->Int {
                    let time = Date()
                    
                    let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                    let myComponents = myCalendar.components(.weekday, from: time)
                    let weekDay = myComponents.weekday
                    return weekDay!
                }
                let cDay = getDayOfWeek()
                let fbTime  =  firstDict["When"] as? String
                let fbParseTime = fbTime?.split(separator: " ")//
                let fbLength = fbParseTime?.count
                let fbTimeVal = fbParseTime![fbLength! - 2 ..< fbLength! ]
                var fbTimeArray = [String]()
                var fbNewTime = ""
                for x in fbTimeVal {
                    fbTimeArray.append(String(x))
                    fbNewTime += x + " "
                }

                //getting habit days
                let workDaysNS: NSArray = firstDict["freq"]! as! NSArray
                var workDaysArray: Array = [Any]()
                for x in workDaysNS{
                    workDaysArray.append(x)
                }
                
                
                //fb values
                let currentHabitTimeMin =  Int(fbTimeArray[0].split(separator: ":")[1])
                var currentHabitTimeHours = Int(fbTimeArray[0].split(separator: ":")[0])
                
                if fbTimeArray[1] == "PM"{
                    currentHabitTimeHours! += 12
                }
                
                //current vals
                let date = Date()
                let calendar = Calendar.current
                let chour = calendar.component(.hour, from: date)
                let cminutes = calendar.component(.minute, from: date)
                
                
                if (chour >= currentHabitTimeHours! && cminutes > currentHabitTimeMin!){
                    //start get next workout
                    var gotWorkOut = false
                    //Check 1
                    for x in workDaysArray{

                        var check = x as! Int
                    }
                    
                    //check 2
                    if  gotWorkOut == false {
                        var lowerDays = [Int]()
                        var higherDays = [Int]()
                        
                        for x in workDaysArray{
                            var value = x as! Int
                            if value < cDay {
                                lowerDays.append(value)
                            } else if value > cDay {
                                higherDays.append(value)
                            }
                            
                        }
                        
                        if higherDays.count != 0 {
                            self.whenLbl.text = daysDict[higherDays[0]]! + " " + fbNewTime
                            gotWorkOut = true
                            
                        } else if lowerDays.count != 0 {
                            self.whenLbl.text = daysDict[lowerDays[0]]! + " " + fbNewTime
                            gotWorkOut = true
                            
                        } else {
                            self.whenLbl.text = daysDict[cDay]! + " " + fbNewTime
                            gotWorkOut = true
                            
                        }
                    }
                } else {
                    
                    //start get next workout
                    var gotWorkOut = false
                    //Check 1
                    for x in workDaysArray{

                        var check = x as! Int
                        
                        if  check == cDay{
                            
                            self.whenLbl.text = daysDict[cDay]! + " " + fbNewTime
                            gotWorkOut = true
                        }
                    }
                    
                    //check 2
                    if  gotWorkOut == false {
                        var lowerDays = [Int]()
                        var higherDays = [Int]()
                        
                        for x in workDaysArray{
                            let value = x as! Int
                            if value < cDay {
                                lowerDays.append(value)
                            } else if value > cDay {
                                higherDays.append(value)
                            }
                            
                        }
                        
                        if higherDays.count != 0 {
                            self.whenLbl.text = daysDict[higherDays[0]]! + " " + fbNewTime
                            gotWorkOut = true
                            
                        } else if lowerDays.count != 0 {
                            self.whenLbl.text = daysDict[lowerDays[0]]! + " " + fbNewTime
                            gotWorkOut = true
                            
                        } else {
                            self.whenLbl.text = daysDict[cDay]! + " " + fbNewTime
                            gotWorkOut = true
                            
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        })
    }
    
    func reload(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        let uid = user.uid
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
        
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            //getting habit key
            guard let firstKey = value?.allKeys[0] else {
                return }
            //using habit key to get dict
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            
            
            //getting dict values and assigning them to labels
            self.nameLbl.text = firstDict["name"] as? String
            self.whyLbl.text = firstDict["Why"] as? String
            self.whenLbl.text = firstDict["When"] as? String
            self.whereLbl.text =  firstDict["Where"] as? String
            self.habitPic.image = UIImage(named: self.nameLbl.text! )
            
            //WHY WONT THIS UPDATE
            var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
            self.success = rewardsDict!["Success"] as? Double
    
            self.progressBar.progress = Float(self.success!/30)
            self.progressBar.tintColor = blueColor
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}

