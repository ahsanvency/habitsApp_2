//
//  pickHabitVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import TransitionButton

class pickHabitVC: CustomTransitionViewController{

    @IBOutlet weak var habitCarousel: iCarousel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var nextButtonHidden: GlossyButton!
    
    
    //Carousel variables
    var habits = habitModel.getHabit()
    let customWidth:CGFloat = 200
    let customHeight:CGFloat = 200
    var habitsCarouselPicker: habitCarouselSelector!
    
    var rotationAngle: CGFloat!
    let width: CGFloat = 100
    let height: CGFloat = 100
    
    //Creating the variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var rect = CGRect(x: nextButtonHidden.frame.origin.x, y: nextButtonHidden.frame.origin.y, width: nextButtonHidden.frame.width, height: nextButtonHidden.frame.height)
        var glossyBtn = GlossyButton(frame: rect, withBackgroundColor: blueColor)
        glossyBtn?.setTitle("NEXT", for: .normal)
        glossyBtn?.titleLabel?.font = UIFont(name: "D-DIN-BOLD", size: 24)
        glossyBtn?.addTarget(self, action:#selector(nextScreen(_:)), for: .touchUpInside)
        
        view.addSubview(glossyBtn!)
//        backgroundImg.bigBlurImage(targetImageView: backgroundImg, with: .light)
        
        habitsCarouselPicker = habitCarouselSelector()
        habitsCarouselPicker.habits = habitModel.getHabit()
        
        habitCarousel.delegate = habitsCarouselPicker
        habitCarousel.dataSource = habitsCarouselPicker
        
        habitCarousel.reloadData()
        habitCarousel.type = .linear
        habitCarousel.centerItemWhenSelected = true
    }
    
    @IBAction func nextScreen(_ glossyBtn: GlossyButton){
        let selectedHabit = habitsCarouselPicker.habits[habitCarousel.currentItemIndex]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let habitInfo = storyBoard.instantiateViewController(withIdentifier: "habitInfoVCID") as! habitInfoVC
        habitInfo.chosenHabit = selectedHabit
        view.window?.layer.add(rightTransition(duration: 0.5), forKey: nil)
        self.present(habitInfo, animated: false, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        let selectedHabit = habitsCarouselPicker.habits[habitCarousel.currentItemIndex]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let habitInfo = storyBoard.instantiateViewController(withIdentifier: "habitInfoVCID") as! habitInfoVC
        habitInfo.chosenHabit = selectedHabit
        
        view.window?.layer.add(rightTransition(duration: 0.5), forKey: nil)
        self.present(habitInfo, animated: false, completion: nil)
        
    }
}
