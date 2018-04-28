//
//  rewardsVC.swift
//  rewardsScreen
//
//  Created by Ahsan Vency on 1/26/18.
//  Copyright © 2018 Ahsan Vency. All rights reserved.


import UIKit
import Firebase

class rewardsVC: UIViewController {
    
    //Variables
    var blinkDuration = 1.0
    var blinkIsOn = false
    var spinFast = 0.01;
    var spinMedium = 0.075;
    var spinSlow = 0.1;
    var isSpinning = false
    
    
    struct slotComp{
        var image: UIImage!
        var reward: String!
    }
    
    var glossyBtn = GlossyButton()
    
    var items = [slotComp]()
    
    //Timers
    var timerLeft = Timer()
    var timerMiddle = Timer()
    var timerRight = Timer()
    var timerGetReadyForNextSpin = Timer()
    var timerWin = Timer()
    var timerUpAlert = Timer()
    
    
    var success: Int?
    
    var basicGap: Int?
    var basicGap1: Int?
    var intermediateGap: Int?
    var intermediateGap1: Int?
    var advancedGap: Int?
    
    
    //Number of times to spin each column
    var numberOfTimesSpinLeft: Int!
    var numberOfTimesSpinMiddle: Int!
    var numberOfTimesSpinRight: Int!
    
    //Tracks how many times it currenly spun
    var leftCurrentSpinCount = 0
    var middleCurrentSpinCount = 0
    var rightCurrentSpinCount = 0
    
    //The value that was ultimately selected
    var selectedItemLeft: Int!
    var selectedItemMiddle: Int!
    var selectedItemRight: Int!
    
    //Other Outlets
    @IBOutlet weak var spinBtn: UIButton!
    @IBOutlet weak var slotsView: UIView!
    
    
    //Left Column
    @IBOutlet weak var left1Top: UIImageView!
    @IBOutlet weak var left1Bottom: UIImageView!
    @IBOutlet weak var left2Top: UIImageView!
    @IBOutlet weak var left2Bottom: UIImageView!
    @IBOutlet weak var left3Top: UIImageView!
    @IBOutlet weak var left3Bottom: UIImageView!
    
    //middle Column
    @IBOutlet weak var middle1Top: UIImageView!
    @IBOutlet weak var middle1Bottom: UIImageView!
    @IBOutlet weak var middle2Top: UIImageView!
    @IBOutlet weak var middle2Bottom: UIImageView!
    @IBOutlet weak var middle3Top: UIImageView!
    @IBOutlet weak var middle3Bottom: UIImageView!
    
    //right Column
    @IBOutlet weak var right1Top: UIImageView!
    @IBOutlet weak var right1Bottom: UIImageView!
    @IBOutlet weak var right2Top: UIImageView!
    @IBOutlet weak var right2Bottom: UIImageView!
    @IBOutlet weak var right3Top: UIImageView!
    @IBOutlet weak var right3Bottom: UIImageView!
    
    
    let basicTop = slotComp(image: UIImage(named: "basicTop"), reward: "Basic")
    let basicBottom = slotComp(image: UIImage(named: "basicBottom"), reward: "Basic")
    let intTop = slotComp(image: UIImage(named: "intTop"), reward: "Intermediate")
    let intBottom = slotComp(image: UIImage(named: "intBottom"), reward: "Intermediate")
    let advTop = slotComp(image: UIImage(named: "advTop"), reward: "Advanced")
    let advBottom = slotComp(image: UIImage(named: "advBottom"), reward: "Advanced")
//    let whiteTop = slotComp(image: nil, reward: "nil")
//    let whiteBottom = slotComp(image: nil, reward: "nil")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        
        basicGap = 5
        basicGap1 = 10
        intermediateGap = 6
        intermediateGap1 = 5
        advancedGap = 4
        
