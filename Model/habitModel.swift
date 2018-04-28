//
//  habitModel.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation
import UIKit

class habitModel{
    class func getHabit() -> [Habit] {
        
        var habits = [Habit]()
        
        
        habits.append(Habit(habitName: "Running", habitPic: UIImage(named: "Running")!, intrinsicReason: "\"Feel Healthier\" or \"Enhance Mood\"", habitVerb: "Run"))
        habits.append(Habit(habitName: "Meditating", habitPic: UIImage(named: "Meditating")!, intrinsicReason: "\"Peace of Mind\" or \"Inner Purity\"", habitVerb: "Meditate"))
        habits.append(Habit(habitName: "Coding", habitPic: UIImage(named: "Coding")!, intrinsicReason: "\"Learn a New Skill\" or \"Solve Problems\"", habitVerb: "Code"))
        habits.append(Habit(habitName: "Journaling", habitPic: UIImage(named: "Journaling")!, intrinsicReason: "\"Calm Emotions\" or \"Better Emotional Intelligence\"", habitVerb: "Journal"))
        habits.append(Habit(habitName: "Eating Healthy", habitPic: UIImage(named: "Eating Healthy")!, intrinsicReason: "\"Feel Cleaner\" or \"Have More Energy\"", habitVerb: "Eat Healthy"))
        habits.append(Habit(habitName: "Praying", habitPic: UIImage(named: "Praying")!, intrinsicReason: "\"Feel at Peace\" or \"Show Gratitude\"", habitVerb: "Pray"))
        habits.append(Habit(habitName: "Reading", habitPic: UIImage(named: "Reading")!, intrinsicReason: "\"Gain Knowledge\" or \"Stimulate Imagination\"", habitVerb: "Read"))
        habits.append(Habit(habitName: "Act Of Kindness", habitPic: UIImage(named: "Act Of Kindness")!, intrinsicReason: "\"Better Relationships\" or \"Pay it Forward\"", habitVerb: "Perform an act of Kindness"))
        habits.append(Habit(habitName: "Lifting", habitPic: UIImage(named: "Lifting")!, intrinsicReason: "\"Physical Health\" or \"Enhance Mood\"", habitVerb: "Lift"))
        habits.append(Habit(habitName: "Waking Up Early", habitPic: UIImage(named: "Waking Up Early")!, intrinsicReason: "\"Be More Productive\" or \"Have More Time\"", habitVerb: "Wake Up Early"))
        habits.append(Habit(habitName: "Sleeping On Time", habitPic: UIImage(named: "Sleeping On Time")!, intrinsicReason: "\"More Energy\" or \"Better Focus\"", habitVerb: "Sleep On Time"))
        
        return habits 
    }
    
}
