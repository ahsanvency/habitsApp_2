//
//  MainVC.swift
//  Habits
//
//  Created by Ahsan Vency on 4/13/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//


import UIKit
import Firebase
import SwiftKeychainWrapper
import UserNotifications
import TransitionButton
import KDCircularProgress

class MainVC: CustomTransitionViewController {

    
    @IBOutlet var loadingView: UIView!
    
    
    //Outlets for the habit
    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var habitPic: UIImageView!
    @IBOutlet weak var whyAtWherelabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var successfulDays: UILabel!
    
    
    @IBOutlet weak var backgroundLeadingConstraint: NSLayoutConstraint!
    
    
    //Variables for random popups
    var intrinsicQuestions = [String]()
    var randomPopupNumber = 7
    var habitName: String?

    
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.updateHabit()
            self.notif()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        showLoadingScreen()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
        }
        
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            //getting habit key
            //            guard let firstKey = value?.allKeys[0] else{
            guard (value?.allKeys[0]) != nil else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "pickHabitVCID") as! pickHabitVC
                self.present(newViewController, animated: true, completion: nil)
                return
            }
        })
    }
    
    func showLoadingScreen(){
        loadingView.bounds.size.width = view.bounds.width
        loadingView.bounds.size.height = view.bounds.height
        loadingView.center = view.center
        loadingView.alpha = 1.0
        view.addSubview(loadingView)
        
        UIView.animate(withDuration: 1, delay: 0.7, options: [], animations: {
            self.loadingView.alpha = 0
        }) { (success) in
            
        }
    }
    
    
    func updateHabit(){
        
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                //getting habit key
                guard let firstKey = value?.allKeys[0] else {
                    return }
                //using habit key to get dict
                let firstDict = value![firstKey] as! Dictionary<String,Any>
                var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
                
                let whyText = firstDict["Why"] as! String
                let whereText = firstDict["Where"] as! String
                
                self.habitNameLabel.text = (firstDict["name"] as! String)
                self.habitPic.image = UIImage(named: firstDict["name"] as! String)
                self.whyAtWherelabel.text = "\(whyText) at \(whereText)"
                self.progressView.angle = Double(360 * Float(rewardsDict!["Success"] as! Double/30))
                self.successfulDays.text = "\(rewardsDict!["Success"]!)"

                
                let daysDict: Dictionary = [0:"Saturday",1:"Sunday",2:"Monday",3:"Tuesday",4:"Wednesday",5:"Thursday",6:"Friday"]
                
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
                            let value = x as! Int
                            if value < cDay {
                                lowerDays.append(value)
                            } else if value > cDay {
                                higherDays.append(value)
                            }
                            
                        }
                        
                        if higherDays.count != 0 {
                            self.whenLabel.text = "Next:  \(daysDict[higherDays[0]]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                            
                        } else if lowerDays.count != 0 {
                            self.whenLabel.text = "Next:  \(daysDict[lowerDays[0]]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                        } else {
                            self.whenLabel.text = "Next:  \(daysDict[cDay]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                        }
                    }
                } else {
                    
                    //start get next workout
                    var gotWorkOut = false
                    //Check 1
                    for x in workDaysArray{
                        
                        let check = x as! Int
                        
                        if  check == cDay{
                            
                            self.whenLabel.text = "Next:  \(daysDict[cDay]!) at \(fbNewTime)"
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
                            self.whenLabel.text = "Next:  \(daysDict[higherDays[0]]!) at \(fbNewTime)"
                            
                            gotWorkOut = true
                            
                        } else if lowerDays.count != 0 {
                            self.whenLabel.text = "Next:  \(daysDict[lowerDays[0]]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                        } else {
                            self.whenLabel.text = "Next:  \(daysDict[cDay]!) at \(fbNewTime)"
                            gotWorkOut = true
                            
                        }
                    }
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
//        })
    }
    
    @IBAction func achievedButon(_ sender: Any) {
        
        //current user
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        //let uid = user.uid
        
        //Gets the Habit id
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //getting habit key
            guard let firstKey = value?.allKeys[0] else {
                print("n")
                return }
            
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            
            var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
            let success = rewardsDict!["Success"] as? Int
            
            switch (success!){
            case 5..<10:
                self.randomPopupNumber = 5;
            case 10..<20:
                self.randomPopupNumber = 3;
            case 20..<31:
                self.randomPopupNumber = 2;
            default:
                self.randomPopupNumber = 10;
                break;
            }
            self.habitName = (firstDict["name"] as! String)
            
            self.intrinsicQuestions = ["How are you progressing with \(self.habitName!)?",
                "Why do you want to continue \(self.habitName!)?",
                "How does \(self.habitName!) relate to your values?",
                "What do you gain by \(self.habitName!)?"]
            
            let test = Int(arc4random_uniform(UInt32(self.randomPopupNumber)))
            if test == 0 {
                let intrinsicAlert = UIAlertController(title: "Intrinsic Reminder", message: self.intrinsicQuestions[Int(arc4random_uniform(UInt32(self.intrinsicQuestions.count)))], preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    if let textField = intrinsicAlert.textFields?[0]{
                        if textField.text == ""{
                            self.present(intrinsicAlert, animated: true, completion: nil)
                        } else{
                            self.performSegue(withIdentifier: "toRewardsScreen", sender: self)
                        }
                    }
                })
                intrinsicAlert.addAction(okAction)
                intrinsicAlert.addTextField(configurationHandler: nil)
                self.present(intrinsicAlert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "toRewardsScreen", sender: nil)
            }
        })
    }
    
    @IBAction func logOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        //        dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginID") as! loginVC
        view.window?.layer.add(bottomTransition(duration: 0.5), forKey: nil)
        self.present(newViewController, animated: false, completion: nil)
    }
    
    func notif(){
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            //getting habit key
            guard let firstKey = value?.allKeys[0] else {
                print("n")
                return }
            
            //using habit key to get dict
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            
            self.habitName = (firstDict["name"] as! String)
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
            //fb values
            guard let currentHabitTimeMin =  Int(fbTimeArray[0].split(separator: ":")[1]) else {
                print("error")
                return
            }
            guard let  currentHabitTimeHours = Int(fbTimeArray[0].split(separator: ":")[0]) else {
                print("error")
                return
            }
            
            //Creates the notification
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            //        content.subtitle = "They are up now"
            
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            content.body = "In one hour its time to \(String(describing: self.habitName))."
            //App icon for the badge
            content.badge = 1
            var date = DateComponents()
            date.hour = currentHabitTimeHours - 1
            date.minute = currentHabitTimeMin
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            //Adds to the notification center which has the job of displaying it
            
            UNUserNotificationCenter.current().add(request) { (error) in
            }
            
        })
    }
    
}