        shadowlayer()
        
        
        rotateitems(index: selectedItemLeft, columnIndex: 1)
        rotateitems(index: selectedItemMiddle, columnIndex: 2)
        rotateitems(index: selectedItemRight, columnIndex: 3)
    }
    
    var canRun = true
    func updateSuccess(){
        //current user
        guard let user = Auth.auth().currentUser else {
            return
        }
        let uid = user.uid
        //Gets the Habit id
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //getting habit key
            guard let firstKey = value?.allKeys[0] else {
                print("n")
                return }
            
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            
            var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
            self.success = (rewardsDict!["Success"] as? Int)!
            
            let time = Date.init()
            let calender = Calendar.current
            let components = calender.dateComponents([.day], from: time)
            guard let day = components.day else
            {   print("error")
                return
            }
            
            if let prevSpunDay = rewardsDict!["SpunDay"] as? Int{
                
//                if prevSpunDay == day {
                if day - 1 == day{
                    //alert
                    let spinAlert = UIAlertController(title: "Alert", message: "Can only play once a day", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in})
                    spinAlert.addAction(okAction)
                    self.present(spinAlert, animated: true, completion: nil)

                } else {
                    self.success = self.success! + 1
                    DataService.ds.REF_HABITS.child(uid).child("\(firstKey)").child("Rewards").updateChildValues(["Success": self.success!,"SpunDay":day])
                    self.runSpin()
                }
            } else {
                self.success = self.success! + 1
                DataService.ds.REF_HABITS.child(uid).child("\(firstKey)").child("Rewards").updateChildValues(["Success": self.success!,"SpunDay":day])
                self.runSpin()
            }
        })
    }
    
    
    @IBAction func spinButton(_ sender: Any) {
        
        if (isSpinning){
            return
        }
        updateSuccess()
    }
    
    func prepareNextSpin(){
        //can eventually delete these to replace it with returnStop in the functions below
        let stopLeft = returnStop()
        let stopMiddle = returnStop()
        let stopRight = returnStop()
//        let stopLeft = 1
//        let stopMiddle = 3
//        let stopRight = 5
        
        //Generates the number of times for each column to spin
        numberOfTimesSpinLeft = 68 * Int(arc4random_uniform(UInt32(3))+2) - stopLeft + selectedItemLeft
        
        numberOfTimesSpinMiddle = 68 * Int(arc4random_uniform(UInt32(3))+2) - stopMiddle + selectedItemMiddle

        numberOfTimesSpinRight = 68 * Int(arc4random_uniform(UInt32(3))+2) - stopRight + selectedItemRight

        
        leftCurrentSpinCount = 0;
        middleCurrentSpinCount = 0;
        rightCurrentSpinCount = 0;
        blinkDuration = 1.0;
    }
    
    @objc func updateLeft(){
        if (isSpinning) == false{
            return
        }
        leftCurrentSpinCount = leftCurrentSpinCount + 1
        if (leftCurrentSpinCount <= numberOfTimesSpinLeft){
            selectedItemLeft = selectedItemLeft - 1
            if selectedItemLeft == -1 {
                selectedItemLeft = 33
            }
            rotateitems(index: selectedItemLeft, columnIndex: 1)
        }
        if Double(leftCurrentSpinCount) > Double(numberOfTimesSpinLeft) / 1.2{
            timerLeft.invalidate()
            timerLeft = Timer.scheduledTimer(timeInterval: spinSlow, target:self, selector: #selector(updateLeft), userInfo: nil, repeats: true)
        }
        if leftCurrentSpinCount >= numberOfTimesSpinLeft{
            timerLeft.invalidate()
        }
        
        if leftCurrentSpinCount >= numberOfTimesSpinLeft && middleCurrentSpinCount >= numberOfTimesSpinMiddle && rightCurrentSpinCount >= numberOfTimesSpinRight {
            checkRewards()
        }
    }
    
    @objc func updateMiddle(){
        if (isSpinning) == false{
            return
        }
        middleCurrentSpinCount = middleCurrentSpinCount + 1
        
        if (middleCurrentSpinCount <= numberOfTimesSpinMiddle){
            selectedItemMiddle = selectedItemMiddle - 1
            if selectedItemMiddle == -1 {
                selectedItemMiddle = 33
            }
            rotateitems(index: selectedItemMiddle, columnIndex: 2)
        }
        if Double(middleCurrentSpinCount) > Double(numberOfTimesSpinMiddle) / 1.2{
            timerMiddle.invalidate()
            timerMiddle = Timer.scheduledTimer(timeInterval: spinSlow, target:self, selector: #selector(updateMiddle), userInfo: nil, repeats: true)
        }
        
        if middleCurrentSpinCount >= numberOfTimesSpinMiddle{
            timerMiddle.invalidate()
        }
        
        if leftCurrentSpinCount >= numberOfTimesSpinLeft && middleCurrentSpinCount >= numberOfTimesSpinMiddle && rightCurrentSpinCount >= numberOfTimesSpinRight {
            checkRewards()
        }
    }
    
    @objc func updateRight(){
        if (isSpinning) == false{
            return
        }
        
        rightCurrentSpinCount = rightCurrentSpinCount + 1
        
        if (rightCurrentSpinCount <= numberOfTimesSpinRight){
            selectedItemRight = selectedItemRight - 1
            if selectedItemRight == -1 {
                selectedItemRight = 33
            }
            rotateitems(index: selectedItemRight, columnIndex: 3)
        }
        
        if Double(rightCurrentSpinCount) > Double(numberOfTimesSpinRight) / 1.2{
            timerRight.invalidate()
            timerRight = Timer.scheduledTimer(timeInterval: spinSlow, target:self, selector: #selector(updateRight), userInfo: nil, repeats: true)
        }
        if rightCurrentSpinCount >= numberOfTimesSpinRight{
            timerRight.invalidate()
        }
        
        if leftCurrentSpinCount >= numberOfTimesSpinLeft && middleCurrentSpinCount >= numberOfTimesSpinMiddle && rightCurrentSpinCount >= numberOfTimesSpinRight {
            timerRight.invalidate()
            checkRewards()
        }
    }
    
    func rotateitems(index: Int, columnIndex: Int){
        var imageTop1: UIImageView
        var imageBottom1: UIImageView
        var imageTop2: UIImageView
        var imageBottom2: UIImageView
        var imageTop3: UIImageView
        var imageBottom3: UIImageView
        
        switch (columnIndex){
        case 1:
            imageTop1 = left1Top
            imageBottom1 = left1Bottom
            imageTop2 = left2Top
            imageBottom2 = left2Bottom
            imageTop3 = left3Top
            imageBottom3 = left3Bottom
        case 2:
            imageTop1 = middle1Top
            imageBottom1 = middle1Bottom
            imageTop2 = middle2Top
            imageBottom2 = middle2Bottom
            imageTop3 = middle3Top
            imageBottom3 = middle3Bottom
        case 3:
            imageTop1 = right1Top
            imageBottom1 = right1Bottom
            imageTop2 = right2Top
            imageBottom2 = right2Bottom
            imageTop3 = right3Top
            imageBottom3 = right3Bottom
        default:
            imageTop1 = left1Top
            imageBottom1 = left1Bottom
            imageTop2 = left2Top
            imageBottom2 = left2Bottom
            imageTop3 = left3Top
            imageBottom3 = left3Bottom
        }
        
        var index1Top = index - 3
        if index1Top == -3{
            index1Top = 31
        }else if index1Top == -2{
            index1Top = 32
        }else if index1Top == -1{
            index1Top = 33
        }
        
        var index1Bottom = index - 2
        if index1Bottom == -2{
            index1Bottom = 32
        }else if index1Bottom == -1{
            index1Bottom = 33
        }
        
        var index2Top = index - 1
        if index2Top == -1{
            index2Top = 33
        }
        
        let index2Bottom = index
        
        var index3Top = index + 1
        if index3Top == 34{
            index3Top = 0
        }
        
        
        var index3Bottom = index + 2
        if index3Bottom == 35{
            index3Bottom = 1
        }else if index3Bottom == 34{
            index3Bottom = 0
        }
        imageTop1.image = items[index1Top].image
        imageBottom1.image = items[index1Bottom].image
        imageTop2.image = items[index2Top].image
        imageBottom2.image = items[index2Bottom].image
        imageTop3.image = items[index3Top].image
        imageBottom3.image = items[index3Bottom].image
    }
    
    func checkRewards(){
        let leftCheck = items[selectedItemLeft].reward
        let middleCheck = items[selectedItemMiddle].reward
        let rightCheck = items[selectedItemRight].reward
        
        //current user
        guard let user = Auth.auth().currentUser else {
            return
        }
        let uid = user.uid
        
        //Gets the Habit id
        DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //getting habit key
            guard let firstKey = value?.allKeys[0] else {
                print("n")
                return }
            
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            
            var rewardsDict = firstDict["Rewards"] as? Dictionary<String, Any>
            let randomMessage = Int(arc4random_uniform(UInt32(2)))
            
            var basicMessage = ""
            var intMessage = ""
            
            if randomMessage == 0{
                basicMessage = "Good effort you have earned: \(rewardsDict!["basicReward1"]!)"
                intMessage = "Congratulations you have earned: \(rewardsDict!["intReward1"]!)"
            }else{
                basicMessage = "Good effort you have earned: \(rewardsDict!["basicReward2"]!)"
                intMessage = "Congratulations you have earned: \(rewardsDict!["intReward2"]!)"
            }
            
            let advMessage = "You really deserve this: \(rewardsDict!["advReward"]!)"
            
            if leftCheck == "Basic" && middleCheck == "Basic" && rightCheck == "Basic"{
                self.winner()
                self.upAlert(messages: basicMessage)
            }
            else if ((leftCheck == "Basic" && middleCheck == "Basic") || (leftCheck == "Basic" && rightCheck == "Basic") || (middleCheck == "Basic" && rightCheck == "Basic")) && (leftCheck == "Advanced" || middleCheck == "Advanced" || rightCheck == "Advanced"){
                self.winner()
                self.upAlert(messages: basicMessage)
            }
            else if leftCheck == "Intermediate" && middleCheck == "Intermediate" && rightCheck == "Intermediate"{
                self.winner()
                self.upAlert(messages: intMessage)
            }
            else if ((leftCheck == "Intermediate" && middleCheck == "Intermediate") || (leftCheck == "Intermediate" && rightCheck == "Intermediate") || (middleCheck == "Intermediate" && rightCheck == "Intermediate")) && (leftCheck == "Advanced" || middleCheck == "Advanced" || rightCheck == "Advanced"){
                self.winner()
                self.upAlert(messages: intMessage)
            }
            else if leftCheck == "Advanced" && middleCheck == "Advanced" && rightCheck == "Advanced"{
                self.winner()
                self.upAlert(messages: advMessage)
            }else if (leftCheck == "Advanced" && middleCheck == "Advanced") || (leftCheck == "Advanced" && rightCheck == "Advanced") && (middleCheck == "Advanced" && rightCheck == "Advanced") && (leftCheck == "Basic" || middleCheck == "Basic" || rightCheck == "Basic"){
                self.winner()
                self.upAlert(messages: intMessage)
            }
            else if (leftCheck == "Advanced" && middleCheck == "Advanced") || (leftCheck == "Advanced" && rightCheck == "Advanced") && (middleCheck == "Advanced" && rightCheck == "Advanced") && (leftCheck == "Intermediate" || middleCheck == "Intermediate" || rightCheck == "Intermediate"){
                self.winner()
                self.upAlert(messages: advMessage)
            }
            else {
                self.getReadyForNextSpin()
            }
        })
    }
    
    @objc func getReadyForNextSpin(){
        isSpinning = false
        glossyBtn.setTitle("SPIN", for: .normal)
//        spinBtnLbl.text = "SPIN"
        //spinBtn.setTitle("SPIN", for: UIControlState.normal)
        spinBtn.isEnabled = true
        glossyBtn.backgroundColor = blueColor
//        spinBtn.backgroundColor = blueColor
        timerGetReadyForNextSpin.invalidate()
    }
    
    func startBlinking(){
        timerWin = Timer.scheduledTimer(timeInterval: blinkDuration, target:self, selector: #selector(Blink), userInfo: nil, repeats: true)
    }
    
    //This code can stay relatively similar because of the changes
    @objc func Blink(){
        blinkDuration = blinkDuration - 0.15
        if blinkDuration <= 0 {
            timerWin.invalidate()
            //let image = items[selectedItemLeft].image
            left2Top.image = items[selectedItemLeft - 1].image
            middle2Top.image = items[selectedItemMiddle - 1].image
            right2Top.image = items[selectedItemRight - 1].image
            left2Bottom.image = items[selectedItemLeft].image
            middle2Bottom.image = items[selectedItemMiddle].image
            right2Bottom.image = items[selectedItemRight].image
            
        }else{
            blinkIsOn = !blinkIsOn
            if blinkIsOn{
                //let imageName = ""
                left2Top.image = nil
                middle2Top.image = nil
                right2Top.image = nil
                left2Bottom.image = nil
                middle2Bottom.image = nil
                right2Bottom.image = nil
            }else{
                left2Top.image = items[selectedItemLeft - 1].image
                middle2Top.image = items[selectedItemMiddle - 1].image
                right2Top.image = items[selectedItemRight - 1].image
                left2Bottom.image = items[selectedItemLeft].image
                middle2Bottom.image = items[selectedItemMiddle].image
                right2Bottom.image = items[selectedItemRight].image
            }
        }
    }
    
    func returnStop() -> Int{
        if (self.success! < 10 && self.success! > 4) || (self.success! > 20 && self.success! < 26){
            intermediateGap = 10
            intermediateGap1 = 10
        }
        
        if (self.success! > 9 && self.success! < 15) || (self.success! > 25 && self.success! < 31){
            advancedGap = 11
        }
        
        let x1 = 1
        let x2 = x1 + basicGap!
        let x3 = x2 + basicGap!
        let x4 = x3 + intermediateGap!
        let x5 = x4 + basicGap1!
        let x6 = x5 + advancedGap!
        let x7 = x6 + basicGap1!
        let x8 = x7 + intermediateGap!
        let x9 = x8 + basicGap!
        let x10 = x9 + basicGap!
        let x11 = x10 + intermediateGap1!
        let x12 = x11 + basicGap1!
        let x13 = x12 + advancedGap!
        let x14 = x13 + basicGap1!
        let x15 = x14 + intermediateGap1!
        let x16 = x15  + basicGap!
        let x17 = x16 + intermediateGap1!
        let x18 = x17 + basicGap!

        
        let rand = Int(arc4random_uniform(UInt32(x18)))
        var stop = 0;
        
        switch rand {
        case x1..<x2:
            if (success! < 16 && success! > 10) || (success! > 25 && success! < 31){
                stop = 4
            }else if (success! < 26 && success! > 20) || (success! > 5 && success! < 11){
                stop = 6
            }else{
                stop = 0
            }
        case x2..<x3:
            stop = 1
        case x3..<x4:
            stop = 2
        case x4..<x5:
            stop = 3
        case x5..<x6:
            stop = 4
        case x6..<x7:
            if (success! < 26 && success! > 20) || (success! > 5 && success! < 11){
                stop = 6
            }else{
                stop = 5
            }
            stop = 5
        case x7..<x8:
            stop = 6
        case x8..<x9:
            if (success! < 16 && success! > 10) || (success! > 25 && success! < 31){
                stop = 4
            }else{
                stop = 7
            }
        case x9..<x10:
            stop = 8
        case x10..<x11:
            stop = 9
        case x11..<x12:
            if (success! < 16 && success! > 10) || (success! > 25 && success! < 31){
                stop = 4
            }else if (success! < 26 && success! > 20) || (success! > 5 && success! < 11){
                stop = 6
            }else{
                stop = 10
            }
        case x12..<x13:
            stop = 11
        case x13..<x14:
            stop = 12
        case x14..<x15:
            if (success! < 16 && success! > 10) || (success! > 25 && success! < 31){
                stop = 11
            }else{
                stop = 13
            }
        case x15..<x16:
            stop = 14
        case x16..<x17:
            stop = 15
        case x17..<x18:
            stop = 16
        default:
            break;
        }
        return stop * 2 + 1;
    }
    
    func winner(){
        glossyBtn.setTitle("WINNER", for: .normal)
//        spinBtnLbl.text = "WINNER"
        //spinBtn.setTitle("WINNER", for: UIControlState.normal)
        glossyBtn.backgroundColor = UIColor.green
//        spinBtn.backgroundColor = UIColor.green
        startBlinking()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.timerGetReadyForNextSpin = Timer.scheduledTimer(timeInterval: 3.0, target:self, selector: #selector(self.getReadyForNextSpin), userInfo: nil, repeats: false)
        })
    }
    
    func upAlert (messages: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            let myAlert = UIAlertController(title: "Winner", message: messages, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        })
    }
    
    @IBAction func backButton(_ sender: Any) {
        view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
       dismiss(animated: false, completion: nil)
    }
    
    func shadowlayer(){
        
        let degrees = 180.0
        let radians = CGFloat(degrees * Double.pi / 180)
        
        
        let layerTop: CALayer = CALayer()
        layerTop.backgroundColor = UIColor.clear.cgColor //Background color of the view added
        layerTop.position = CGPoint(x: slotsView.bounds.width / 2, y:  slotsView.bounds.height - 320) //position of the added view
        layerTop.bounds = CGRect(x: 0, y: 0, width: slotsView.bounds.width, height: 2) //creates a rectange for the added view
        layerTop.shadowColor = UIColor.black.cgColor //shadow color
        layerTop.shadowOffset = CGSize(width: 0,height: 8) //size of the shadow offset
        layerTop.shadowOpacity = 1 //opacity
        layerTop.shadowRadius = 8 //radius of the offset
        //higher radius means more of a gradient
        //Lower radius means a darker shadow
        
        let layerBottom: CALayer = CALayer()
        layerBottom.backgroundColor = UIColor.clear.cgColor
        layerBottom.position = CGPoint(x: slotsView.bounds.width / 2, y: slotsView.bounds.height)
        layerBottom.bounds = CGRect(x: 0, y: 0, width: slotsView.bounds.width, height: 2)
        layerBottom.shadowColor = UIColor.black.cgColor
        layerBottom.shadowOffset = CGSize(width: 0,height: 8)
        layerBottom.shadowOpacity = 1
        layerBottom.shadowRadius = 8
        layerBottom.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        
        slotsView.layer.addSublayer(layerTop)
        slotsView.layer.addSublayer(layerBottom)
        
        items = [basicTop, basicBottom, basicTop, basicBottom, intTop, intBottom, basicTop, basicBottom, advTop, advBottom, basicTop, basicBottom, intTop, intBottom, basicTop, basicBottom, basicTop, basicBottom, intTop, intBottom, basicTop, basicBottom, advTop, advBottom, basicTop, basicBottom, intTop, intBottom, basicTop, basicBottom, intTop, intBottom, basicTop, basicBottom]
        
        isSpinning = false
        selectedItemLeft = Int(arc4random_uniform(UInt32(34)))
        if selectedItemLeft%2 == 0{
            selectedItemLeft = selectedItemLeft + 1
        }
        selectedItemMiddle = Int(arc4random_uniform(UInt32(34)))
        if selectedItemMiddle%2 == 0{
            selectedItemMiddle = selectedItemMiddle + 1
        }
        
        selectedItemRight = Int(arc4random_uniform(UInt32(34)))
        if selectedItemRight%2 == 0{
            selectedItemRight = selectedItemRight + 1
        }
    }
    
    func runSpin(){
        
        
        
        glossyBtn.setTitle("GOOD LUCK", for: .normal)
//        spinBtnLbl.text = "GOOD LUCK"
        //spinBtn.setTitle("Good Luck", for: UIControlState.normal)
        isSpinning = true
        spinBtn.isEnabled = false
        prepareNextSpin()
        timerLeft = Timer.scheduledTimer(timeInterval: spinFast, target:self, selector: #selector(updateLeft), userInfo: nil, repeats: true)
        timerMiddle = Timer.scheduledTimer(timeInterval: spinFast, target:self, selector: #selector(updateMiddle), userInfo: nil, repeats: true)
        timerRight = Timer.scheduledTimer(timeInterval: spinFast, target:self, selector: #selector(updateRight), userInfo: nil, repeats: true)
    }
    
    func setupScreen(){
        let rect = CGRect(x: spinBtn.frame.origin.x, y: spinBtn.frame.origin.y, width: spinBtn.frame.width, height: spinBtn.frame.height)
        glossyBtn = GlossyButton(frame: rect, withBackgroundColor: blueColor)
        glossyBtn.setTitle("SPIN", for: .normal)
        glossyBtn.titleLabel?.font = UIFont(name: "D-DIN-BOLD", size: 36)
        glossyBtn.addTarget(self, action:#selector(spinButton(_:)), for: .touchUpInside)
        view.addSubview(glossyBtn)
        
    }
}



