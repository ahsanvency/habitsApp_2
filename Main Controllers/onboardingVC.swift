//
//  onboardingViewController.swift
//  Habits
//
//  Created by Ahsan Vency on 4/11/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import paper_onboarding

class onboardingVC: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {

    
    @IBOutlet weak var onboardingView: OnboardingView!
    
    @IBOutlet weak var startHabitsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let titleFont = UIFont(name: "D-DIN-BOLD", size: 30)
        let descriptionFont = UIFont(name: "D-DIN", size: 22)
        
        let colorBlue = UIColor(red:13/255, green:76/255, blue:153/255, alpha:0.85)
        let colorRed = UIColor(red:186/255, green:7/255, blue: 29/255, alpha:0.85)
        let colorPurple = UIColor(red:102/255, green:23/255, blue: 108/255, alpha:0.8)
        let colorGreen = UIColor(red:34/255, green:139/255, blue: 34/255, alpha:0.8)
        
        let alphaImageView = UIImageView(image: UIImage(named: "clearCircle"))
        alphaImageView.alpha = 0
        
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "Aristotle")!, title: "Habits Are Everything", description: " \"We are what we repeatedly do. Excellence, then, is not an act, but a habit.\" ~ Aristotle",pageIcon: alphaImageView.image!, color: colorBlue, titleColor: .white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "Intrinsic1")!, title: "Intrinsic Motivation", description: "Doing something for a challenge, better relationships or peronal health helps you become more successful. Think about why you want better habits!",pageIcon: alphaImageView.image!, color: colorRed, titleColor: .white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "Ripple1")!, title: "Keystone Habits", description: "Keystone Habits are simple habits that have ripple effects into other areas of your life. Simply making your bed can make you more productive.",pageIcon: alphaImageView.image!, color: colorPurple, titleColor: .white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "Interval Reinforcement")!, title: "Interval Reinforcement", description: "Proven to be the best way to learn, The Habit Developer uses random rewards to help you develop habits.",pageIcon: alphaImageView.image!, color: colorGreen, titleColor: .white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!)][index]
    }
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 2{
            if self.startHabitsButton.alpha == 1 {
                UIView.animate(withDuration: 0.2) {
                    self.startHabitsButton.alpha = 0
                }
            }
            
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3{
            UIView.animate(withDuration: 0.5) {
                self.startHabitsButton.alpha = 1
            }
        }
    }
    
    @IBAction func onboardingDone(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onBoardingComplete")
        userDefaults.synchronize()
    }
    
}
