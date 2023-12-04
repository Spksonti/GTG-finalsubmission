//
//  HomeGoalsViewController.swift
//  GTG
//
//  Created by Akif Abidi on 11/5/23.
//

import UIKit
import SwiftUI

class HomeGoalsViewController: UIViewController {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var weightGoalLabel: UILabel!
    @IBOutlet weak var fitnessGoalLabel: UILabel!
    //@IBOutlet weak var gymHabitGoalLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        loadGoalsData()
    }
    
    // load goals data
    private func loadGoalsData() {
        
        
        // fitnessGoal
        let fitnessGoal: String = goal.getFitnessGoal()
        
     
        // weightGoal
        let weightChangeGoal: Int = goal.getWeightChangeGoal()
        let currWeight: Int = Int(goal.getCurrWeight())
        let loseOrGainGoal: String = goal.getLoseOrGain()
        
        // Gym Habit Goal
        //let gymHabitGoal: String = goal.getGymHabitGoal()
        
        // Extract month, day and year ----------
        let lastUpdatedDateObject: Date = goal.getLastUpdatedDate()
        let dateFormatter = DateFormatter()
        
        // For abreviated month
        dateFormatter.dateFormat = "MMM"
        let monthString = dateFormatter.string(from: lastUpdatedDateObject)
        
        // Set the date format for the day
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.string(from: lastUpdatedDateObject)
        

        
        // Display goals
        self.headingLabel.text = "Since \(monthString). \(dayString), I want to:"
        self.weightGoalLabel.text = "\(loseOrGainGoal) \(weightChangeGoal) lb from \(currWeight) lbs"
        self.fitnessGoalLabel.text = fitnessGoal
        //self.gymHabitGoalLabel.text = gymHabitGoal // TODO
        
        
    }
    
    // format view after viewLoads
    private func formatView() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06)
        self.view.layer.cornerRadius = 15
    }

}
