//
//  Goal.swift
//  GTG
//
//  Created by Nikhil Meka on 10/12/23.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore


class Goal {
    private var fitnessGoal: String
    private var gainLossVal: Int
    private var currWeight: Double
    private var lastUpdated: Date
    private var loseOrGain: String
    private var freeTimes: [String: [String]] // List of free times on each day of the week
    
//    let userRef = Firestore.firestore().collection("Users").document(userAccount!.uid!)
    
    init(fitnessGoal: String, gainLossVal: Int, currWeight: Double, freeTimes: [String: [String]], lastUpdated: Timestamp) {
        self.fitnessGoal = fitnessGoal
        self.gainLossVal = gainLossVal
        self.currWeight = currWeight
        self.loseOrGain = ""
        // Convert Timestamp to Date
        self.lastUpdated = lastUpdated.dateValue()
        self.freeTimes = freeTimes
        print("FIT GOAL: \(self.fitnessGoal) GAIN LOSS \(self.gainLossVal)")
        
//        userRef.setData(["Goal": fitnessGoal, "Gym Habit Goal" : gymHabitGoal, "Current Weight" : currWeight, "GainOrLoss Value": gainLossVal, "Free Time" : freeTimes, "Last Updated": lastUpdated], merge: true)
    }
    
    init(fitnessGoal: String, gainLossVal: Int, currWeight: Double, freeTimes: [String: [String]]) {
        self.fitnessGoal = fitnessGoal
        self.gainLossVal = gainLossVal
        self.currWeight = currWeight
        self.loseOrGain = "Lose"
        lastUpdated = Date.now
        self.freeTimes = freeTimes
        self.freeTimes["Monday"] = []
        self.freeTimes["Tuesday"] = []
        self.freeTimes["Wednesday"] = []
        self.freeTimes["Thursday"] = []
        self.freeTimes["Friday"] = []
        self.freeTimes["Saturday"] = []
        self.freeTimes["Sunday"] = []
        
//        userRef.setData(["Goal": fitnessGoal, "Gym Habit Goal" : gymHabitGoal, "Current Weight" : currWeight, "GainOrLoss Value": gainLossVal, "Free Time" : freeTimes, "Last Updated": lastUpdated], merge: true)
    }
    
    func updateFirebaseGoal(userRef: DocumentReference) {
        userRef.setData(["Goal": fitnessGoal, "Current Weight" : currWeight, "GainOrLoss Value": gainLossVal, "Free Time" : freeTimes, "Last Updated": lastUpdated], merge: true)
    }
    
    func updateFreeTimes(newTimes: [String: [String]]) {
        self.freeTimes = newTimes
    }
    
    func addFreeTimes(dayOfWeek:String, timeToAdd:String) {
        // Check if timeToAdd already exists in the list for the specified day
            if let existingTimes = freeTimes[dayOfWeek], !existingTimes.contains(timeToAdd) {
                // The timeToAdd is not in the list; add it
                freeTimes[dayOfWeek]?.append(timeToAdd)
                lastUpdated = Date.now
                // userRef.updateData(["Free Time": freeTimes, "Last Updated": lastUpdated])
            } else {
                // Handle the case where timeToAdd is already in the list
                print("Time already exists for \(dayOfWeek): \(timeToAdd)")
            }
    }
    
    // Fitness Goal
    func changeGoal(fitnessGoal: String) {
        self.fitnessGoal = fitnessGoal
        lastUpdated = Date.now
        //userRef.updateData(["Goal": loseOrGain, "Last Updated": lastUpdated])
    }
    
    // If they want to cut (lose) or bulk (gain), this is also changing fitness goal
    func changeLoseOrGain(loseOrGain: String) {
        self.loseOrGain = loseOrGain
        lastUpdated = Date.now
//        userRef.updateData(["Goal": loseOrGain, "Last Updated": lastUpdated])
    }
    
    // The amount they want to lose or gain in pounds
    func changeGainLossVal(gainLossVal: Int) {
        self.gainLossVal = gainLossVal
        print(gainLossVal)
        lastUpdated = Date.now
//        userRef.updateData(["GainOrLoss Value": gainLossVal, "Last Updated": lastUpdated])
    }
    
    
    // The current weight
    func changeCurrWeight(currWeight: Double) {
        self.currWeight = currWeight
        lastUpdated = Date.now
//        userRef.updateData(["Current Weight": currWeight, "Last Updated": lastUpdated])
    }
    
    func getLoseOrGain() -> String {
        return self.loseOrGain
    }
    
    func getFitnessGoal() -> String {
        return self.fitnessGoal
    }
    
    func getWeightChangeGoal() -> Int {
        return self.gainLossVal
    }
    
    func getCurrWeight() -> Double {
        return self.currWeight
    }
    
    func getLastUpdatedDate() -> Date {
        return lastUpdated
    }
    
    func getFreeTimes() -> [String: [String]] {
        return freeTimes
    }
}

class FreeTimeTableViewCell: UITableViewCell
{
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
}
